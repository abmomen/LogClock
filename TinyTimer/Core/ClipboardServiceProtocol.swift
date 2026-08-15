//
//  ClipboardService.swift
//  TinyTimer
//

import AppKit

protocol ClipboardServiceProtocol {
    func copy(_ text: String)
}

final class ClipboardService: ClipboardServiceProtocol {

    func copy(_ text: String) {
        let pasteboard = NSPasteboard.general

        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
}
