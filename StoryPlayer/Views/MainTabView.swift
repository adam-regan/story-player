//
//  MainTabView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var audioViewModel: AudioViewModel = .init(audioPlayer: .init())
    var body: some View {
        TabView {
            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "book.pages")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .environmentObject(audioViewModel)
    }
}

#Preview {
    MainTabView()
}
