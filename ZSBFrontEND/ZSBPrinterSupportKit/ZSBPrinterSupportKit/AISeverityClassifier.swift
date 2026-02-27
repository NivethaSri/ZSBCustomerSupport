//
//  Untitled.swift
//  ZSBPrinterSupportKit
//
//  Created by Nivetha.M on 04/02/26.
//
import Foundation
import Security

// MARK: - Severity Enum

enum IssueSeverity: String {
    case high = "HIGH"
    case medium = "MEDIUM"
    case low = "LOW"
}

// MARK: - Public API

final class AISeverityClassifier {

    static let shared = AISeverityClassifier()
    private init() {}

    func classifySeverity(
        summary: String,
        description: String,
        completion: @escaping (IssueSeverity) -> Void
    ) {

        guard let apiKey = OpenAIKeychain.apiKey(), !apiKey.isEmpty else {
            completion(.medium) // safe fallback
            return
        }

        let url = URL(string: "https://api.openai.com/v1/chat/completions")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let prompt = """
You are a support issue severity classifier.

Rules:
- HIGH: App crash, install/login blocked, data loss
- MEDIUM: Feature partially broken, workaround exists
- LOW: Minor issue, UI issue, suggestion

Respond with ONLY ONE WORD:
HIGH or MEDIUM or LOW

Issue Summary:
\(summary)

Issue Description:
\(description)
"""

        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "temperature": 0
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, _ in

            guard
                let data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let choices = json["choices"] as? [[String: Any]],
                let message = choices.first?["message"] as? [String: Any],
                let content = message["content"] as? String
            else {
                DispatchQueue.main.async { completion(.medium) }
                return
            }

            let result = content
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .uppercased()

            DispatchQueue.main.async {
                completion(IssueSeverity(rawValue: result) ?? .medium)
            }

        }.resume()
    }
}

// MARK: - Keychain Helper (OpenAI API Key)

 enum OpenAIKeychain {

    private static let service = "com.zebra.ZSBPrinterSupportKit"
        private static let account = "openai.api.key"

    static func apiKey() -> String? {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard
            status == errSecSuccess,
            let data = item as? Data,
            let key = String(data: data, encoding: .utf8)
        else {
            return nil
        }

        return key
    }

    // Call ONCE during setup / dev
    static func saveApiKey(_ key: String) {
        let data = key.data(using: .utf8)!

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        SecItemDelete(query as CFDictionary)

        let attributes: [String: Any] = query.merging([
            kSecValueData as String: data
        ]) { $1 }

        SecItemAdd(attributes as CFDictionary, nil)
    }
}
