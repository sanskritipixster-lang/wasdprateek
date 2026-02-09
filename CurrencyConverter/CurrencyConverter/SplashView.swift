//
//  SplashView.swift
//  CurrencyConverter
//
//  Created by Prateek Kumar Rai on 09/02/26.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            Image("Logo")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.black)
        }
    }
}
