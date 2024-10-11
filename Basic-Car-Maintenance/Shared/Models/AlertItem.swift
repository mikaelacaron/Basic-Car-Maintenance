//
//  AlertItem.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
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
