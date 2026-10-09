param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("Prompt", "Status", "Write", "Read", "Delete")]
  [string]$Command,
  [Parameter(Mandatory = $true)][string]$TargetName,
  [string]$PipeName
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;

public static class RobCreatorAnalyticsCredentialManager {
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    private struct CREDENTIAL {
        public UInt32 Flags;
        public UInt32 Type;
        public string TargetName;
        public string Comment;
        public System.Runtime.InteropServices.ComTypes.FILETIME LastWritten;
        public UInt32 CredentialBlobSize;
        public IntPtr CredentialBlob;
        public UInt32 Persist;
        public UInt32 AttributeCount;
        public IntPtr Attributes;
        public string TargetAlias;
        public string UserName;
    }

    [DllImport("advapi32.dll", EntryPoint = "CredWriteW", CharSet = CharSet.Unicode, SetLastError = true)]
    private static extern bool CredWrite(ref CREDENTIAL credential, UInt32 flags);
    [DllImport("advapi32.dll", EntryPoint = "CredReadW", CharSet = CharSet.Unicode, SetLastError = true)]
    private static extern bool CredRead(string target, UInt32 type, UInt32 flags, out IntPtr credential);
    [DllImport("advapi32.dll", EntryPoint = "CredDeleteW", CharSet = CharSet.Unicode, SetLastError = true)]
    private static extern bool CredDelete(string target, UInt32 type, UInt32 flags);
    [DllImport("advapi32.dll", SetLastError = false)]
    private static extern void CredFree(IntPtr buffer);

    public static bool Exists(string target) {
        IntPtr pointer;
        bool found = CredRead(target, 1, 0, out pointer);
        if (found) CredFree(pointer);
        int error = Marshal.GetLastWin32Error();
        if (!found && error != 1168) throw new InvalidOperationException();
        return found;
    }

    public static void Write(string target, byte[] bytes) {
        IntPtr blob = Marshal.AllocCoTaskMem(bytes.Length);
        try {
            Marshal.Copy(bytes, 0, blob, bytes.Length);
            CREDENTIAL credential = new CREDENTIAL {
                Type = 1,
                TargetName = target,
                CredentialBlobSize = (UInt32)bytes.Length,
                CredentialBlob = blob,
                Persist = 2,
                UserName = "global-analytics-api-key"
            };
            if (!CredWrite(ref credential, 0)) throw new InvalidOperationException();
        } finally {
            for (int i = 0; i < bytes.Length; i++) Marshal.WriteByte(blob, i, 0);
            Marshal.FreeCoTaskMem(blob);
            Array.Clear(bytes, 0, bytes.Length);
        }
    }

    public static byte[] Read(string target) {
        IntPtr pointer;
        if (!CredRead(target, 1, 0, out pointer)) {
            int error = Marshal.GetLastWin32Error();
            if (error == 1168) return null;
            throw new InvalidOperationException();
        }
        try {
            CREDENTIAL credential = Marshal.PtrToStructure<CREDENTIAL>(pointer);
            byte[] bytes = new byte[credential.CredentialBlobSize];
            Marshal.Copy(credential.CredentialBlob, bytes, 0, bytes.Length);
            return bytes;
        } finally {
            CredFree(pointer);
        }
    }

    public static bool Delete(string target) {
        if (CredDelete(target, 1, 0)) return true;
        int error = Marshal.GetLastWin32Error();
        if (error == 1168) return false;
        throw new InvalidOperationException();
    }
}
'@

function Test-Credential([string]$Value) {
  if ([string]::IsNullOrEmpty($Value)) { return $false }
  $bytes = [Text.Encoding]::UTF8.GetBytes($Value)
  try {
    if ($bytes.Length -gt 2560) { return $false }
    return -not [Text.RegularExpressions.Regex]::IsMatch($Value, "\p{Cc}")
  } finally {
    [Array]::Clear($bytes, 0, $bytes.Length)
  }
}

function Write-SecretPipe([byte[]]$Bytes) {
  if ([string]::IsNullOrWhiteSpace($PipeName)) { throw [InvalidOperationException]::new() }
  $pipe = [IO.Pipes.NamedPipeClientStream]::new(".", $PipeName, [IO.Pipes.PipeDirection]::Out)
  try {
    $pipe.Connect(10000)
    $pipe.Write($Bytes, 0, $Bytes.Length)
    $pipe.Flush()
  } finally {
    $pipe.Dispose()
  }
}

try {
  if ($Command -eq "Status") {
    if ([RobCreatorAnalyticsCredentialManager]::Exists($TargetName)) { exit 0 }
    exit 10
  }
  if ($Command -eq "Delete") {
    if ([RobCreatorAnalyticsCredentialManager]::Delete($TargetName)) { exit 0 }
    exit 10
  }
  if ($Command -eq "Write") {
    $value = [Console]::In.ReadToEnd()
    if (-not (Test-Credential $value)) { exit 3 }
    $bytes = [Text.Encoding]::UTF8.GetBytes($value)
    try { [RobCreatorAnalyticsCredentialManager]::Write($TargetName, $bytes) }
    finally { [Array]::Clear($bytes, 0, $bytes.Length); $value = $null }
    exit 0
  }
  if ($Command -eq "Read") {
    $bytes = [RobCreatorAnalyticsCredentialManager]::Read($TargetName)
    if ($null -eq $bytes) { exit 10 }
    try { Write-SecretPipe $bytes }
    finally { [Array]::Clear($bytes, 0, $bytes.Length) }
    exit 0
  }

  Add-Type -AssemblyName System.Windows.Forms
  Add-Type -AssemblyName System.Drawing
  $form = [Windows.Forms.Form]::new()
  $form.Text = "Rob Creator Analytics Credential"
  $form.Size = [Drawing.Size]::new(520, 180)
  $form.StartPosition = "CenterScreen"
  $form.TopMost = $true
  $label = [Windows.Forms.Label]::new()
  $label.Text = "Enter the global Roblox Open Cloud Analytics API key."
  $label.AutoSize = $true
  $label.Location = [Drawing.Point]::new(15, 15)
  $box = [Windows.Forms.TextBox]::new()
  $box.UseSystemPasswordChar = $true
  $box.Size = [Drawing.Size]::new(470, 24)
  $box.Location = [Drawing.Point]::new(15, 45)
  $continue = [Windows.Forms.Button]::new()
  $continue.Text = "Continue"
  $continue.Size = [Drawing.Size]::new(100, 30)
  $continue.Location = [Drawing.Point]::new(275, 85)
  $continue.DialogResult = [Windows.Forms.DialogResult]::OK
  $cancel = [Windows.Forms.Button]::new()
  $cancel.Text = "Cancel"
  $cancel.Size = [Drawing.Size]::new(100, 30)
  $cancel.Location = [Drawing.Point]::new(385, 85)
  $cancel.DialogResult = [Windows.Forms.DialogResult]::Cancel
  $form.AcceptButton = $continue
  $form.CancelButton = $cancel
  $form.Controls.AddRange(@($label, $box, $continue, $cancel))
  if ($form.ShowDialog() -ne [Windows.Forms.DialogResult]::OK) { exit 2 }
  $value = $box.Text
  $box.Text = ""
  if (-not (Test-Credential $value)) { exit 3 }
  $bytes = [Text.Encoding]::UTF8.GetBytes($value)
  try { Write-SecretPipe $bytes }
  finally { [Array]::Clear($bytes, 0, $bytes.Length); $value = $null; $form.Dispose() }
  exit 0
} catch {
  exit 20
}
