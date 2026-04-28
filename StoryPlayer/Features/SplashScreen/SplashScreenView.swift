//
//  ContentView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 12/02/2026.
//

import SwiftUI

struct SplashScreenView: View {
    var continueAction: () -> Void

    var body: some View {
        ZStack {
            Color.theme.companyColor.ignoresSafeArea()
            VStack {
                Spacer()
                Text("Story Player")
                    .font(.largeTitle.bold())
                    .foregroundStyle(Color.theme.companyText)
                Spacer()
                Button(action: continueAction) {
                    Text("Continue")
                        .font(.title2.bold())
                        .foregroundStyle(Color.theme.companyColor)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.theme.companyText)
                Spacer()
            }
        }
    }
}

#Preview {
    SplashScreenView(continueAction: {})
}
