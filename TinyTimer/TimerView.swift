//
//  TimerView.swift
//  TinyTimer
//

import SwiftUI

struct TimerView: View {

    @ObservedObject var viewModel: TimerViewModel

    @AppStorage("resetOnCopy")
    private var resetOnCopy = true

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Timer Controls

            HStack(spacing: 6) {

                iconButton(
                    systemImage: viewModel.isRunning
                        ? "pause.fill"
                        : "play.fill",
                    help: viewModel.isRunning
                        ? "Pause Timer"
                        : "Start Timer"
                ) {
                    viewModel.toggleTimer()
                }
                .keyboardShortcut(.space, modifiers: [])

                iconButton(
                    systemImage: "doc.on.doc",
                    help: resetOnCopy
                        ? "Copy Time & Reset"
                        : "Copy Time"
                ) {
                    viewModel.copyTime(reset: resetOnCopy)
                }
                .disabled(viewModel.elapsed <= 0)

                Divider()
                    .frame(height: 18)
                    .padding(.horizontal, 4)

                iconButton(
                    systemImage: "power",
                    help: "Quit TinyTimer"
                ) {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("q")
            }
            .padding(12)

            Divider()

            // MARK: - Settings

            HStack {
                Toggle(
                    "Reset after copying",
                    isOn: $resetOnCopy
                )
                .toggleStyle(.checkbox)
                .controlSize(.small)

                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
    }

    // MARK: - Icon Button

    private func iconButton(
        systemImage: String,
        help: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 14, weight: .medium))
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .foregroundStyle(.primary)
        .help(help)
    }
}
