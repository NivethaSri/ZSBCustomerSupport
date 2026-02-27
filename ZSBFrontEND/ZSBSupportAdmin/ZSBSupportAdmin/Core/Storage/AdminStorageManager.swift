//
//  AdminStorageManager.swift
//  ZSBSupportAdmin
//
//  Created by Nivetha.M on 20/02/26.
//

import Foundation

final class AdminStorageManager {

    private static let isLoggedInKey = "adminLoggedIn"
    private static let tokenKey = "adminToken"

    static var isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: isLoggedInKey) }
        set { UserDefaults.standard.set(newValue, forKey: isLoggedInKey) }
    }

    static var token: String? {
        get { UserDefaults.standard.string(forKey: tokenKey) }
        set { UserDefaults.standard.set(newValue, forKey: tokenKey) }
    }
}
