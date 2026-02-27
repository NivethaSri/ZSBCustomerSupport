import Foundation
import Combine

@MainActor
final class AdminLoginViewModel: ObservableObject {

    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoading = false

    private let authService = AdminAuthService()

    func login() async {

        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email and password"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await authService.login(
                email: email,
                password: password
            )

            AdminStorageManager.token = response.access_token
            AdminStorageManager.isLoggedIn = true

        } catch {
            errorMessage = "Invalid credentials or server error"
        }

        isLoading = false
    }
}
