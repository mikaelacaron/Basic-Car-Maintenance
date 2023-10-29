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
    var actionText: String
    var actionURL: String
    var emojiIcon: String
    var isOn: Bool
    var message: String
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case actionText
        case actionURL
        case emojiIcon
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
