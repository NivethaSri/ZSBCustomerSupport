//
//  RegistrationViewModel.swift
//  ZSBPrinterSupportKit
//
//  Created by Nivetha.M on 19/02/26.
//

import Foundation
import Combine

final class RegistrationViewModel: ObservableObject {

    @Published var email: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let authService = AuthService()

    func registerIfNeeded() async {

      //  guard !AppStorageManager.isUserRegistered else { return }

        isLoading = true

        do {
            let _ = try await authService.register(email: email)
            AppStorageManager.userEmail = email
            AppStorageManager.isUserRegistered = true
        } catch {
            errorMessage = "Registration failed"
        }

        isLoading = false
    }
}
