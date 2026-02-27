import Foundation

final class WebSocketService {

    struct IncomingMessage: Codable {
        let from: String
        let message: String
    }

    var onMessageReceived: ((IncomingMessage) -> Void)?

    private var webSocketTask: URLSessionWebSocketTask?
    private let email: String

    init(email: String) {
        self.email = email
    }

    func connect() {
        let url = URL(string: "ws://127.0.0.1:8000/chat/ws/\(email)")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        receive()
    }

    func send(message: String, to receiver: String) {
        let json: [String: String] = [
            "to": receiver,
            "message": message
        ]

        let data = try! JSONSerialization.data(withJSONObject: json)
        let text = String(data: data, encoding: .utf8)!

        webSocketTask?.send(.string(text)) { error in
            if let error = error {
                print("Send error:", error)
            }
        }
    }

    private func receive() {

        webSocketTask?.receive { [weak self] result in

            switch result {

            case .success(let message):

                switch message {

                case .string(let text):

                    if let data = text.data(using: .utf8),
                       let decoded = try? JSONDecoder().decode(IncomingMessage.self, from: data) {

                        DispatchQueue.main.async {
                            self?.onMessageReceived?(decoded)
                        }
                    }

                default:
                    break
                }

                self?.receive()

            case .failure(let error):
                print("Receive error:", error)
            }
        }
    }}
