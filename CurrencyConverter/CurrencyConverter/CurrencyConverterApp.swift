//
//  CurrencyConverterApp.swift
//  CurrencyConverter
//
//  Created by Prateek Kumar Rai on 09/02/26.
//

import SwiftUI
import SwiftData

@main
struct CurrencyConverterApp: App {
    @State private var showSplash = true
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                showSplash = false
                            }
                        }
                    }
            } else {
                if hasCompletedOnboarding {
                    HomeView()
                } else {
                    OnboardingView()
                }
            }
        }
        .modelContainer(for: Transaction.self)
    }
}
