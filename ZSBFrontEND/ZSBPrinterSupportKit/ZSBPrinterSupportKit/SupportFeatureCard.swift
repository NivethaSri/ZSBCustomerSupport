//
//  Untitled.swift
//  ZSBPrinterSupportKit
//
//  Created by Nivetha.M on 03/02/26.
//

import SwiftUI

struct SupportFeatureCard: View {

    let icon: String
    let title: String
    let description: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 14) {

                Image(systemName: icon)
                    .font(.system(size: 26))
                    .foregroundColor(.blue)

                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Spacer()
            }
            .padding(20)
            .frame(height: 160)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(NSColor.controlBackgroundColor))
                    .shadow(color: .black.opacity(0.06), radius: 6)
            )
        }
        .buttonStyle(.plain)
    }
}
