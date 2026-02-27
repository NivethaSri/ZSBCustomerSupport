//
//  LoginResponse.swift
//  ZSBSupportAdmin
//
//  Created by Nivetha.M on 20/02/26.
//

import Foundation

struct LoginResponse: Codable {
    let access_token: String
    let token_type: String
}
