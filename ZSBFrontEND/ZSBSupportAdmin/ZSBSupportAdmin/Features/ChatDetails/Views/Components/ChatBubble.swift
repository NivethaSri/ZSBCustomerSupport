//
//  ChatBubble.swift
//  ZSBSupportAdmin
//
//  Created by Nivetha.M on 20/02/26.
//

import SwiftUI
import Combine
struct ChatBubble: View {

    let message: Message

    var body: some View {

        HStack {

            if message.isAdmin {
                Spacer()

                Text(message.text)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .frame(maxWidth: 300, alignment: .trailing)

            } else {

                Text(message.text)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(16)
                    .frame(maxWidth: 300, alignment: .leading)

                Spacer()
            }
        }
    }
}
