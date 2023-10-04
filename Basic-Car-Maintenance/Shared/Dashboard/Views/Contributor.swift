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
    let followersURL: String
    let followingURL: String
    let gistsURL: String
    let starredURL: String
    let subscriptionsURL: String
    let organizationsURL: String
    let reposURL: String
    let eventsURL: String
    let receivedEventsURL: String
    let type: String
    let siteAdmin: Bool
    let contributions: Int

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "nodeId"
        case avatarURL = "avatarUrl"
        case gravatarID = "gravatarId"
        case url
        case htmlURL = "htmlUrl"
        case followersURL = "followersUrl"
        case followingURL = "followingUrl"
        case gistsURL = "gistsUrl"
        case starredURL = "starredUrl"
        case subscriptionsURL = "subscriptionsUrl"
        case organizationsURL = "organizationsUrl"
        case reposURL = "reposUrl"
        case eventsURL = "eventsUrl"
        case receivedEventsURL = "receivedEventsUrl"
        case type
        case siteAdmin = "siteAdmin"
        case contributions
    }
}
