# ImageFixer (macOS Tray App)

A native macOS system tray application for quickly resizing images.

## Features
- **System Tray Access**: Quickly open the app from your menu bar.
- **Paste & Load**: Paste images directly (Cmd+V) or load them from disk.
- **Smart Resizing**:
  - Proportional scaling by default.
  - Support for math expressions in resolution fields (e.g., `1920*2`, `1080/1.5`).
- **Export to Clipboard**:
  - Copies the resized image as TIFF data for maximum compatibility.
  - Automatically clears the app's state and closes the window after export.
- **Visual Feedback**: Success indicator when resizing is successful.
- **Clear Button**: Reset the modal back to its default state at any time.

## Requirements
- macOS 14.0 or later.

## How to Build
To create a standalone `.app` bundle, run the included build script:
```bash
./build.sh
```
The application will be available in `build/ImageFixer.app`.

## How to Test
To test the app before compiling, run the following:
```bash
swift run
```

## Usage
1. Click the photo icon in your system tray.
2. Paste an image (Cmd+V) or click "Load from Disk".
3. Enter new dimensions or math expressions in the Width/Height fields.
4. Click **Resize**.
5. Click **Export to Clipboard**. The window will automatically close and clear your progress.
