//
//  RegisterRequest.swift
//  ZSBPrinterSupportKit
//
//  Created by Nivetha.M on 19/02/26.
//

import Foundation

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let role: String
}
