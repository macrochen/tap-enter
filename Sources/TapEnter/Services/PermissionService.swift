@preconcurrency import ApplicationServices
import Foundation

@MainActor
final class PermissionService: ObservableObject {
    @Published private(set) var isAccessibilityGranted = AXIsProcessTrusted()

    func refresh() {
        isAccessibilityGranted = AXIsProcessTrusted()
    }

    func requestAccessibilityPermission() {
        let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: true] as CFDictionary
        isAccessibilityGranted = AXIsProcessTrustedWithOptions(options)
    }
}
