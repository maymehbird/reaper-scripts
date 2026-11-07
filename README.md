# maymehbird ReaScripts

REAPER automation scripts, distributed and updated using [ReaPack](https://reapack.com/).
This is a **general-purpose repository**: additional scripts can be added under `Tracks/`, `Items/`, `MIDI/`, or `FX/` later without creating a separate GitHub repository.

## Install in REAPER

1. Install [ReaPack](https://reapack.com/) if needed.
2. In REAPER, open **Extensions → ReaPack → Import repositories…**.
3. Import this URL:
   `https://raw.githubusercontent.com/maymehbird/reaper-scripts/main/index.xml`
4. Choose **Extensions → ReaPack → Browse packages**, search for **Auto Exclusive Solo**, and install it.
5. Open **Actions → Show action list**, locate **Script: maymehbird_Auto_Exclusive_Solo.lua** and run it **once per REAPER session**.

> ReaPack installs and updates scripts, but does **not** start this background script automatically. To run it at every REAPER launch, optionally use the SWS/S&M extension's global startup action feature to invoke this script action.

## Available packages

### Tracks / Auto Exclusive Solo

Normal left-click on the **S** (Solo) button still works in TCP and MCP. When a new normal solo is detected, any previously soloed tracks are cleared automatically.

- Clicking an already soloed track can turn solo off normally.
- If multiple tracks are soloed in one operation, the newly soloed group is retained.
- Solo-safe states (5/6) are preserved.
- Existing solo states are preserved when the script starts or when switching project tabs.
- Operates on regular tracks; does not process the master track.
- Other actions or scripts that change solo states can also trigger the behavior; this is a **solo-state watcher**, not a literal mouse-click interceptor.
- The change is applied on a subsequent REAPER UI cycle: momentary overlap is possible.

**Status:** untested inside an actual REAPER instance. Please audition and verify your routing/solo-safe behavior before depending on it during recording or live streaming.

## Adding packages

1. Add a new `.lua`, `.eel`, `.py`, or `.jsfx` file in a suitable **category subdirectory**.
2. Put at least `@version` in the script header; include `@description`, `@author`, `@about`, and `@changelog` as appropriate.
3. Push to `main` (preferably after reviewing and merging a PR).
4. GitHub Actions runs [reapack-index](https://github.com/cfillion/reapack-index) to generate `index.xml`, then commits the updated index. ReaPack users can synchronize to discover updates.
5. **Increment `@version` when publishing a new version.** Previously indexed versions are retained.

## CI & initial publication

- `Validate ReaPack packages` checks package metadata on pushes and pull requests.
- `Publish ReaPack index` runs only on `main` and commits generated package metadata.
- The initial `index.xml` is an intentionally **empty, valid ReaPack index**. The first successful publication workflow populates it with packages and commit-specific download URLs.
- If the publish job cannot push, check **Settings → Actions → General → Workflow permissions** and repository/organization branch protection rules. GitHub Actions needs permission to write `index.xml` to `main`. If publishing through branch protection is prohibited, use a PR-based publish workflow instead of bypassing protection.
- Use a **public** GitHub repository for unauthenticated ReaPack clients to access `index.xml` and script download URLs. The user chooses the eventual software license; none is asserted here.

## Maintenance

Files with ReaPack metadata belong in category directories. Do not manually edit generated package entries in `index.xml`. For dependency changes or behavior changes, update the script and bump `@version` in the same PR.
