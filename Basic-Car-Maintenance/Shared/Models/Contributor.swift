//
//  Contributor.swift
//  Basic-Car-Maintenance
//
//  Created by Yashraj jadhav on 01/10/23.
//

import Foundation

struct Contributor: Codable, Hashable , Identifiable {
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: String
    let gravatarID: String
    let url: String
    let htmlURL: String
    let contributions: Int

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "nodeId"
        case avatarURL = "avatarUrl"
        case gravatarID = "gravatarId"
        case url
        case htmlURL = "htmlUrl"
        case contributions
    }
}
