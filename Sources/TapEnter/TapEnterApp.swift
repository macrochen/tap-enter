import AppKit
import SwiftUI

@main
struct TapEnterApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    @StateObject private var snippetStore = SnippetStore()
    @StateObject private var permissionService = PermissionService()
    @StateObject private var typingService = TypingService()
    @StateObject private var shortcutManager = ShortcutManager()
    @StateObject private var launchAtLoginService = LaunchAtLoginService()

    var body: some Scene {
        MenuBarExtra("Tap Enter", systemImage: "keyboard.badge.ellipsis") {
            MenuBarContentView()
                .environmentObject(snippetStore)
                .environmentObject(permissionService)
                .environmentObject(typingService)
                .environmentObject(shortcutManager)
                .environmentObject(launchAtLoginService)
                .frame(width: 320)
        }

        Window("Tap Enter Settings", id: "settings") {
            SettingsView()
                .environmentObject(snippetStore)
                .environmentObject(permissionService)
                .environmentObject(typingService)
                .environmentObject(shortcutManager)
                .environmentObject(launchAtLoginService)
                .frame(minWidth: 760, minHeight: 520)
                .onAppear {
                    permissionService.refresh()
                    launchAtLoginService.refresh()
                    shortcutManager.configure(with: snippetStore.snippets, permissionService: permissionService, typingService: typingService)
                }
                .onChange(of: snippetStore.snippets) { _, snippets in
                    shortcutManager.configure(with: snippets, permissionService: permissionService, typingService: typingService)
                }
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }
}
