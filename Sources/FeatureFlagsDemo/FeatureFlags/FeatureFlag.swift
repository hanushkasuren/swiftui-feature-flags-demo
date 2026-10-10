//
//  FeatureFlag.swift
//  FeatureFlagsDemo
//
//  Created by Hanushka Suren on 10/10/2026.
//

enum FeatureFlag: String, CaseIterable {
    case newCheckout
    case promoBanner

    var defaultValue: Bool {
        switch self {
        case .newCheckout: false
        case .promoBanner: true
        }
    }
}
