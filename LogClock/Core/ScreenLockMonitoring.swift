//
//  ScreenLockMonitor.swift
//  TinyTimer
//

import Foundation

@MainActor
protocol ScreenLockMonitoring: AnyObject {
    var onLock: (() -> Void)? { get set }
    var onUnlock: (() -> Void)? { get set }

    func start()
    func stop()
}

@MainActor
final class ScreenLockMonitor: ScreenLockMonitoring {

    var onLock: (() -> Void)?
    var onUnlock: (() -> Void)?

    private var lockObserver: NSObjectProtocol?
    private var unlockObserver: NSObjectProtocol?

    private let notificationCenter =
        DistributedNotificationCenter.default

    // MARK: - Public API

    func start() {
        guard lockObserver == nil,
              unlockObserver == nil else {
            return
        }

        lockObserver = notificationCenter.addObserver(
            forName: Notification.Name("com.apple.screenIsLocked"),
            object: nil,
            queue: OperationQueue.main
        ) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.onLock?()
            }
        }

        unlockObserver = notificationCenter.addObserver(
            forName: Notification.Name("com.apple.screenIsUnlocked"),
            object: nil,
            queue: OperationQueue.main
        ) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.onUnlock?()
            }
        }
    }

    func stop() {
        if let observer = lockObserver {
            notificationCenter.removeObserver(observer)
            lockObserver = nil
        }

        if let observer = unlockObserver {
            notificationCenter.removeObserver(observer)
            unlockObserver = nil
        }
    }

    deinit {
        if let observer = lockObserver {
            notificationCenter.removeObserver(observer)
        }

        if let observer = unlockObserver {
            notificationCenter.removeObserver(observer)
        }
    }
}
