//
//  RegistrationView.swift
//  ZSBPrinterSupportKit
//
//  Created by Nivetha.M on 19/02/26.
//

import SwiftUI

struct RegistrationView: View {

    @StateObject private var viewModel = RegistrationViewModel()

    var body: some View {
        VStack(spacing: 20) {

            Text("Enter your Email to Register")
                .font(.headline)

            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)

            if viewModel.isLoading {
                ProgressView()
            }

            Button("Register") {
                Task {
                    await viewModel.registerIfNeeded()
                }
            }
            .disabled(viewModel.email.isEmpty)

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

        }
        .padding()
    }
}
