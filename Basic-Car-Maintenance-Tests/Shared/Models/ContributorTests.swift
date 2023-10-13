//
//  ContributorTests.swift
//  Basic-Car-Maintenance-Tests
//
//  Created by Drag0ndust on 07.10.23.
//

import XCTest
@testable import Basic_Car_Maintenance

final class ContributorTests: XCTestCase {
    private var jsonDecoder: JSONDecoder!
    private var jsonEncoder: JSONEncoder!
    private let testContributorJson = """
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

    override func setUpWithError() throws {
        jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
    }

    func testContributorDecoding() throws {
        guard let data = testContributorJson.data(using: .utf8) else {
            XCTFail("Can't decode JSON string")
            return
        }

        let sut = try jsonDecoder.decode(Contributor.self, from: data)

        XCTAssertEqual(sut.login, "Drag0ndust")
        XCTAssertEqual(sut.id, 12915108)
        XCTAssertEqual(sut.nodeID, "MDQ6VXNlcjEyOTE1MTA4")
        XCTAssertEqual(sut.avatarURL, "https://avatars.githubusercontent.com/u/12915108?v=4")
        XCTAssertEqual(sut.url, "https://api.github.com/users/Drag0ndust")
        XCTAssertEqual(sut.htmlURL, "https://github.com/Drag0ndust")
        XCTAssertEqual(sut.contributions, 0)
    }
    
    func testContributorEncoding() throws {
        let contributor = Contributor(login: "Drag0ndust",
                                      id: 12915108,
                                      nodeID: "MDQ6VXNlcjEyOTE1MTA4",
                                      avatarURL: "https://avatars.githubusercontent.com/u/12915108?v=4",
                                      url: "https://api.github.com/users/Drag0ndust",
                                      htmlURL: "https://github.com/Drag0ndust",
                                      contributions: 0)
        
        let contributorData = try jsonEncoder.encode(contributor)
        
       // now decode it again and check if the objects are equal
        let decodedContributor = try jsonDecoder.decode(Contributor.self, from: contributorData)
        
        XCTAssertEqual(contributor, decodedContributor)
    }
}
