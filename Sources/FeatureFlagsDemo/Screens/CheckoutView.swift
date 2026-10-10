//
//  CheckoutView.swift
//  FeatureFlagsDemo
//
//  Created by Hanushka Suren on 10/10/2026.
//

import SwiftUI

struct CheckoutView: View {
    @Environment(FeatureFlags.self) private var flags

    var body: some View {
        VStack(spacing: 16) {
            if flags.isEnabled(.promoBanner) {
                PromoBanner()
            }

            if flags.isEnabled(.newCheckout) {
                NewCheckoutButton()
            } else {
                LegacyCheckoutButton()
            }
        }
        .padding()
    }
}

struct PromoBanner: View {
    var body: some View {
        Text("Free delivery this weekend")
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(.yellow, in: .rect(cornerRadius: 12))
    }
}

struct NewCheckoutButton: View {
    var body: some View {
        Button("Pay with one tap") {}
            .buttonStyle(.borderedProminent)
    }
}

struct LegacyCheckoutButton: View {
    var body: some View {
        Button("Go to checkout") {}
            .buttonStyle(.bordered)
    }
}

#Preview("Defaults") {
    CheckoutView()
        .environment(FeatureFlags())
}

#Preview("New checkout on") {
    CheckoutView()
        .environment(FeatureFlags(values: ["newCheckout": true]))
}

#Preview("Everything off") {
    CheckoutView()
        .environment(FeatureFlags(values: ["newCheckout": false, "promoBanner": false]))
}
