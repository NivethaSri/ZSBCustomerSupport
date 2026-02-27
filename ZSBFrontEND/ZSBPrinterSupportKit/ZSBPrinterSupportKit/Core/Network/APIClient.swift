//
//  APIClient.swift
//  ZSBPrinterSupportKit
//
//  Created by Nivetha.M on 19/02/26.
//

import Foundation

final class APIClient {

    static let shared = APIClient()
    private init() {}

    func request<T: Decodable>(
        endpoint: URLRequest,
        responseType: T.Type
    ) async throws -> T {

        // 🔷 PRINT REQUEST
        print("----- 🌍 API REQUEST -----")
        print("URL:", endpoint.url?.absoluteString ?? "")
        print("Method:", endpoint.httpMethod ?? "")

        if let headers = endpoint.allHTTPHeaderFields {
            print("Headers:", headers)
        }

        if let body = endpoint.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("Body:", bodyString)
        }

        print("--------------------------")

        let (data, response) = try await URLSession.shared.data(for: endpoint)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        // 🔷 PRINT RESPONSE
        print("----- 📩 API RESPONSE -----")
        print("Status Code:", httpResponse.statusCode)

        if let responseString = String(data: data, encoding: .utf8) {
            print("Response Body:", responseString)
        }

        print("----------------------------")

        guard 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
