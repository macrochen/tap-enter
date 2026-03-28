import SwiftUI

struct SnippetEditorCard: View {
    @Binding var snippet: Snippet

    let onSendTest: (Snippet) -> Void

    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 12) {
                Toggle("启用这条快捷短语", isOn: $snippet.isEnabled)

                TextField("名称", text: $snippet.title)
                    .textFieldStyle(.roundedBorder)

                TextField("输入内容", text: $snippet.content, axis: .vertical)
                    .lineLimit(2...5)
                    .textFieldStyle(.roundedBorder)

                shortcutEditor

                Toggle("发送后自动回车", isOn: $snippet.autoEnter)

                VStack(alignment: .leading, spacing: 6) {
                    Text("发送延迟 \(snippet.sendDelayMilliseconds) ms")
                    Slider(
                        value: Binding(
                            get: { Double(snippet.sendDelayMilliseconds) },
                            set: { snippet.sendDelayMilliseconds = Int($0) }
                        ),
                        in: 50...400,
                        step: 10
                    )
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("逐字间隔 \(snippet.keyIntervalMilliseconds) ms")
                    Slider(
                        value: Binding(
                            get: { Double(snippet.keyIntervalMilliseconds) },
                            set: { snippet.keyIntervalMilliseconds = Int($0) }
                        ),
                        in: 0...40,
                        step: 1
                    )
                    Text("聊天软件或网页输入框如果偶尔丢字，可以适当调大。")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Button("测试发送") {
                        onSendTest(snippet)
                    }
                    .buttonStyle(.borderedProminent)

                    Spacer()
                }
            }
            .padding(.top, 4)
        } label: {
            Text(snippet.title.isEmpty ? "未命名短语" : snippet.title)
                .font(.headline)
        }
    }

    private var shortcutEditor: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("快捷键")

            HStack {
                ForEach(Shortcut.Modifier.allCases) { modifier in
                    Toggle(
                        modifier.label,
                        isOn: Binding(
                            get: { snippet.shortcut.modifiers.contains(modifier) },
                            set: { enabled in
                                if enabled {
                                    if !snippet.shortcut.modifiers.contains(modifier) {
                                        snippet.shortcut.modifiers.append(modifier)
                                    }
                                } else {
                                    snippet.shortcut.modifiers.removeAll { $0 == modifier }
                                }
                            }
                        )
                    )
                    .toggleStyle(.checkbox)
                }
            }

            Picker("按键", selection: $snippet.shortcut.key) {
                ForEach(Shortcut.supportedKeys, id: \.self) { key in
                    Text(key).tag(key)
                }
            }
            .pickerStyle(.menu)

            Text("当前组合: \(snippet.shortcut.displayText)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
