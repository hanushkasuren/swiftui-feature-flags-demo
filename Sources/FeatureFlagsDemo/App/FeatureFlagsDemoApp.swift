//
//  FeatureFlagsDemoApp.swift
//  FeatureFlagsDemo
//
//  Created by Hanushka Suren on 10/10/2026.
//

import SwiftUI

@main
struct FeatureFlagsDemoApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var flags = FeatureFlags(storage: .standard)
    
    private let source = RemoteFlagSource(url: URL(string: "https://raw.githubusercontent.com/hanushkasuren/swiftui-feature-flags-demo/main/flags.json")!)

    var body: some Scene {
        WindowGroup {
            CheckoutView()
                .environment(flags)
                .task(id: scenePhase) {
                    if scenePhase == .active {
                        await flags.refresh(from: source)
                    }
                }
        }
    }
}
