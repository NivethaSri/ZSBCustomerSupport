//
//  ChatListViewModel.swift
//  ZSBSupportAdmin
//
//  Created by Nivetha.M on 20/02/26.
//

import Foundation
import Combine
@MainActor
final class ChatDetailViewModel: ObservableObject {

    @Published var messages: [Message] = [
        Message(text: "Hi", isAdmin: false)
    ]

    @Published var inputText = ""

    func send() {
        guard !inputText.isEmpty else { return }

        messages.append(Message(text: inputText, isAdmin: true))
        inputText = ""
    }
}
