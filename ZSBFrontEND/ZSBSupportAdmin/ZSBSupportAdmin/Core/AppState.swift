//
//  AppState.swift
//  ZSBSupportAdmin
//
//  Created by Nivetha.M on 20/02/26.
//

import Foundation
import Combine
@MainActor
final class AppState: ObservableObject {

    @Published var isAdminLoggedIn: Bool = AdminStorageManager.isLoggedIn

    func setLoggedIn(token: String) {
        AdminStorageManager.token = token
        AdminStorageManager.isLoggedIn = true
        isAdminLoggedIn = true
    }

    func logout() {
        AdminStorageManager.token = nil
        AdminStorageManager.isLoggedIn = false
        isAdminLoggedIn = false
    }
}
