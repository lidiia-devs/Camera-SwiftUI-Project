//
//  StoredImage.swift
//  Camera SwiftUI Project
//
//  Created by Lidiia Diachkovskaia on 4/10/25.
//

import SwiftData
import Foundation

@Model
class StoredImage {
    var imageData: Data //Image represented as data
    var createdAt: Date
    
    init(imageData: Data, createdAt: Date = Date()) {
        self.imageData = imageData
        self.createdAt = createdAt
    }
    
}
