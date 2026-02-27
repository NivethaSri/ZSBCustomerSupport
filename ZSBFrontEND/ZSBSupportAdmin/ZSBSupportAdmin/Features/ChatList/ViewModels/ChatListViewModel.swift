import Foundation
import SwiftUI
import Combine

@MainActor
final class ChatListViewModel: ObservableObject {

    @Published var chats: [ChatSession] = []

    private let webSocketService: WebSocketService
    private let adminEmail: String

    init(adminEmail: String) {
        self.adminEmail = adminEmail
        self.webSocketService = WebSocketService(email: adminEmail)
        connect()
    }

    private func connect() {
        webSocketService.onMessageReceived = { [weak self] message in
            DispatchQueue.main.async {
                self?.handleIncoming(message)
            }
        }

        webSocketService.connect()
    }

    private func handleIncoming(_ message: IncomingMessage) {

        if let index = chats.firstIndex(where: { $0.customerEmail == message.from }) {

            chats[index].messages.append(
                Message(text: message.message, isAdmin: false)
            )

        } else {

            let newChat = ChatSession(
                customerEmail: message.from,
                messages: [
                    Message(text: message.message, isAdmin: false)
                ]
            )

            chats.append(newChat)
        }
    }

    func sendMessage(_ text: String, to customer: String) {

        if let index = chats.firstIndex(where: { $0.customerEmail == customer }) {
            chats[index].messages.append(
                Message(text: text, isAdmin: true)
            )
        }

        webSocketService.send(message: text, to: customer)
    }
}
