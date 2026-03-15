import SwiftUI
import AppKit

@main
struct ImageFixerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra("Image Fixer", systemImage: "photo.fill") {
            ContentView()
        }
        .menuBarExtraStyle(.window)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Optional: Hide dock icon if strictly a tray app
        // NSApp.setActivationPolicy(.accessory)
    }
}
