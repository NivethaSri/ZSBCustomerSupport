//
//  Untitled.swift
//  sohodriver
//
//  Created by Nivetha.M on 28/01/26.
//  Copyright © 2026 Zebra. All rights reserved.
//


import Foundation
import Cocoa


func jiraAuthHeader(email: String, token: String) -> String {
    let authString = "\(email):\(token)"
    let data = authString.data(using: .utf8)!
    return "Basic \(data.base64EncodedString())"
}
func jiraPriority(for severity: IssueSeverity) -> String {
    switch severity {
    case .high: return "Highest"
    case .medium: return "Medium"
    case .low: return "Low"
    }
}
func createJiraIssue(
    title: String,
    aiDescription: String,
    severity: IssueSeverity,
    completion: @escaping (String?) -> Void
) {

    let url = URL(string: "https://niviinfotechs.atlassian.net/rest/api/3/issue")!

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(
        jiraAuthHeader(email: "niviinfotechs@gmail.com", token: ""),
        forHTTPHeaderField: "Authorization"
    )

    let body: [String: Any] = [
        "fields": [
            "project": ["key": "SCRUM"],
            "summary": title,
            "issuetype": ["name": "Bug"],
            "priority": [
                "name": jiraPriority(for: severity)
            ],
            "description": [
                "type": "doc",
                "version": 1,
                "content": [[
                    "type": "paragraph",
                    "content": [[
                        "type": "text",
                        "text": aiDescription
                    ]]
                ]]
            ]
        ]
    ]


    request.httpBody = try? JSONSerialization.data(withJSONObject: body)

    URLSession.shared.dataTask(with: request) { data, _, _ in
        if let data,
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let key = json["key"] as? String {
            completion(key)
        } else {
            completion(nil)
        }
    }.resume()
}

func callLogAttach(titleString : String, aiText : String , severity : IssueSeverity) {
    createJiraIssue(title: titleString, aiDescription: aiText, severity: severity) { issueKey in
         guard let issueKey else {
             print("❌ Failed to create Jira issue")
             return
         }

         print("✅ Jira issue created:", issueKey)
        
          let logURL = FileManager.default
              .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
              .appendingPathComponent("ZSBTools/sohodriver.log")
          

         if FileManager.default.fileExists(atPath: logURL.path) {
              attachLog(issueKey: issueKey, logURL: logURL) { success, message in
                  if success {
                      print("📎 Log attached successfully")
                  } else {
                      print("❌ Failed to attach log: \(message ?? "Unknown error")")
                  }
              }
         } else {
             print("⚠️ Log file missing, skipping attachment")
         }
     }

}


func attachFile(
    issueKey: String,
    fileURL: URL,
    mimeType: String,
    completion: @escaping () -> Void
) {

    let url = URL(
        string: "https://niviinfotechs.atlassian.net/rest/api/3/issue/\(issueKey)/attachments"
    )!

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(
        jiraAuthHeader(
            email: "niviinfotechs@gmail.com",
            token: ""
        ),
        forHTTPHeaderField: "Authorization"
    )
    request.setValue("no-check", forHTTPHeaderField: "X-Atlassian-Token")

    let boundary = UUID().uuidString
    request.setValue("multipart/form-data; boundary=\(boundary)",
                     forHTTPHeaderField: "Content-Type")

    guard let fileData = try? Data(contentsOf: fileURL) else {
        completion()
        return
    }

    var body = Data()
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append(
        "Content-Disposition: form-data; name=\"file\"; filename=\"\(fileURL.lastPathComponent)\"\r\n"
            .data(using: .utf8)!
    )
    body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
    body.append(fileData)
    body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

    request.httpBody = body

    URLSession.shared.dataTask(with: request) { _, _, _ in
        DispatchQueue.main.async {
            completion() // 🔑 always return to main thread
        }
    }.resume()
}


func attachLog(
    issueKey: String,
    logURL: URL,
    completion: @escaping (Bool, String?) -> Void
) {

     let url = URL(string:
       "https://niviinfotechs.atlassian.net/rest/api/3/issue/\(issueKey)/attachments")!


    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(
     jiraAuthHeader(email: "niviinfotechs@gmail.com", token: ""),
        forHTTPHeaderField: "Authorization"
    )
    request.setValue("no-check", forHTTPHeaderField: "X-Atlassian-Token")

    let boundary = UUID().uuidString
    request.setValue(
        "multipart/form-data; boundary=\(boundary)",
        forHTTPHeaderField: "Content-Type"
    )

    guard let fileData = try? Data(contentsOf: logURL) else {
        completion(false, "Unable to read log file")
        return
    }

    var body = Data()
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append(
        "Content-Disposition: form-data; name=\"file\"; filename=\"\(logURL.lastPathComponent)\"\r\n"
        .data(using: .utf8)!
    )
    body.append("Content-Type: text/plain\r\n\r\n".data(using: .utf8)!)
    body.append(fileData)
    body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

    request.httpBody = body

    URLSession.shared.dataTask(with: request) { data, response, error in
        DispatchQueue.main.async {   // 🔑 THIS WAS MISSING
            
            if let error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, "Invalid response")
                return
            }
            
            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                completion(true, nil)
            } else {
                let msg = String(data: data ?? Data(), encoding: .utf8)
                completion(false, "HTTP \(httpResponse.statusCode): \(msg ?? "")")
            }
        }

    }.resume()
}

