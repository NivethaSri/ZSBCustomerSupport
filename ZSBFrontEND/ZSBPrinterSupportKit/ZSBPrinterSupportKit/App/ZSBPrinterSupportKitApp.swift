//
//  ZSBPrinterSupportKitApp.swift
//  ZSBPrinterSupportKit
//
//  Created by Nivetha.M on 03/02/26.
//

import SwiftUI

@main
struct ZSBPrinterSupportKitApp: App {
    var body: some Scene {
        WindowGroup {
            if AppStorageManager.isUserRegistered,
               AppStorageManager.userEmail != nil {
                ChatView()
            } else {
                RegistrationView()
            }
        }
    }
}
