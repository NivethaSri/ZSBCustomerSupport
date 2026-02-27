//
//  Untitled.swift
//  ZSBPrinterSupportKit
//
//  Created by Nivetha.M on 03/02/26.
//

//
//  JiraTicketService.swift
//  ZSBPrinterSupportKit
//
//  Created by Nivetha.M on 03/02/26.
//

import Foundation
import Cocoa

// MARK: - Severity



// MARK: - Error

enum JiraError: LocalizedError {
    case ticketCreationFailed

    var errorDescription: String? {
        "Failed to create Jira ticket"
    }
}

// MARK: - Jira Service

final class JiraTicketService {

    static let shared = JiraTicketService()
    private init() {}

    // MARK: - Public API (SwiftUI entry point)


    func createTicket(
        title: String,
        description: String,
        screenshotURLs: [URL],
        completion: @escaping (Result<String, Error>) -> Void
    ) {

        // 1️⃣ AI Severity Classification (NO backend)
        AISeverityClassifier.shared.classifySeverity(
            summary: title,
            description: description
        ) { severity in

            print("🧠 AI Severity:", severity.rawValue)

            // 2️⃣ Create Jira Issue with Severity
            createJiraIssue(
                title: title,
                aiDescription: description,
                severity: severity
            ) { issueKey in

                guard let issueKey else {
                    DispatchQueue.main.async {
                        completion(.failure(JiraError.ticketCreationFailed))
                    }
                    return
                }

                // 3️⃣ Attach logs + screenshots
                self.attachDefaultArtifacts(
                    issueKey: issueKey,
                    screenshotURLs: screenshotURLs
                ) {
                    completion(.success(issueKey))
                }
            }
        }
    }
}

// MARK: - Attachments

extension JiraTicketService {

    func attachDefaultArtifacts(
        issueKey: String,
        screenshotURLs: [URL],
        completion: @escaping () -> Void
    ) {

        let group = DispatchGroup()

        // 1️⃣ Attach log (if exists)
        let logURL = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ZSBTools/sohodriver.log")

        if FileManager.default.fileExists(atPath: logURL.path) {
            group.enter()
            attachFile(
                issueKey: issueKey,
                fileURL: logURL,
                mimeType: "text/plain"
            ) {
                group.leave()
            }
        }

        // 2️⃣ Attach ALL screenshots
        for screenshotURL in screenshotURLs {
            group.enter()
            attachFile(
                issueKey: issueKey,
                fileURL: screenshotURL,
                mimeType: "image/png"
            ) {
                group.leave()
            }
        }

        // 3️⃣ Done
        group.notify(queue: .main) {
            completion()
        }
    }
}
