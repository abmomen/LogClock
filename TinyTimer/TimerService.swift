//
//  TimerService.swift
//  TinyTimer
//
//  Created by Abdul Momen on 14/8/26.
//

import Foundation

@MainActor
final class TimerService {

    // MARK: - Output

    var onUpdate: ((TimeInterval, TimerState) -> Void)?

    // MARK: - State

    private(set) var elapsed: TimeInterval = 0
    private(set) var state: TimerState = .stopped

    // MARK: - Private Properties

    private var startedAt: Date?
    private var accumulatedTime: TimeInterval = 0

    private var updateTask: Task<Void, Never>?

    // MARK: - Lifecycle

    deinit {
        updateTask?.cancel()
    }

    // MARK: - Public API

    func start() {
        guard state != .running else {
            return
        }

        startedAt = Date()
        state = .running

        notify()
        startUpdateTask()
    }

    func pause() {
        guard state == .running else {
            return
        }

        updateElapsed()

        accumulatedTime = elapsed
        startedAt = nil
        state = .paused

        stopUpdateTask()
        notify()
    }

    func reset() {
        stopUpdateTask()

        startedAt = nil
        accumulatedTime = 0
        elapsed = 0
        state = .stopped

        notify()
    }

    func toggle() {
        switch state {
        case .running:
            pause()

        case .paused, .stopped:
            start()
        }
    }

    // MARK: - Private

    private func updateElapsed() {
        guard let startedAt else {
            return
        }

        elapsed = accumulatedTime + Date().timeIntervalSince(startedAt)
    }

    private func startUpdateTask() {
        stopUpdateTask()

        updateTask = Task { [weak self] in
            while !Task.isCancelled {

                do {
                    try await Task.sleep(for: .milliseconds(250))
                } catch {
                    return
                }

                guard !Task.isCancelled else {
                    return
                }

                self?.refresh()
            }
        }
    }

    private func refresh() {
        guard state == .running else {
            return
        }

        updateElapsed()
        notify()
    }

    private func stopUpdateTask() {
        updateTask?.cancel()
        updateTask = nil
    }

    private func notify() {
        onUpdate?(elapsed, state)
    }
}
