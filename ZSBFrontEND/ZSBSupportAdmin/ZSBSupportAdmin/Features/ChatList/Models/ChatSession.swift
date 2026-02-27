



import Foundation
struct ChatSession: Identifiable {

    let id = UUID()
    let customerEmail: String
    var messages: [Message]

    var displayName: String {
        customerEmail.components(separatedBy: "@").first ?? customerEmail
    }
}
