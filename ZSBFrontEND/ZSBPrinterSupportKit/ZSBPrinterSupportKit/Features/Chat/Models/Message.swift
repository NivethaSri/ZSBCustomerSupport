//
//  ChatMessage.swift
//  ZSBPrinterSupportKit
//
//  Created by Nivetha.M on 19/02/26.
//

import Foundation

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}
