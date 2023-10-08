//
//  Contributor.swift
//  Basic-Car-Maintenance
//
//  Created by Yashraj jadhav on 01/10/23.
//

import Foundation

/// A model representing a contributor.
///  
/// Contributors are people who have supported this project in any manner.
///  
/// - Note: In this project, we don't actually create this ``Contributor`` 
/// anywhere, we are getting all the contributors from [GitHub's Repository Statistics
/// API](https://api.github.com/repos/mikaelacaron/Basic-Car-Maintenance/contributors)
///
/// On status code of 200, we decode the response into ``SettingsViewModel/contributors``
/// array of ``Contributor`` type and display them in ``ContributorsListView``.
struct Contributor: Codable, Hashable, Identifiable {
    
    /// The handle for the GitHub user account
    let login: String
    
    /// The unique identifier for an account
    let id: Int
    
    /// The ID used to move between the REST API & the GraphQL API
    let nodeID: String
    
    /// The link to profile image of the user
    let avatarURL: String
    
    /// The link to user's avatar on Gravatar if they haven't uploaded an avatar directly.
    /// - Warning: Deprecated by GitHub in 2014
    let gravatarID: String
    
    /// The endpoint for a user's profile data
    let url: String
    
    /// The url for overview of an account
    let htmlURL: String
    
    /// The number of Pull Requests successfully merged
    let contributions: Int
    
    /// Keys to be used for encoding and decoding.
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
