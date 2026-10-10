//
//  FeatureFlags.swift
//  FeatureFlagsDemo
//
//  Created by Hanushka Suren on 10/10/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class FeatureFlags {

    private var values: [String: Bool]
    private let storage: UserDefaults?
    private static let storageKey = "featureFlags.lastKnownValues"

    init(values: [String: Bool] = [:], storage: UserDefaults? = nil) {
        self.storage = storage
        let savedValues = storage?.dictionary(forKey: Self.storageKey) as? [String: Bool]
        self.values = savedValues ?? values
    }

    func isEnabled(_ flag: FeatureFlag) -> Bool {
        values[flag.rawValue] ?? flag.defaultValue
    }

    func refresh(from source: any FeatureFlagSource) async {
        do {
            let fetchedValues = try await source.fetchFlags()
            values = fetchedValues
            storage?.set(fetchedValues, forKey: Self.storageKey)
        } catch {
            // Keep the values we already have. Defaults still cover anything missing.
        }
    }
}
