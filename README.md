# Silk Notes

Created by **rybcia**. Version **1.3**.

A small, local Windows notepad with an Apple-inspired look, rich text, and a shark with a little attitude.

![Silk Notes](docs/app.png)

## New in 1.3

- A dedicated **Settings** window with English, Polish, German, and Romanian interface languages.
- System, Light, Dark, or Custom themes. Choose window, sidebar, paper, text, and accent colors with a color picker or hex values. Low-contrast text combinations are rejected to keep writing readable.
- Default font and size for new rich-text notes, optional Windows spell-check, and autosave controls.
- UTF-8 Markdown source editing and a separate reading preview.
- Browse an ordinary notes folder, create subfolders, and save new notes into the selected directory.
- Author credit **rybcia** in Settings and Windows application metadata.

![Settings](docs/settings.png)

## Included from 1.2

- Light, dark, and Windows-following appearance.
- Multiple tabs with independent undo history and recovery copies.
- Find and replace, including case-sensitive and whole-word matching.
- Optional autosave for named RTF files, with external-change protection.
- Focus mode hides the sidebar and formatting toolbar.
- A per-user Windows installer with shortcuts and an uninstaller.

## Features

- Custom title bar with minimize, maximize, restore, and close controls.
- A matching save prompt with **Keep editing**, **Discard changes**, and **Save note**.
- Bold, italic, underline, strikethrough, subscript, and superscript.
- Fonts installed on your PC and editable point sizes from 6 to 144.
- Titles, subtitles, three heading levels, and normal text.
- Text colors, highlighting, alignment, and bulleted or numbered lists.
- Embedded images with aspect-ratio-preserving resizing.
- RTF files, plain-text import, recent files, and local recovery copies.
- No account, telemetry, network requests, or third-party runtime packages.

![Custom save prompt](docs/save-prompt.png)

## Run

Run **SilkNotes-1.3-Setup.exe**, then choose **Install Silk Notes**. No administrator access is needed. The installer adds a Start menu shortcut and an optional desktop shortcut. Close any running version before installing an update.

Installs to `%LOCALAPPDATA%\Programs\Silk Notes`. Remove it through Windows Settings or the included `Uninstall.exe`. Uninstall removes only application files and shortcuts; your notes, recovery files, and preferences stay on your computer.

Targets Windows 10/11 with **.NET Framework 4.8 or newer**. The app and installer are unsigned. Windows may show a publisher warning. Some older Windows 10 installations need the [.NET Framework 4.8 runtime](https://dotnet.microsoft.com/download/dotnet-framework/net48).

## Build from source

Open PowerShell in this repository and run:

```powershell
.\Source\Build.ps1
& '.\bin\Silk Notes.exe'
# Build the redistributable installer:
.\Build-Installer.ps1
```

The build uses the .NET Framework C# compiler installed with Windows. No .NET SDK, NuGet restore, or internet connection is needed. The logo and theme are embedded in the executable.

## Test

```powershell
.\Test.ps1
.\Test-Installer.ps1
```

Tests open temporary WPF windows, exercise formatting and file round trips, click the custom window controls, and exercise the real save confirmation paths. Results and rendered screenshots go to `test-output/`. Test notes and recovery files are isolated from normal app data.

Also covered: tab isolation and undo, cross-format find/replace, single-step replace-all undo, disk autosave, external edit conflicts, per-tab recovery, cancellation while closing multiple tabs, saved-color consistency between themes, and focus mode. Installer tests extract the real embedded payload, upgrade it, create an isolated shortcut, run the installed app test suite, and verify uninstall preserves other files. They do not modify your real shortcuts or uninstall registry.

Covered: all paragraph presets, formatting, installed fonts, embedded image round trips, image sizing, minimize/maximize/restore, Keep editing, Escape, dialog close, successful save, failed save, and discard.

Still needs manual device coverage: Windows 10 and 11 separately, dragging and edge snapping, Windows 11 Snap Layout hover behavior, mixed-DPI monitors, keyboard-only navigation, and screen readers. Rendering was reviewed at 1180×940, 900×720, and maximized size. Tests need an interactive Windows desktop.

## Saving and recovery

Use `Ctrl+S` to save an RTF file or `Ctrl+Shift+S` for Save as. Images are embedded. Opening a `.txt` file and saving prompts for an RTF filename so the plain-text original stays intact.

Each dirty tab gets a recovery copy after two seconds of inactivity. Recovered notes reopen as unnamed tabs after an interrupted session; save them to keep them. Saving or explicitly discarding a tab removes its recovery copy. Cancelling a close-all prompt preserves deferred discards. App data lives in `%LOCALAPPDATA%\SilkNotes`. Only one regular instance runs at a time.

Autosave is **off by default**. Enable it in Settings to save named RTF and Markdown tabs after edits. New notes still need a first save. If a document is deleted or changed outside Silk Notes, autosave pauses for that tab, keeps recovery, and asks you to resolve the conflict during a manual save. Use Save as to preserve both versions.

Appearance changes affect the editor display, not the colors written to your RTF files.

## Markdown

Choose **New Markdown** or open a `.md` / `.markdown` file. Edit its plain-text source, then choose **Preview** to read it. **Edit source** returns to the same editor and undo history. Use Ctrl+S to save UTF-8 Markdown. Paste into Markdown inserts text only. Formatting controls are hidden in Markdown mode; write Markdown syntax instead.

The preview supports hash headings, basic bold/italic/strikethrough, inline and fenced code, flat lists, task markers, blockquotes, and horizontal rules. It is a small built-in renderer, not a full CommonMark/GFM implementation: nested formatting, tables, and nested lists are not fully rendered. Links and image references appear as labels and target text. No HTML executes, no URLs are opened, and no remote images are downloaded. Unsupported syntax remains in the source and is preserved when saving. Line endings are normalized to LF; final blank lines and Unicode are preserved.

Markdown notes use the same tab, autosave conflict protection, and recovery system as rich-text notes. Rich-text notes remain RTF; this release does not convert RTF into Markdown.

## Folders

Choose **Open folder…** in the sidebar. Expand folders and double-click a note (or select it and press Enter) to open it. Select a folder, then use **New folder** to create a child directory. New notes remain unsaved until Ctrl+S; the save dialog starts in the selected folder. **Refresh** picks up changes made in File Explorer. The app remembers the library root. It does not move or delete your existing notes. Directory junctions and symlinks are not traversed.

## Settings

Open **Settings**, choose a language or theme, and press **Apply settings**. Changes apply immediately. Defaults affect new RTF notes only. Markdown source uses a monospace font. Spell-check support depends on Windows dictionaries and the selected language; not every interface language has a WPF spelling dictionary on every PC. Windows file/color pickers and system error details may follow the OS language. Some secondary diagnostics and tooltips remain English.

Preferences live beside existing app data in `settings-v13.txt` and `preferences.txt`. Uninstall retains these files. Theme changes never rewrite note colors on disk.

## Keyboard shortcuts

| Shortcut | Action |
| --- | --- |
| Ctrl+N / Ctrl+O | New tab / open note |
| Ctrl+S / Ctrl+Shift+S | Save / Save as |
| Ctrl+W | Close current tab |
| Ctrl+Tab / Ctrl+Shift+Tab | Next / previous tab |
| Ctrl+F / Ctrl+H | Find / replace |
| F3 / Shift+F3 | Next / previous match |
| F11 | Toggle focus mode |
| Escape | Close search, or leave focus mode |

## Code map

| File | Responsibility |
| --- | --- |
| `Source/Settings.cs` | Preferences, color validation, settings UI and author credit |
| `Source/Localization.cs` | Four-language interface strings |
| `Source/Markdown.cs` | Markdown source persistence and safe reading preview |
| `Source/Folders.cs` | Folder library, browsing and creation |
| `Source/PersonalizationTests.cs` | Settings, languages, Markdown and folder regressions |
| `Source/Workspace.cs` | Tabs, autosave, recovery, preferences, safe RTF serialization |
| `Source/Appearance.cs` | Shared light/dark palette and Windows appearance |
| `Source/Search.cs` | Text-pointer matching and replacement |
| `Source/ReleaseTests.cs` | 1.2 integration tests and screenshots |
| `Installer/Setup.cs` | Per-user setup, upgrade, shortcuts, uninstall |
| `Source/Program.cs` | Startup, single-instance guard, test entry point |
| `Source/SilkNotes.cs` | Editor, formatting, recent files, persistence and recovery |
| `Source/WindowDesign.cs` | Native window integration, title bar, logo, custom prompts |
| `Source/Theme.xaml` | Shared button, toggle and combo-box styling |
| `Source/EditorTests.cs` | Editor and RTF integration tests |
| `Source/WindowTests.cs` | Window controls and save-prompt integration tests |
| `Source/MakeIcon.ps1` | Rebuilds multi-size ICO from the supplied logo PNG |

Comments explain the tricky WPF behavior and data-protection decisions. A couple of them swear. The UI doesn't.

## Known limits

Paragraph presets are visual formatting, not Word's named styles. GIFs insert as still images. Image resizing is saved but isn't in the text undo history. System file pickers remain native. Startup errors retain a native fallback. Recovery restores tabs automatically. This is not a full Word-compatible document editor.

## Publish on GitHub

Create an empty GitHub repository and upload this folder's contents, including the dotfiles, `LICENSE`, and `Source`. The repository root should contain this README. Keep generated binaries out of commits (`.gitignore` handles them); attach the Setup executable to a GitHub Release instead. The project is prepared locally and has not been published to any account.

## License

[MIT](LICENSE). Copyright © 2026 Silk Notes contributors. The shark artwork was supplied for this project; its original PNG is preserved in `Source/Assets/logo.png`. There are no downloaded third-party libraries or copied external code snippets in this repository.
