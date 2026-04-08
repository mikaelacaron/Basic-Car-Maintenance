//
//  Helpers.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
/*
 Abstract: A test helper class that resets the firestore database before and after each test run. But deletes all previously
 stored data in the firestore.
 */

import Foundation

enum EmulatorError: Error {
    case invalidURL
    case resetFailed
    case unexpected
}

struct FirebaseConfig: Decodable {
    let projectId: String

    enum CodingKeys: String, CodingKey {
        case projectId = "PROJECT_ID"
    }
}


class FirestoreTestHelper {
    
    var projectId: String 
    
    init() async throws {
        guard let url = Bundle.main.url(forResource: "GoogleService-Info", withExtension: "plist"), 
              let data = try? Data(contentsOf: url),
        let config = try? PropertyListDecoder().decode(FirebaseConfig.self, from: data) else {
            throw EmulatorError.unexpected
        }
         
        self.projectId = config.projectId
        try await clearFirestoreEmulator()
    }
    
    func clearFirestoreEmulator() async throws {
        guard let url = URL(
            string: "http://127.0.0.1:8080/emulator/v1/projects/\(projectId)/databases/(default)/documents"
        ) else { throw EmulatorError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw EmulatorError.resetFailed
        }
    }

    deinit {
        Task { [weak self] in
            try? await self?.clearFirestoreEmulator()
        }
    }
}
