//
//  TimerViewModel.swift
//  TinyTimer
//
//  Created by Abdul Momen on 14/8/26.
//

import Combine
import Foundation

@MainActor
final class TimerViewModel: ObservableObject {

    // MARK: - Published State

    @Published private(set) var elapsed: TimeInterval = 0
    @Published private(set) var state: TimerState = .stopped

    // MARK: - Dependencies

    private let timerService: TimerService
    private let clipboardService: ClipboardServiceProtocol
    private let screenLockMonitor: ScreenLockMonitoring

    // MARK: - Settings

    /// Mirrors the "Auto-pause when locked" toggle in TimerView.
    /// Read fresh from UserDefaults each time a lock/unlock event fires,
    /// so the setting takes effect immediately without needing a binding.
    private var autoPauseOnLock: Bool {
        UserDefaults.standard.object(forKey: "autoPauseOnLock") as? Bool ?? true
    }

    // MARK: - Private State

    private var wasRunningBeforeLock = false

    // MARK: - Initialization

    init(
        timerService: TimerService? = nil,
        clipboardService: ClipboardServiceProtocol? = nil,
        screenLockMonitor: ScreenLockMonitoring? = nil
    ) {
        let timerService = timerService ?? TimerService()
        let clipboardService = clipboardService ?? ClipboardService()
        let screenLockMonitor = screenLockMonitor ?? ScreenLockMonitor()

        self.timerService = timerService
        self.clipboardService = clipboardService
        self.screenLockMonitor = screenLockMonitor

        configureTimer()
        configureScreenLockHandling()

        screenLockMonitor.start()
    }

    // MARK: - UI State

    var isRunning: Bool {
        state == .running
    }

    var displayTime: String {
        TimeFormatter.clock(elapsed)
    }

    var menuBarTime: String {
        TimeFormatter.jira(elapsed)
    }

    // MARK: - Actions

    func toggleTimer() {
        timerService.toggle()
    }

    func startTimer() {
        timerService.start()
    }

    func pauseTimer() {
        timerService.pause()
    }

    func copyTime(reset: Bool) {
        guard elapsed > 0 else {
            return
        }

        let formattedTime = TimeFormatter.jira(elapsed)

        clipboardService.copy(formattedTime)

        if reset {
            timerService.reset()
            timerService.start()
        }
    }

    func reset() {
        timerService.reset()
    }

    // MARK: - Timer Binding

    private func configureTimer() {
        timerService.onUpdate = { [weak self] elapsed, state in
            self?.elapsed = elapsed
            self?.state = state
        }
    }

    // MARK: - Screen Lock

    private func configureScreenLockHandling() {

        screenLockMonitor.onLock = { [weak self] in
            self?.handleScreenLocked()
        }

        screenLockMonitor.onUnlock = { [weak self] in
            self?.handleScreenUnlocked()
        }
    }

    private func handleScreenLocked() {
        guard autoPauseOnLock else {
            return
        }

        wasRunningBeforeLock = isRunning

        guard wasRunningBeforeLock else {
            return
        }

        timerService.pause()
    }

    private func handleScreenUnlocked() {
        guard wasRunningBeforeLock else {
            return
        }

        wasRunningBeforeLock = false

        timerService.start()
    }
}
