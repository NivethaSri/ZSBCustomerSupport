import Foundation
import Combine

@MainActor
final class CustomerChatViewModel: ObservableObject {

    @Published var messages: [Message] = [
        Message(text: "Hi 👋 Welcome to ZSB Customer Support.", isUser: false),
        Message(text: "How may I help?", isUser: false)
    ]
    
    @Published var inputText = ""
    @Published var isConnectedToHuman = false
    var webSocketService: WebSocketService
    let adminEmail = "test1@gmail.com"
    private let customerEmail: String
    
    
    init(customerEmail: String) {
        self.customerEmail = customerEmail
        self.webSocketService = WebSocketService(email: customerEmail)

        connect()
    }

    func connectToHumanSupport(customerEmail: String) {

        guard !isConnectedToHuman else { return }
        isConnectedToHuman = true
        webSocketService = WebSocketService(email: customerEmail)
        webSocketService.onMessageReceived = { [weak self] incoming in
            DispatchQueue.main.async {
                self?.messages.append(
                    Message(text: incoming.message, isUser: false)
                )
            }
        }
        webSocketService.connect()
    }
    
    private func connect() {
        webSocketService.onMessageReceived = { [weak self] message in
            DispatchQueue.main.async {
                self?.messages.append(
                    Message(text: message.message, isUser: false)
                )
            }
        }
        webSocketService.connect()
    }

    func sendMessage(messageText : String) {
        inputText = messageText
        guard !inputText.isEmpty else { return }
        let text = inputText
        inputText = ""
        messages.append(Message(text: text, isUser: true))
        webSocketService.send(message: text, to: adminEmail)
    }
    
    
}
