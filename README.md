# maymehbird ReaScripts

REAPER automation scripts, distributed and updated using [ReaPack](https://reapack.com/).
This is a **general-purpose repository**: additional scripts can be added under `Tracks/`, `Items/`, `MIDI/`, or `FX/` later without creating a separate GitHub repository.

## 導入・起動方法（日本語）

### 1. ReaPackからインストールする

1. [ReaPack](https://reapack.com/) が未導入ならインストールする。
2. REAPERの **Extensions → ReaPack → Import repositories…** を開く。
3. 以下のURLを登録する（**初回だけ**。このリポジトリの別スクリプトを追加するときは不要）。
   `https://raw.githubusercontent.com/maymehbird/reaper-scripts/main/index.xml`
4. **Extensions → ReaPack → Browse packages** を開き、`Auto Exclusive Solo` を検索する。
5. 対象パッケージを選択して **Install**、続けて **Apply** でインストールを確定する。

### 2. Action Listから実行する

1. **Actions → Show action list…** を開く。
2. **Section** は `Main` にする。
3. **Filter** に `maymehbird` と入力する（**`Auto Exclusive Solo` ではなく `maymehbird` で検索**。Action Listにはファイル名で登録される）。
4. **`Script: maymehbird_Auto_Exclusive_Solo.lua`** を選択し、**Run** を押す。
5. トラックパネルまたはミキサーで「S」を普通にクリックして、以前の通常ソロが解除されるか確認する。

実行後はREAPER内でバックグラウンド動作する。ReaPackは**インストール・更新のみ**を行い、スクリプトは**自動では起動しない**。自動起動を設定しない場合は、REAPERを開くたびに手動で実行する。

### 3. REAPER起動時に自動実行する（任意・SWS/S&Mを使用）

[SWS/S&M Extension](https://www.sws-extension.org/) をインストールしている場合は、次の設定を**一度だけ**行う。

1. Action Listの **Main** セクションで、`maymehbird` を検索する。
2. `Script: maymehbird_Auto_Exclusive_Solo.lua` を右クリックし、**Copy selected action command ID**（または **Copy selected action cmdID / identifier string**）を選択する。ReaScriptの**アンダースコアで始まる識別子**を使う。
3. **Extensions → Startup actions → Set global startup action…** を開き、コピーした識別子を貼り付ける（メニューが見つからない場合はAction Listで `SWS/S&M: Set global startup action` を検索して実行する）。
4. REAPERを再起動して、ソロボタンをクリックしたとき自動的に動作することを確認する。

**注意:** SWSのグローバル起動アクションは設定枠が1つ。すでに別の起動アクションを登録している場合は上書きしないよう、既存の起動設定を確認し、必要ならカスタムアクションにまとめる。自動実行を解除するときは **Extensions → Startup actions → Clear global startup action** を使う。

### 4. 動作仕様と留意点

- TCP（トラックパネル）とMCP（ミキサー）のどちらでも動作。
- クリック自体を変更するのではなく、ソロ状態の変更を検出して**次のUI更新で以前の通常ソロを解除**するため、一瞬だけ複数ソロになることがある。
- Safe Soloは維持し、既存のソロはスクリプト開始時には変更しない。
- 実機での受入確認は未完了。録音・配信前にテスト用プロジェクトで確認すること。

## Install in REAPER (English)

1. Install [ReaPack](https://reapack.com/) if needed.
2. In REAPER, open **Extensions → ReaPack → Import repositories…** and add:
   `https://raw.githubusercontent.com/maymehbird/reaper-scripts/main/index.xml`
3. Open **Extensions → ReaPack → Browse packages**, search for **Auto Exclusive Solo**, choose **Install**, then click **Apply**.
4. Open **Actions → Show action list**; set **Section** to **Main** and search for **`maymehbird`** (the Action List uses the filename, not the package description).
5. Select **`Script: maymehbird_Auto_Exclusive_Solo.lua`** and click **Run**. The script stays active in the current REAPER session.

**Automatic startup is not enabled by ReaPack.** With [SWS/S&M](https://www.sws-extension.org/), right-click the action in the Action List, select **Copy selected action command ID**, then use **Extensions → Startup actions → Set global startup action…** to paste it. Restart REAPER to test. The SWS global startup action setting may replace a previously configured action.

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
