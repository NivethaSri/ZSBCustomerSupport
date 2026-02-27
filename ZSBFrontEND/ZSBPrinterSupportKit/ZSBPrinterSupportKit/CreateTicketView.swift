//
//  Untitled.swift
//  ZSBPrinterSupportKit
//
//  Created by Nivetha.M on 03/02/26.
//

import SwiftUI
internal import UniformTypeIdentifiers

struct CreateTicketView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var screenshotURLs: [URL] = []
    @State private var showScreenshotPicker = false
    
    @State private var summary = ""
    @State private var description = ""
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Create Support Ticket")
                .font(.title2)
                .bold()
            
            Form {
                TextField("Issue Summary", text: $summary)
                
                TextEditor(text: $description)
                    .frame(height: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.3))
                    )
            }
            
            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            HStack {
                Spacer()
                
                Button("Cancel") {
                    dismiss()
                }
                
                Button {
                    submitTicket()
                } label: {
                    if isSubmitting {
                        ProgressView()
                    } else {
                        Text("Submit")
                    }
                }
                Button("Attach Screenshot") {
                    pickScreenshots()
                }
                //                Button("Capture Screenshot") {
                //                       // captureScreenshot()
                //                    }
                .buttonStyle(.borderedProminent)
                .disabled(summary.isEmpty || description.isEmpty || isSubmitting)
                
                if !screenshotURLs.isEmpty {
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(spacing: 12) {
                            ForEach(screenshotURLs, id: \.self) { url in
                                VStack {
                                    Image(nsImage: NSImage(contentsOf: url) ?? NSImage())
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 120, height: 80)
                                        .cornerRadius(6)
                                    
                                    Button("Remove") {
                                        screenshotURLs.removeAll { $0 == url }
                                    }
                                    .font(.caption)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(24)
        .frame(width: 500)
    }
    
    func pickScreenshots() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.png, .jpeg]
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.title = "Select Screenshots"
        
        panel.begin { response in
            if response == .OK {
                self.screenshotURLs.append(contentsOf: panel.urls)
            }
        }
    }
    
    
    //    func captureScreenshot() {
    //        let tempURL = FileManager.default
    //            .temporaryDirectory
    //            .appendingPathComponent("support_screenshot.png")
    //
    //        let task = Process()
    //        task.launchPath = "/usr/sbin/screencapture"
    //        task.arguments = ["-i", tempURL.path]
    //        task.launch()
    //        task.waitUntilExit()
    //
    //        if FileManager.default.fileExists(atPath: tempURL.path) {
    //            self.screenshotURLs = tempURL
    //        }
    //    }
    
    
    private func submitTicket() {
        isSubmitting = true
        errorMessage = nil
        AISeverityClassifier.shared.classifySeverity(
            summary: summary,
            description: description
        ) { severity in
            
            print("Detected severity:", severity.rawValue)
            
            JiraTicketService.shared.createTicket(
                title: summary,
                description: description,
                screenshotURLs: screenshotURLs
            )
            { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let key):
                        print("✅ Ticket created:", key)
                    case .failure(let error):
                        print("❌ Error:", error.localizedDescription)
                    }
                }
            }
            
        }
    }
}
