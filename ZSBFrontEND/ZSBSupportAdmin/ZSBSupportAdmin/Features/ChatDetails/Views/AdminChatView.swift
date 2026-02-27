import SwiftUI

struct AdminChatView: View {

    let chat: ChatSession
    let onSend: (String) -> Void

    @State private var messageText: String = ""

    var body: some View {

        VStack {

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {

                    ForEach(chat.messages) { message in

                        HStack {
                            if message.isAdmin {
                                Spacer()
                            }

                            Text(message.text)
                                .padding()
                                .background(
                                    message.isAdmin
                                    ? Color.blue
                                    : Color.gray.opacity(0.3)
                                )
                                .foregroundColor(
                                    message.isAdmin
                                    ? .white
                                    : .black
                                )
                                .cornerRadius(10)

                            if !message.isAdmin {
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
            }

            Divider()

            HStack {
                TextField("Type message...", text: $messageText)

                Button("Send") {
                    guard !messageText.isEmpty else { return }
                    onSend(messageText)
                    messageText = ""
                }
            }
            .padding()
        }
        .navigationTitle(chat.displayName)
    }
}
