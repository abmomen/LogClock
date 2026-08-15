//
//  TimeFormatter.swift
//  TinyTimer
//

import Foundation

enum TimeFormatter {

    // MARK: - Timer Display

    static func clock(_ interval: TimeInterval) -> String {
        let totalSeconds = max(0, Int(interval))

        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        if hours > 0 {
            return String(
                format: "%02d:%02d:%02d",
                hours,
                minutes,
                seconds
            )
        }

        return String(
            format: "%02d:%02d",
            minutes,
            seconds
        )
    }

    // MARK: - Jira

    static func jira(_ interval: TimeInterval) -> String {
        var remaining = max(0, Int(interval))

        let hours = remaining / 3600
        remaining %= 3600

        let minutes = remaining / 60
        let seconds = remaining % 60

        var components: [String] = []

        if hours > 0 {
            components.append("\(hours)h")
        }

        if minutes > 0 {
            components.append("\(minutes)m")
        }

        if seconds > 0 {
            components.append("\(seconds)s")
        }

        return components.isEmpty
            ? "0s"
            : components.joined(separator: " ")
    }
}
