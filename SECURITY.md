# Security Policy

## Scope

This document applies to Rob Creator Analytics — Codex Plugin 0.1.0. It does not describe the Cursor Extension's installation or credential model.

Rob Creator Analytics is an independent project and is not developed, endorsed, or sponsored by Roblox Corporation.

## Report a sensitive security problem

GitHub Private Vulnerability Reporting is enabled for both platform repositories.

Use the repository corresponding to the affected platform:

- [macOS repository — Security](https://github.com/zaku1989/rob-creator-analytics-github-marketplace-validation/security)
- [Windows repository — Security](https://github.com/zaku1989/rob-creator-analytics-windows-marketplace-validation/security)

Open **Security**, then select **Report a vulnerability**.

Describe the affected version, platform, expected and actual behavior, and minimal reproduction steps. Do not include real API keys, tokens, private Analytics results, or complete local configuration files, even in a private report.

Do not publish sensitive vulnerability details, exploit instructions, or private data in a public Issue.

If you cannot access the private-reporting entry, do not post the details publicly. You may open a minimal, non-sensitive Issue asking for reporting assistance without disclosing the vulnerability.

## Report an ordinary problem

Use GitHub Issues for non-sensitive bugs and usage questions:

- [macOS Issues](https://github.com/zaku1989/rob-creator-analytics-github-marketplace-validation/issues)
- [Windows Issues](https://github.com/zaku1989/rob-creator-analytics-windows-marketplace-validation/issues)

Include versions, platform, expected and actual behavior, and minimal reproduction steps.

Do not attach keys, tokens, full local configuration, credential or Experience state files, private Analytics results, personal paths, or unredacted screenshots and logs.

## Protect your credentials

- Use a dedicated Roblox Open Cloud API key with only the required `universe.analytics:read` access.
- Restrict access to the Experiences you need and retain appropriate Roblox security restrictions.
- Enter the key only in the plugin's native masked credential window.
- Never send a key through chat, an Issue, a screenshot, a log, a repository, command-line arguments, or an environment variable.
- Do not manually edit credential storage, MCP configuration, or Experience state files to configure or recover the plugin.
- If you suspect exposure, revoke or rotate the key through Roblox immediately. Maintainers cannot revoke or recover your Roblox credentials.

One shared key is used across saved Experiences. Replacing or removing it affects access for all of them.

## Storage, execution, and privacy

Stored API keys use macOS Keychain or Windows Credential Manager. Non-secret Experience settings and runtime-cache files are stored locally and separately.

The MCP server and Management helper run locally. Analytics queries communicate with Roblox Open Cloud. Query results may enter the conversation and model context when the assistant uses them.

Operating-system credential storage does not make a compromised computer or user account safe. Protect your account and follow your organization's device and data policies.

Uninstalling the plugin does not itself delete saved keys or Experiences. Use supported Management operations when you explicitly want to remove local data.

## Single-action sandbox authorization

Use the normal Management workflow first.

Only after an explicit Codex sandbox permission error may you request one-time authorization for that same official Rob Creator Analytics Management action to run outside the sandbox.

Before approving, verify the action, the installed plugin's packaged helper, the data or credential access involved, and the single-action scope.

Copyable request:

> Codex reported a sandbox permission error for this action. Please request one-time authorization to run only this official Rob Creator Analytics Management action outside the sandbox. Show me the action and its scope before I decide whether to approve. Do not enable Full Access, change global sandbox or system security settings, or display any secret. If authorization is unavailable or denied, stop.

Sending this request does not grant permission. Do not approve unrelated commands, persistent permissions, or a broader session scope as a substitute.

This path worked in the tested macOS and Windows environments, but client capabilities and organization policies may prevent it. An unavailable or denied authorization must not be bypassed.

A Roblox authentication error or an unexplained runtime failure is not sufficient reason to request execution outside the sandbox.

## Current boundaries

Complete first-time setup on a brand-new device has not yet been verified. Update and upgrade lifecycle testing is deferred.

Some historical Experience records did not appear in a Windows environment. The cause has not been established and has not been attributed to upgrading to 0.1.0.

These statements are not promises of upgrade safety, data recovery, or compatibility with every client policy.
