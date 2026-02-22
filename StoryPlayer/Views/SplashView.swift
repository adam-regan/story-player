//
//  ContentView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 12/02/2026.
//

import SwiftUI

struct SplashView: View {
    var continueAction: () -> Void

    var body: some View {
        ZStack {
            Color.theme.companyColor.ignoresSafeArea()
            VStack {
                Spacer()
                Text("Story Player")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(Color.theme.companyText)
                Spacer()
                Button(action: continueAction) {
                    Text("Continue")
                        .font(.system(size: 25, weight: .bold))
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
    SplashView(continueAction: {})
}
