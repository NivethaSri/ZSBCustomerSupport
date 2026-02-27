//
//  AIService.swift
//  ZSBPrinterSupportKit
//
//  Created by Nivetha.M on 26/02/26.
//

import Foundation

struct AIResponse: Decodable {
    let answer: String
    let escalate: Bool
}

final class AIService {

    static let shared = AIService()

    func ask(question: String, completion: @escaping (AIResponse) -> Void) {

        guard let url = URL(string: "http://127.0.0.1:8000/ai/chat") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["message": question]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }

            if let decoded = try? JSONDecoder().decode(AIResponse.self, from: data) {
                completion(decoded)
            }
        }.resume()
    }
}
