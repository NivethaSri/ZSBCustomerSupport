//
//  AdminAuthService.swift
//  ZSBSupportAdmin
//
//  Created by Nivetha.M on 20/02/26.
//

import Foundation

final class AdminAuthService {

    func login(email: String, password: String) async throws -> LoginResponse {

        guard let url = URL(string: "\(AppConstants.baseURL)/auth/login") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyString = "username=\(email)&password=\(password)"
        request.httpBody = bodyString.data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(LoginResponse.self, from: data)
    }
}
