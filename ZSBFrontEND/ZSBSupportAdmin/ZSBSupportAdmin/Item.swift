//
//  Item.swift
//  ZSBSupportAdmin
//
//  Created by Nivetha.M on 10/02/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
