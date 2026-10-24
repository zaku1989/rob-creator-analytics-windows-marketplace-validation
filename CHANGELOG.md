# Changelog

This changelog covers Rob Creator Analytics — Codex Plugin only. It does not describe the Cursor Extension release history.

## 0.1.0

### Features

- Local Codex integration for macOS Apple Silicon / ARM64 and Windows x64.
- Bundled Node.js runtime; no separate Node.js installation required.
- Exactly three read-only Analytics MCP tools:
  - `lookup_analytics_capabilities`
  - `get_dimension_values`
  - `query_metric`
- A bundled verified capability snapshot for metric, dimension, and granularity discovery.
- Native masked API-key input through Rob Creator Analytics Management.
- API-key storage in macOS Keychain or Windows Credential Manager.
- Local saved-Experience management: add, list, inspect the current target, switch, and delete saved entries.
- One shared API key and one current Experience at a time.
- Platform-specific GitHub-hosted plugin marketplaces.
- Packaged Windows launchers with explicit process-scoped PowerShell execution-policy arguments.
- A visible native Windows credential prompt, with non-prompt credential helper operations hidden.

### Security and data handling

- The normal configuration workflow does not require secrets in chat, command-line arguments, environment variables, or configuration files.
- Analytics queries execute locally and communicate with Roblox Open Cloud.
- Returned Analytics data may enter the conversation and model context.
- Deleting a saved Experience affects its local entry, not the Roblox Experience itself.
- Uninstalling the plugin does not itself remove stored credentials or Experiences.

### Usage guidance

- Only after an explicit Codex sandbox permission error, users may request one-time authorization for the same official Management action to run outside the sandbox.
- Users must review the action and scope before deciding whether to approve.
- This guidance does not require Full Access, global sandbox-policy changes, or disabled system protections.
- The approval path depends on client capabilities and organization policy.

### Known limitations

- Installation succeeded in an existing macOS environment after the marketplace source was added again; version 0.1.0 ran successfully in the tested Windows x64 environment.
- Complete first-time setup on a brand-new device has not yet been verified.
- Update and upgrade lifecycle testing is deferred; reliable automatic upgrades, migration, and historical-data recovery are not guaranteed.
- Single-action authorization worked in the tested macOS and Windows environments but may not be available elsewhere.
- The cause of some historical Experience records not appearing in a Windows environment has not been established. It has not been attributed to upgrading to 0.1.0.
- Queries target one current Experience at a time.
- Capability availability depends on the bundled snapshot, Roblox API support, permissions, and available data.
- The plugin is not listed in the public Plugins Directory.

See [README.md](README.md) for usage and [SECURITY.md](SECURITY.md) for security reporting.
