//
//  ChatView.swift
//  ZSBPrinterSupportKit
//
//  Created by Nivetha.M on 19/02/26.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = CustomerChatViewModel(customerEmail: AppStorageManager.userEmail!)
    @State private var messageText: String = ""

    var body: some View {
        VStack(spacing: 0) {
            // 🔷 Header
            HStack {
                Spacer()
                Text("Welcome to ZSB Customer Support")
                    .font(.headline)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.15))
            Divider()
            // 🔷 Chat Area
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {

                    ForEach(viewModel.messages) { msg in
                        ChatBubbleView(message: msg)
                    }
                }
                .padding()
            }
            Divider()
            // 🔷 Input Bar
            HStack {
                TextField("Type your issue...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: sendMessage) {
                    Text("Send")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
    
    private func sendMessage() {

        guard !messageText.isEmpty else { return }
        let userText = messageText
        viewModel.messages.append(Message(text: userText, isUser: true))
        messageText = ""
        // If already connected to human → send via WebSocket
        if viewModel.isConnectedToHuman {
            viewModel.webSocketService.send(
                message: userText,
                to: viewModel.adminEmail  // or admin email
            )
            return
        }

        // Otherwise ask AI
        AIService.shared.ask(question: userText) { response in

            DispatchQueue.main.async {

                if response.escalate {

                    viewModel.messages.append(
                        Message(text: "Connecting you to Zebra Support Team...", isUser: false)
                    )

                    self.viewModel.connectToHumanSupport(
                        customerEmail: AppStorageManager.userEmail!
                    )

                } else {

                    viewModel.messages.append(
                        Message(text: response.answer, isUser: false)
                    )
                }
            }
        }
    }
}

