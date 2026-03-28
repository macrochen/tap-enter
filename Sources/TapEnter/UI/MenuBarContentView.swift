import SwiftUI

struct MenuBarContentView: View {
    @EnvironmentObject private var snippetStore: SnippetStore
    @EnvironmentObject private var permissionService: PermissionService
    @EnvironmentObject private var typingService: TypingService
    @EnvironmentObject private var shortcutManager: ShortcutManager
    @EnvironmentObject private var launchAtLoginService: LaunchAtLoginService
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tap Enter")
                .font(.headline)

            Text(permissionService.isAccessibilityGranted ? "辅助功能权限已授权" : "需要辅助功能权限")
                .font(.subheadline)
                .foregroundStyle(permissionService.isAccessibilityGranted ? .green : .orange)

            Text("目标应用: \(typingService.lastTargetName)")
                .font(.footnote)
                .foregroundStyle(.secondary)

            Text(launchAtLoginService.statusMessage)
                .font(.footnote)
                .foregroundStyle(.secondary)

            Divider()

            ForEach(snippetStore.snippets) { snippet in
                Button("\(snippet.title)  \(snippet.shortcut.displayText)") {
                    shortcutManager.triggerSnippet(id: snippet.id)
                }
                .disabled(!snippet.isEnabled)
            }

            Divider()

            Button("打开设置") {
                openWindow(id: "settings")
            }

            Button("申请辅助功能权限") {
                permissionService.requestAccessibilityPermission()
            }

            Toggle(
                "登录时启动",
                isOn: Binding(
                    get: { launchAtLoginService.isEnabled },
                    set: { launchAtLoginService.setEnabled($0) }
                )
            )

            Button("退出") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding(14)
        .onAppear {
            permissionService.refresh()
            launchAtLoginService.refresh()
        }
    }
}
