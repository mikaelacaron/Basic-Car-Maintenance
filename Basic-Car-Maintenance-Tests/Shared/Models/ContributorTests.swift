//
//  ContributorTests.swift
//  Basic-Car-Maintenance-Tests
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Foundation
import Testing
@testable import Basic_Car_Maintenance

struct ContributorTests {
    private let jsonDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    private let jsonEncoder = {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        return jsonEncoder
    }()
    
    @Test()
    func contributorDecoding() throws {
        let testContributorJson = """
    {
        "login": "Drag0ndust",
        "id": 12915108,
        "node_id": "MDQ6VXNlcjEyOTE1MTA4",
        "avatar_url": "https://avatars.githubusercontent.com/u/12915108?v=4",
        "url": "https://api.github.com/users/Drag0ndust",
        "html_url": "https://github.com/Drag0ndust",
        "contributions": 0
    }
"""
        let data = try #require(testContributorJson.data(using: .utf8))
        let sut = try jsonDecoder.decode(Contributor.self, from: data)
        
        #expect(sut.login == "Drag0ndust")
        #expect(sut.id == 12915108)
        #expect(sut.nodeID == "MDQ6VXNlcjEyOTE1MTA4")
        #expect(sut.avatarURL == "https://avatars.githubusercontent.com/u/12915108?v=4")
        #expect(sut.url == "https://api.github.com/users/Drag0ndust")
        #expect(sut.htmlURL == "https://github.com/Drag0ndust")
        #expect(sut.contributions == 0)
    }
    
    @Test()
    func contributorEncoding() throws {
        let contributor = Contributor(
            login: "Drag0ndust",
            id: 12915108,
            nodeID: "MDQ6VXNlcjEyOTE1MTA4",
            avatarURL: "https://avatars.githubusercontent.com/u/12915108?v=4",
            url: "https://api.github.com/users/Drag0ndust",
            htmlURL: "https://github.com/Drag0ndust",
            contributions: 0
        )
        
        let contributorData = try jsonEncoder.encode(contributor)
        
        // now decode it again and check if the objects are equal
        let decodedContributor = try jsonDecoder.decode(Contributor.self, from: contributorData)
        
        #expect(contributor == decodedContributor)
    }
}
