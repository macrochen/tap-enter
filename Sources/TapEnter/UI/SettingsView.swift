import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var snippetStore: SnippetStore
    @EnvironmentObject private var permissionService: PermissionService
    @EnvironmentObject private var typingService: TypingService
    @EnvironmentObject private var shortcutManager: ShortcutManager
    @EnvironmentObject private var launchAtLoginService: LaunchAtLoginService

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 18) {
                header
                snippetList
                footer
            }
            .padding(20)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tap Enter")
                .font(.system(size: 30, weight: .bold, design: .rounded))
            Text("为最多 5 条高频回复绑定全局快捷键，实现一按即发。")
                .foregroundStyle(.secondary)

            HStack {
                Label(permissionService.isAccessibilityGranted ? "辅助功能权限已授权" : "需要辅助功能权限", systemImage: "figure.wave")
                Spacer()
                Toggle(
                    "登录时启动",
                    isOn: Binding(
                        get: { launchAtLoginService.isEnabled },
                        set: { launchAtLoginService.setEnabled($0) }
                    )
                )
                .toggleStyle(.switch)
                Button("申请权限") {
                    permissionService.requestAccessibilityPermission()
                }
                Button("恢复默认短语") {
                    snippetStore.resetDefaults()
                }
            }
            .font(.subheadline)
        }
    }

    private var snippetList: some View {
        ScrollView {
            VStack(spacing: 14) {
                ForEach($snippetStore.snippets) { $snippet in
                    SnippetEditorCard(snippet: $snippet) { snippet in
                        typingService.send(snippet: snippet, permissionService: permissionService)
                    }
                }
            }
        }
    }

    private var footer: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(typingService.statusMessage)
            Text(shortcutManager.statusMessage)
                .foregroundStyle(.secondary)
            Text(launchAtLoginService.statusMessage)
                .foregroundStyle(.secondary)
        }
        .font(.footnote)
    }
}
