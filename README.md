# Rob Creator Analytics

Query Roblox Creator Analytics through natural language in a local Codex conversation in the OpenAI Desktop App.

**Version: 0.1.0 — Codex Plugin**

Rob Creator Analytics helps Roblox developers discover supported metrics, look up dimension values, and query Analytics data for the current Experience. Its Management Skill handles local API-key configuration and saved Experiences.

This is an independent project, not an official Roblox product or a Roblox-endorsed integration.

## Supported platforms and tested scope

- macOS Apple Silicon / ARM64
- Windows x64

The plugin includes its required Node.js runtime. No separate Node.js installation is required.

Installation succeeded in an existing macOS environment after the marketplace source was added again. Version 0.1.0 also ran successfully in the tested Windows x64 environment. A one-time authorization path for sandbox-blocked Management actions worked in both tested environments.

These results do not establish complete first-time setup on a brand-new device or compatibility with every Desktop build, operating-system version, account policy, or organization policy.

Browser-only use, WSL, remote hosts, cloud execution, and other processor platforms are outside this version's tested scope.

## Distribution

The plugin is distributed through GitHub-hosted plugin marketplaces. It is **not listed in the public Plugins Directory**.

Here, “GitHub Marketplace” means a plugin catalog hosted in a GitHub repository, not GitHub's separate Apps and Actions marketplace.

| Platform | Marketplace repository | Marketplace display name |
| --- | --- | --- |
| macOS ARM64 | https://github.com/zaku1989/rob-creator-analytics-github-marketplace-validation | Rob Creator Analytics Validation |
| Windows x64 | https://github.com/zaku1989/rob-creator-analytics-windows-marketplace-validation | Rob Creator Analytics Windows Validation |

Plugin identity: `rob-creator-analytics`  
Plugin display name: **Rob Creator Analytics**

This guide does not use Cursor VSIX installation, manual file copying, or a downloaded ZIP as a verified GUI installation path.

## Installation

The confirmed marketplace-addition workflow is the same on macOS and Windows. Control labels depend on the interface language; the steps below describe the actions rather than quote unverified English button labels.

1. Open the plugin section in the OpenAI Desktop App.
2. Open its add menu and choose the option for adding a plugin marketplace.
3. In the GitHub marketplace source form, enter the repository URL for your platform from the table above and complete the displayed prompts.
4. Open the matching marketplace in the plugin list.
5. Open **Rob Creator Analytics** and use the installation action shown in its details.
6. Check the plugin details:
   - Version: **0.1.0**
   - MCP Server display name: **Rob_creator_analytics**
   - Management Skill: **Rob Creator Analytics Management**
7. Start a new local Codex conversation.

The plugin interface also provides an installed-plugin management entry. Review its displayed actions before using them. Its availability does not establish that upgrades or data recovery are reliable.

If installation is blocked or the expected source is unavailable, stop and report the issue. Do not use custom installation scripts, manually edit MCP configuration, change system execution policies, disable security protections, or enable Full Access.

## The three MCP tools

| Tool | Purpose |
| --- | --- |
| `lookup_analytics_capabilities` | Find documented metrics, dimensions, and granularities in the verified capability snapshot bundled with the plugin |
| `get_dimension_values` | Look up valid dimension values for a metric within a time-range context |
| `query_metric` | Query one metric for the current Experience |

These Analytics tools are read-only. Management can change local configuration, credentials, and saved Experience entries when you request those actions.

Capability lookup describes the bundled snapshot. It is not a live guarantee that every metric or dimension is available to your account.

The Management Skill does not add management MCP tools. Interpretation of returned data is performed by the conversation's model.

## First-time setup

### 1. Prepare a Roblox Open Cloud API key

You need an Experience whose Analytics you are authorized to access, its Universe ID, and a dedicated Open Cloud API key.

In Roblox Creator Dashboard:

1. Open API Keys and create a dedicated key.
2. Under Access Permissions, choose the `universe-analytics` API system.
3. Grant `universe.analytics:read`.
4. Restrict access to the Experiences you need.
5. Retain appropriate security restrictions and confirm that the key is active.
6. Generate the key and keep it secure.

Do not grant publishing, Data Store write, or Analytics write permissions solely for this plugin.

For a Group-owned Experience, the account that owns the key must also have the appropriate permission to view its Analytics. A key scope does not grant the account new Group permissions.

References:

- [Roblox Analytics API](https://create.roblox.com/docs/cloud/guides/analytics)
- [Manage Roblox API keys](https://create.roblox.com/docs/cloud/auth/api-keys)
- [Roblox Group permissions](https://create.roblox.com/docs/projects/groups)

### 2. Check configuration

In a local Codex conversation, ask:

> Use Rob Creator Analytics Management to check whether an API key and a current Experience are configured. Do not display any secret.

Use the packaged Management Skill rather than editing configuration or state files.

### 3. Configure the API key

Ask:

> Use Rob Creator Analytics Management to configure my API key through its native secure input window. Do not receive or display the key in chat.

Enter the key only in the native window titled **Rob Creator Analytics Credential**, then select **Continue**.

- Input is masked.
- **Cancel** cancels the operation without saving a new key.
- If a key is already configured, explicitly ask to replace it.
- Cancelling replacement leaves the existing key unchanged.

The normal configuration workflow does not require the key in chat, command-line arguments, environment variables, or configuration files.

### 4. Handle an explicit Codex sandbox permission error

Try the normal Management workflow first.

Only if Codex explicitly reports a sandbox permission error, request one-time authorization for that same official Rob Creator Analytics Management action to run outside the sandbox.

Before deciding whether to approve, review:

- The action being performed.
- That it uses the installed plugin's packaged Management helper.
- The local data or credential access involved.
- That the request applies only to this action, not a session-wide or persistent permission expansion.

Copyable request:

> Codex reported a sandbox permission error for this action. Please request one-time authorization to run only this official Rob Creator Analytics Management action outside the sandbox. Show me the action and its scope before I decide whether to approve. Do not enable Full Access, change global sandbox or system security settings, or display any secret. If authorization is unavailable or denied, stop.

Sending this request is not itself approval.

This single-action path worked in the tested macOS and Windows environments, but it may be unavailable under other client or organization policies. Do not use it for an ordinary Roblox authentication error, an unexplained helper failure, or as a default setup step.

### 5. Add an Experience

Open the target Experience in Roblox Creator Dashboard and copy its **Universe ID**, not a Place ID.

Replace the placeholders before sending:

> Use Rob Creator Analytics Management to add the Experience with Universe ID `YOUR_UNIVERSE_ID` and display name `YOUR_DISPLAY_NAME`.

A successful add makes that Experience current. Adding an already-saved Universe ID selects the existing entry instead of creating a duplicate.

Adding an Experience does not verify Roblox authorization or change API-key permissions.

### 6. Confirm readiness

Ask:

> Check Rob Creator Analytics setup. Tell me whether a key is present and which Experience is current. Do not display the key.

“Ready” means a key and a current Experience are configured. It does not prove Roblox authorization, API availability, or the presence of Analytics data.

## Manage Experiences and credentials

Use **Rob Creator Analytics Management** in your requests. Replace placeholders with your own values.

| Intent | Example |
| --- | --- |
| List saved Experiences | “List my saved Experiences and mark the current one.” |
| Show the current target | “Which Experience is current?” |
| Switch | “Switch to the Experience with Universe ID YOUR_UNIVERSE_ID.” |
| Check key presence | “Is an API key configured? Do not show it.” |
| Replace the key | “Replace my API key using the native secure window.” |
| Remove the local key | “Remove the API key stored by Rob Creator Analytics.” |
| Delete a saved entry | “Delete the saved Experience with Universe ID YOUR_UNIVERSE_ID.” |

Names must match exactly. Use the Universe ID when names are ambiguous.

The plugin uses one shared API key and one current Experience at a time. Switching does not expand key permissions. The shared key must be authorized for each Experience you query.

Deleting a saved Experience removes its local entry, not the Roblox Experience itself. If you delete the current entry, the first remaining saved entry becomes current, or there is no current entry if none remain. Check the target afterward.

Removing the shared key affects queries for all saved Experiences.

## Example queries

> Find the available daily-active-user metrics and describe their supported dimensions and granularities. Do not query actual Analytics data yet.

> Before querying, tell me the current Experience and confirm the dates and timezone.

> Check the supported daily-active-user metric, then query the last seven complete UTC dates for the current Experience, by day. Explain unsupported requests instead of inventing results.

> Check whether this metric supports a country or region dimension. If it does, look up valid values for the selected date range.

> Query the current Experience separately for the last two complete weeks, then compare the returned data. Confirm the periods first and do not treat missing data as zero.

## Local execution, security, and privacy

The MCP server and Management helper run locally. Analytics queries are sent from the local runtime to Roblox Open Cloud.

Stored API keys use:

- macOS: system Keychain.
- Windows: Windows Credential Manager generic credentials.

Non-secret Experience settings and runtime-cache files are stored locally and separately from credentials. Do not manually edit credential storage or Experience state files.

Local execution does not mean returned data stays outside the model. Analytics results may enter the conversation and model context when the assistant uses them. Follow your organization's rules and the Desktop/model provider's data policies.

Never include secrets in prompts, issues, screenshots, logs, or repositories. See [SECURITY.md](SECURITY.md).

## Known limitations

- Complete first-time setup on a brand-new device has not yet been verified.
- Update and upgrade lifecycle testing is deferred. Reliable automatic upgrades, migration, and historical-data recovery are not promised.
- Management may require user-reviewed, single-action authorization after an explicit Codex sandbox permission error. Not every client or organization policy supports this path.
- Some historical Experience records did not appear in a Windows environment. The cause has not been established; this is not evidence that upgrading to 0.1.0 caused the issue.
- Queries target one current Experience at a time.
- Available metrics and dimensions depend on the bundled capability snapshot, Roblox API support, permissions, and available data.

Do not uninstall, reinstall, clear configuration, or run recovery scripts as an assumed upgrade or recovery procedure.

## Troubleshooting

| Symptom | Safe next step |
| --- | --- |
| Marketplace missing | Check the platform-specific repository and the marketplace-addition workflow above. If the expected interface is unavailable, stop and ask for guidance. |
| Plugin installed, tools unavailable | Start a new local Codex conversation and review the installed plugin's status in its management entry. Do not manually edit MCP configuration. |
| Explicit Codex sandbox permission error | Use the single-action authorization request in First-time setup. Review the action before approving; stop if approval is unavailable or denied. |
| Other helper or runtime failure | Report a sanitized error. Do not assume a sandbox failure or automatically request execution outside the sandbox. |
| Key or current Experience missing | Use Management setup. Never paste the key into chat. |
| Roblox authentication or permission error | Check key status, Analytics read permission, current Universe ID, and account/Group access. Do not request sandbox authorization for this error. |
| Empty results | Confirm supported capabilities, dates, timezone, and data availability. Do not assume missing data means zero. |
| Historical Experiences missing | Report the issue without editing state files or running recovery scripts. Do not assume an upgrade caused it. |

Uninstalling the plugin does not itself remove stored credentials or saved Experiences. Use supported Management operations when you explicitly want to remove local data.

## Feedback and security reports

For ordinary, non-sensitive problems:

- [macOS Issues](https://github.com/zaku1989/rob-creator-analytics-github-marketplace-validation/issues)
- [Windows Issues](https://github.com/zaku1989/rob-creator-analytics-windows-marketplace-validation/issues)

Include the plugin version, operating-system version and architecture, Desktop version, expected/actual behavior, reproduction steps, and sanitized errors.

Do not include keys, tokens, complete configuration files, private Analytics data, personal paths, or unredacted screenshots and logs.

GitHub Private Vulnerability Reporting is enabled for both platform repositories. For sensitive security problems, open the corresponding repository's **Security** tab and select **Report a vulnerability**. Do not disclose sensitive details in a public Issue.

See [SECURITY.md](SECURITY.md) for reporting guidance.

## License and affiliation

The plugin is licensed under [Apache-2.0](plugins/rob-creator-analytics/LICENSE.txt). The bundled Node.js license is included at [licenses/NODE_LICENSE.txt](plugins/rob-creator-analytics/licenses/NODE_LICENSE.txt).

Rob Creator Analytics is not developed, endorsed, or sponsored by Roblox Corporation. Roblox names and marks belong to their respective owners.
