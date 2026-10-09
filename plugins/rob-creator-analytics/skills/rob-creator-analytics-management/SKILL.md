---
name: rob-creator-analytics-management
description: Manage local Rob Creator Analytics setup, including the global Roblox Analytics API key, saved Experiences, Current Experience, and Analytics prerequisites. Use for setup, configuration, credential status or replacement, Experience switching, and missing-prerequisite recovery; do not use for Analytics interpretation or growth advice.
---

# Rob Creator Analytics Management

Use the local management helper for deterministic configuration actions. Do not edit plugin JSON, Experience state, MCP configuration, or OS credential storage directly.

## Helper invocation

Locate the installed plugin directory and set the invocation cwd explicitly to that directory. On macOS, use command `/bin/sh` with `./scripts/manage` as the first argument. On Windows x64, use command `powershell.exe` with `-NoLogo -NoProfile -NonInteractive -File` followed by `./scripts/manage.ps1`. Alternatively, pass the script's absolute path from any cwd. Pass paths and each helper argument separately; do not concatenate a shell command or invoke a relative script as the executable. Do not require or supply PLUGIN_ROOT or PLUGIN_DATA: launchers resolve their own script location and the stable native user data directory, ignoring legacy root overrides. Pass only one supported command below and parse its single JSON result. Do not use a user-installed Node runtime; bundled runtime assembly is managed by the plugin.

MCP and Management share `scripts/local-paths.json`: macOS uses `~/Library/Application Support/Rob Creator Analytics/Codex`, Windows uses `%LOCALAPPDATA%\Rob Creator Analytics\Codex`. Non-secret Experience state is under `state/`; verified Node reconstruction is under `runtime-cache/`. Credentials remain in the OS vault. Upgrades reuse these directories; uninstall does not delete data or credentials. No speculative migration of diagnostic or temporary state is performed.

| Intent | Helper arguments |
| --- | --- |
| Overall prerequisite readiness | `status` |
| API key status | `credential status` |
| Configure API key | `credential configure` |
| Replace API key | `credential replace` |
| Remove API key | `credential remove` |
| List saved Experiences | `experience list` |
| Show Current Experience | `experience current` |
| Add an Experience | `experience add --universe-id <canonical-id> [--display-name <name>]` |
| Switch by resolved internal ID | `experience switch --id <id>` |
| Delete by resolved internal ID | `experience delete --id <id>` |

Credential configure and replace open the native masked secure prompt. Never accept an API key from chat as credential transport. If the user includes one, do not echo it, place it in arguments, copy it to an environment variable, or write it to a file; invoke the prompt without the supplied value.

## Experience target resolution

Before switch or delete, run `experience list` and resolve the target exactly:

- A canonical Universe ID must exactly match `universeId`.
- A stable internal ID must exactly match `id`.
- A display name is trimmed at its outer boundary and must exactly match `displayName`.
- Never fuzzy-match a destructive or switching target.

If exactly one item matches, invoke switch or delete with its internal ID. If none match, explain that it was not found. If multiple items share a display name, do not guess or mutate state; show each candidate's display name and Universe ID and ask the user to choose.

An explicit request to remove the credential or delete one uniquely resolved Experience authorizes that local action. Questions about consequences, ambiguous targets, or requests without explicit mutation intent do not.

## Result handling

Treat helper output as the source of truth. Safe result codes include `ok`, `configured`, `replaced`, `removed`, `cancelled`, `already-present`, `already-absent`, `missing-credential`, `not-found`, `ambiguous`, `missing-current`, `state-corrupt`, `unsupported-state-version`, `state-error`, `vault-error`, and `unsupported-platform`. Do not expose raw exceptions, paths, state files, or vault details.

`status` reports credential presence, Experience count, Current Experience, and `analyticsReady`. Readiness means only that a credential and Current Experience exist; it does not test Roblox authorization, API health, or Analytics data.

If the credential is absent, use the configure workflow. If Current is missing, add or select an Experience. If both are missing, recommend configuring the credential and then adding or selecting an Experience, while allowing Experience management independently.

If an Analytics call returns a Roblox permission error while both prerequisites exist, explain that the current API key may lack Analytics permission for that Universe. Do not delete or recreate the Experience, treat Multi-Experience as corrupt, or run a live permission probe.

## Intent fixtures

- “配置 API Key” maps to `credential configure`.
- “换一个 API Key” maps to `credential replace`.
- “API Key 配好了吗” maps to `credential status`.
- “删除 API Key” maps to `credential remove`.
- “添加 Experience 123456” maps to `experience add --universe-id 123456`.
- “列出所有游戏” maps to `experience list`.
- “现在用哪个游戏” maps to `experience current`.
- “切换到 Game A” requires exact target resolution, then `experience switch --id <id>`.
- “删除 Game A” requires explicit intent and exact target resolution, then `experience delete --id <id>`.
- “为什么不能查数据” maps first to `status`, followed by the prerequisite guidance above.

This skill manages setup only. It does not analyze Roblox metrics, explain DAU or retention, design funnels or experiments, make growth recommendations, or add management MCP tools.
