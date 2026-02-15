//
//  RootView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import SwiftUI

struct RootView: View {
    enum RootState {
        case loading, main
    }

    @State var rootState: RootState = .loading

    var body: some View {
        switch rootState {
        case .loading:
            SplashView(continueAction: {
                rootState = .main
            })
        case .main:
            MainTabView()
        }
    }
}

#Preview {
    RootView()
}
