//
//  Untitled.swift
//  ZSBPrinterSupportKit
//
//  Created by Nivetha.M on 03/02/26.
//

import AppKit

enum SupportActions {

    static func callSupport() {
        if let url = URL(string: "tel://1800123456") {
            NSWorkspace.shared.open(url)
        }
    }

    static func emailSupport() {
        let service = NSSharingService(named: .composeEmail)!
        service.recipients = ["support@zebra.com"]
        service.subject = "ZSB Printer Support"
        service.perform(withItems: ["Please describe your issue..."])
    }

    static func openChat() {
       // ChatbotView()

//        if let url = URL(string: "https://support.zebra.com/chat") {
//            NSWorkspace.shared.open(url)
//        }
    }

    static func openTicket() {

        if let url = URL(string: "https://support.zebra.com/ticket") {
            NSWorkspace.shared.open(url)
        }
    }
}
