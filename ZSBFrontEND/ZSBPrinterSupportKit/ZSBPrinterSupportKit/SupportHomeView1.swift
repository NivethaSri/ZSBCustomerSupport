//
//  SupportHomeView.swift
//  ZSBPrinterSupportKit
//
//  Created by Nivetha.M on 03/02/26.
//

import SwiftUI

struct SupportHomeView1: View {
    @State private var showCreateTicket = false
    @State private var showChatbot = false

    let columns = [
        GridItem(.flexible(), spacing: 24),
        GridItem(.flexible(), spacing: 24)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {

            Text("")
                .font(.title2)
                .bold()

            LazyVGrid(columns: columns, spacing: 24) {

                SupportFeatureCard(
                    icon: "phone.fill",
                    title: "Call Support",
                    description: "Speak directly with a Zebra support expert"
                ) {
                    SupportActions.callSupport()
                }

                SupportFeatureCard(
                    icon: "envelope.fill",
                    title: "Email Support",
                    description: "Send us an email with details and attachments"
                ) {
                    SupportActions.emailSupport()
                }

                SupportFeatureCard(
                    icon: "message.fill",
                    title: "Chat with Us",
                    description: "Get instant help using our support chat"
                ) {
                    showChatbot = true
                     //SupportActions.openChat()
//                    let tree = DocumentTreeBuilder.buildTree()
//                    print(tree.map { $0.title })

                }
                .sheet(isPresented: $showChatbot) {
                   // ChatbotView()
                }
                SupportFeatureCard(
                    icon: "ticket.fill",
                    title: "Create Ticket",
                    description: "Log an issue and track its resolution"
                ) {
                    showCreateTicket = true
                }
                .sheet(isPresented: $showCreateTicket) {
                    CreateTicketView()
                }
            }

            Spacer()
        }
        .padding(32)
        .frame(minWidth: 720, minHeight: 420)
    }
}
