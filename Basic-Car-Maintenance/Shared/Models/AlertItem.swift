//
//  AlertItem.swift
//  Basic-Car-Maintenance
//
//  Created by Omar Hegazy on 13/10/2023.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftData

struct AlertItem: Codable, Identifiable {
    @DocumentID var id: String?
    var actionTxt: String
    var actionURL: String
    var icon: String
    var isOn: Bool
    var message: String
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case actionTxt = "actionTex"
        case actionURL
        case icon = "emojiIcon"
        case isOn
        case message
        case title
    }
}

extension AlertItem: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

@Model
final class AcknowledgedAlert {
    var id: String
    
    init(id: String) {
        self.id = id
    }
}
