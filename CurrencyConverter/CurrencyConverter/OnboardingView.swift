//
//  OnboardingView.swift
//  CurrencyConverter
//
//  Created by Prateek Kumar Rai on 09/02/26.
//

import SwiftUI

struct OnboardingView: View {

    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("Welcome to \n Currency Convert!")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Image("Illustrator")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
            
            Spacer()

            Text("Instantly convert between over \n 150 currencies. Currency Convert is your \n one-stop solution for effortless currenc \n conversions.")
                .font(.callout)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)

            Spacer()

            Button(action: {
                hasCompletedOnboarding = true
            }) {
                Text("Get Started")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 32)
        }
    }
}
