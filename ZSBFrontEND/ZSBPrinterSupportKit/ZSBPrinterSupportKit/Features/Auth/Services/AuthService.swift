//
//  AuthService.swift
//  ZSBPrinterSupportKit
//
//  Created by Nivetha.M on 19/02/26.
//

import Foundation

final class AuthService {

    func register(email: String) async throws -> UserResponse {

        let request = RegisterRequest(
            email: email,
            password: "test123",
            role: AppConstants.customerRole
        )

        let endpoint = Endpoints.register(request: request)

        return try await APIClient.shared.request(
            endpoint: endpoint,
            responseType: UserResponse.self
        )
    }
}
