//
//  Endpoints.swift
//  ZSBPrinterSupportKit
//
//  Created by Nivetha.M on 19/02/26.
//

import Foundation

enum Endpoints {

    static func register(request: RegisterRequest) -> URLRequest {
        let url = URL(string: "\(AppConstants.baseURL)/auth/register")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        urlRequest.httpBody = try? JSONEncoder().encode(request)
        return urlRequest
    }
}
