//
//  AdminLoginView.swift
//  ZSBSupportAdmin
//
//  Created by Nivetha.M on 20/02/26.
//

import SwiftUI

struct AdminLoginView: View {

    @StateObject private var viewModel = AdminLoginViewModel()

    var body: some View {

        VStack(spacing: 20) {

            Text("Admin Login")
                .font(.largeTitle)

            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)

            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)

            Button("Login") {
                Task { await viewModel.login() }
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}
