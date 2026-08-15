//
//  TimerView.swift
//  TinyTimer
//

import SwiftUI

struct TimerView: View {
    
    @ObservedObject var viewModel: TimerViewModel
    
    @AppStorage("resetOnCopy")
    private var resetOnCopy = true
    
    @AppStorage("autoPauseOnLock")
    private var autoPauseOnLock = true
    
    @State private var isCopied = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Timer Display
            
            Text(viewModel.menuBarTime)
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.primary)
                .contentTransition(.numericText())
                .animation(.snappy, value: viewModel.elapsed)
                .padding(.top, 16)
                .padding(.bottom, 16)
            
            Divider()
            
            // MARK: - Timer Controls
            
            HStack(spacing: 4) {
                
                iconButton(
                    systemImage: viewModel.isRunning
                    ? "pause.fill"
                    : "play.fill",
                    help: viewModel.isRunning
                    ? "Pause Timer"
                    : "Start Timer",
                    tint: viewModel.isRunning ? .orange : .accentColor
                ) {
                    viewModel.toggleTimer()
                }
                .keyboardShortcut(.space, modifiers: [])
                
                iconButton(
                    systemImage: isCopied ? "checkmark" : "doc.on.doc",
                    help: resetOnCopy
                    ? "Copy Time & Reset"
                    : "Copy Time"
                ) {
                    viewModel.copyTime(reset: resetOnCopy)
                    flashCopiedState()
                }
                .disabled(viewModel.elapsed <= 0)
                
                Divider()
                    .frame(height: 16)
                    .padding(.horizontal, 6)
                
                iconButton(
                    systemImage: "power",
                    help: "Quit TinyTimer",
                    tint: .red
                ) {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("q")
            }
            .padding(.vertical, 12)
            
            Divider()
            
            // MARK: - Settings
            
            VStack(spacing: 10) {
                HStack {
                    Text("Restart on copy")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Toggle("", isOn: $resetOnCopy)
                        .toggleStyle(.switch)
                        .controlSize(.small)
                        .labelsHidden()
                }
                
                HStack {
                    Text("Pause on locked")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Toggle("", isOn: $autoPauseOnLock)
                        .toggleStyle(.switch)
                        .controlSize(.small)
                        .labelsHidden()
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
        }
        .frame(width: 220)
        .background(.regularMaterial)
    }
    
    // MARK: - Helpers
    
    private func flashCopiedState() {
        withAnimation(.snappy) { isCopied = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            withAnimation(.snappy) { isCopied = false }
        }
    }
    
    // MARK: - Icon Button
    
    private func iconButton(
        systemImage: String,
        help: String,
        tint: Color = .primary,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 14, weight: .medium))
                .frame(width: 34, height: 30)
                .contentShape(Rectangle())
        }
        .buttonStyle(SubtleHoverButtonStyle(tint: tint))
        .help(help)
    }
}

// MARK: - Subtle Hover Button Style

/// Gives toolbar-style icon buttons a light, native-feeling hover/press
/// highlight instead of the flat default `.plain` look.
private struct SubtleHoverButtonStyle: ButtonStyle {
    
    var tint: Color = .primary
    
    @State private var isHovering = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(configuration.isPressed ? tint : (isHovering ? tint : .primary))
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color.primary.opacity(configuration.isPressed ? 0.14 : (isHovering ? 0.08 : 0)))
            )
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
            .animation(.easeOut(duration: 0.12), value: isHovering)
            .onHover { hovering in
                isHovering = hovering
            }
    }
}
