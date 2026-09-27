# Contributing

Build with `Source/Build.ps1`, then run `Test.ps1` from an interactive Windows desktop. Include the Windows version and any manual checks in your pull request.

Keep document changes separate from appearance changes where practical. Theme styles belong in `Source/Theme.xaml`, window UI in `Source/WindowDesign.cs`, and document logic in `Source/SilkNotes.cs`.

Preserve these behaviors:

- Cancel, Escape, and closing the save prompt keep the document and its recovery file.
- A failed or cancelled save must prevent leaving the note.
- Save replaces the destination only after serialization and flushing succeed.
- Tests use isolated data, never real notes or the normal app-data folder.
- Fonts come from the user's PC; image bytes stay in the saved document.

Add regression tests for changes to persistence or confirmation behavior. Check title-bar controls, resizing, keyboard navigation, and the smallest supported window size for UI changes. For DPI or snapping work, include manual results from the relevant Windows versions and monitors.

Comments should explain *why*, especially around WPF quirks. Keep jokes occasional and keep them out of user-facing text. Do not commit personal notes, local paths, recovery files, or generated binaries.

Contributions are provided under the project's MIT license.

For 1.3 changes, run Test-Installer.ps1 as well. Keep Markdown source independent of preview rendering. Translate UI keys in Localization.cs without modifying document text. Verify custom themes against canonical saved RTF colors. Folder operations must preserve existing files and reject invalid names.
