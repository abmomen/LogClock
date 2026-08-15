//
//  TinyTimerApp.swift
//  TinyTimer
//

import SwiftUI

@main
struct TinyTimerApp: App {

    @StateObject private var viewModel = TimerViewModel()

    var body: some Scene {
        MenuBarExtra {
            TimerView(viewModel: viewModel)
        } label: {
            
            Text(viewModel.displayTime)
                .monospacedDigit()
                .foregroundStyle(.primary)
                .contentTransition(.numericText())
        }
        .menuBarExtraStyle(.window)
    }
}
