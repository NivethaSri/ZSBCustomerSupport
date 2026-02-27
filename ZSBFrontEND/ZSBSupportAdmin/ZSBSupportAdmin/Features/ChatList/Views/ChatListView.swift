import SwiftUI
import Combine

struct ChatListView: View {

    @StateObject private var viewModel = ChatListViewModel(adminEmail: "test1@gmail.com")
    @State private var selectedChatID: UUID?
    
    var body: some View {
        NavigationSplitView {
            List(viewModel.chats, selection: $selectedChatID) { chat in
                HStack {
                    Circle()
                        .fill(Color.green.opacity(0.3))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text(String(chat.displayName.prefix(1)))
                        )
                    VStack(alignment: .leading) {
                        Text(chat.displayName)
                            .font(.headline)

                        Text(chat.messages.last?.text ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Chats")
        } detail: {

            if let id = selectedChatID,
               let chat = viewModel.chats.first(where: { $0.id == id }) {

                AdminChatView(chat: chat) { text in
                    viewModel.sendMessage(text, to: chat.customerEmail)
                }
            } else {
                Text("Select a chat")
            }
        }
    }
}
