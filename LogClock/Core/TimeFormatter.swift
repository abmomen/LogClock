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
        let totalSeconds = max(0, Int(interval))

        let hours = totalSeconds / 3600
        let remainingSeconds = totalSeconds % 3600

        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60

        var components: [String] = []

        if hours > 0 {
            components.append("\(hours)h")
        }

        let totalMinutes = Double(minutes) + Double(seconds) / 60.0

        if totalMinutes > 0 {
            let formattedMinutes = String(
                format: "%.2f",
                totalMinutes
            )
            .replacingOccurrences(of: #"\.?0+$"#, with: "", options: .regularExpression)

            components.append("\(formattedMinutes)m")
        }

        return components.isEmpty
            ? "0m"
            : components.joined(separator: " ")
    }
}
