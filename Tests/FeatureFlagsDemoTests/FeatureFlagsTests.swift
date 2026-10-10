//
//  FeatureFlagsTests.swift
//  FeatureFlagsDemoTests
//
//  Created by Hanushka Suren on 10/10/2026.
//

import Foundation
import Testing
@testable import FeatureFlagsDemo

struct MockFeatureFlagSource: FeatureFlagSource {
    let result: Result<[String: Bool], Error>

    func fetchFlags() async throws -> [String: Bool] {
        try result.get()
    }
}

@MainActor
struct FeatureFlagsTests {

    @Test func usesDefaultsBeforeAnythingIsFetched() {
        let flags = FeatureFlags()

        #expect(flags.isEnabled(.newCheckout) == false)
        #expect(flags.isEnabled(.promoBanner) == true)
    }

    @Test func remoteValueWinsOverDefault() async {
        let flags = FeatureFlags()

        await flags.refresh(from: MockFeatureFlagSource(result: .success(["newCheckout": true])))

        #expect(flags.isEnabled(.newCheckout) == true)
    }

    @Test func missingKeyFallsBackToDefault() async {
        let flags = FeatureFlags()

        await flags.refresh(from: MockFeatureFlagSource(result: .success(["newCheckout": true])))

        #expect(flags.isEnabled(.promoBanner) == true)
    }

    @Test func failedFetchKeepsWhatWeHad() async {
        let flags = FeatureFlags(values: ["newCheckout": true])

        await flags.refresh(from: MockFeatureFlagSource(result: .failure(URLError(.notConnectedToInternet))))

        #expect(flags.isEnabled(.newCheckout) == true)
    }

    @Test func remembersValuesForNextLaunch() async throws {
        let storage = try #require(UserDefaults(suiteName: UUID().uuidString))

        let firstLaunch = FeatureFlags(storage: storage)
        await firstLaunch.refresh(from: MockFeatureFlagSource(result: .success(["newCheckout": true])))

        let secondLaunch = FeatureFlags(storage: storage)

        #expect(secondLaunch.isEnabled(.newCheckout) == true)
    }
}
