//
//  MainTabView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var audioViewModel: AudioViewModel = .init(audioPlayer: .init())
    @State private var selectedTab: Tabs = .library

    var body: some View {
        ZStack {
            switch selectedTab {
                case .library:
                    LibraryView()
                case .settings:
                    SettingsView()
            }
            CustomTabBarView(selectedTab: $selectedTab)
        }
        .environmentObject(audioViewModel)
    }
}

#Preview {
    MainTabView()
}
