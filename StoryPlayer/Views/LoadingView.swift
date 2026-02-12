//
//  ContentView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 12/02/2026.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.theme.companyColor.ignoresSafeArea()
            VStack {
                Spacer()
                Text("Story Player")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(Color.theme.companyText)
                Spacer()
                ProgressView()
                    .controlSize(.large)
                    .tint(Color.theme.companyText)
                Spacer()
            }
        }
    }
}

#Preview {
    LoadingView()
}
