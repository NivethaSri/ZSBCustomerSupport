import Foundation

struct IncomingMessage: Codable {
    let from: String
    let message: String
}

final class WebSocketService {

    private var webSocketTask: URLSessionWebSocketTask?
    private let email: String

    var onMessageReceived: ((IncomingMessage) -> Void)?

    init(email: String) {
        self.email = email
    }

    func connect() {
        let url = URL(string: "ws://127.0.0.1:8000/chat/ws/\(email)")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        receive()
    }

    func send(message: String, to: String) {
        let payload = [
            "to": to,
            "message": message
        ]

        let data = try! JSONSerialization.data(withJSONObject: payload)
        let string = String(data: data, encoding: .utf8)!

        webSocketTask?.send(.string(string)) { error in
            if let error = error {
                print("Send error:", error)
            }
        }
    }

    private func receive() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(.string(let text)):
                if let data = text.data(using: .utf8),
                   let decoded = try? JSONDecoder().decode(IncomingMessage.self, from: data) {
                    self?.onMessageReceived?(decoded)
                }
                self?.receive()

            case .failure(let error):
                print("Receive error:", error)

            default:
                break
            }
        }
    }
}
