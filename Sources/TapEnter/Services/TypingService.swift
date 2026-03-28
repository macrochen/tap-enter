import AppKit
@preconcurrency import ApplicationServices
import Foundation

@MainActor
final class TypingService: ObservableObject {
    @Published private(set) var statusMessage = "等待快捷键触发。"
    @Published private(set) var lastTargetName = "未记录目标应用"

    private var lastExternalApp: NSRunningApplication?
    private let notificationCenter = NSWorkspace.shared.notificationCenter

    init() {
        observeActivatedApplications()
    }

    func send(snippet: Snippet, permissionService: PermissionService) {
        permissionService.refresh()

        guard permissionService.isAccessibilityGranted else {
            statusMessage = "缺少辅助功能权限，无法发送文本。"
            return
        }

        guard let target = currentTargetApplication() else {
            statusMessage = "请先切到目标应用一次，再使用快捷键。"
            return
        }

        statusMessage = "正在发送到 \(target.localizedName ?? "目标应用")..."
        lastExternalApp = target
        lastTargetName = target.localizedName ?? "未知应用"

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(snippet.sendDelayMilliseconds))
            await type(snippet.content, keyIntervalMilliseconds: snippet.keyIntervalMilliseconds)
            if snippet.autoEnter {
                pressReturn()
            }
            statusMessage = "已发送: \(snippet.title)"
        }
    }

    private func observeActivatedApplications() {
        notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard
                let self,
                let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
                app.processIdentifier != ProcessInfo.processInfo.processIdentifier
            else {
                return
            }

            Task { @MainActor [weak self] in
                guard let self else { return }
                self.lastExternalApp = app
                self.lastTargetName = app.localizedName ?? "未知应用"
            }
        }
    }

    private func currentTargetApplication() -> NSRunningApplication? {
        if let frontmost = NSWorkspace.shared.frontmostApplication,
           frontmost.processIdentifier != ProcessInfo.processInfo.processIdentifier {
            return frontmost
        }

        return lastExternalApp
    }

    private func type(_ text: String, keyIntervalMilliseconds: Int) async {
        for scalar in text.unicodeScalars {
            guard let source = CGEventSource(stateID: .combinedSessionState) else { continue }

            let down = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: true)
            down?.keyboardSetUnicodeString(stringLength: 1, unicodeString: [UniChar(scalar.value)])
            down?.post(tap: .cghidEventTap)

            let up = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: false)
            up?.post(tap: .cghidEventTap)

            if keyIntervalMilliseconds > 0 {
                try? await Task.sleep(for: .milliseconds(keyIntervalMilliseconds))
            }
        }
    }

    private func pressReturn() {
        guard let source = CGEventSource(stateID: .combinedSessionState) else { return }
        let down = CGEvent(keyboardEventSource: source, virtualKey: 0x24, keyDown: true)
        let up = CGEvent(keyboardEventSource: source, virtualKey: 0x24, keyDown: false)
        down?.post(tap: .cghidEventTap)
        up?.post(tap: .cghidEventTap)
    }
}
