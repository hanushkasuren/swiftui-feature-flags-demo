//
//  FeatureFlagSource.swift
//  FeatureFlagsDemo
//
//  Created by Hanushka Suren on 10/10/2026.
//

import Foundation

protocol FeatureFlagSource: Sendable {
    func fetchFlags() async throws -> [String: Bool]
}

struct RemoteFlagSource: FeatureFlagSource {
    let url: URL

    func fetchFlags() async throws -> [String: Bool] {
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([String: Bool].self, from: data)
    }
}
