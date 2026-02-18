//
//  CustomTabView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 17/02/2026.
//

import SwiftUI

enum Tabs {
    case library, settings
}

struct CustomTabBarView: View {
    @EnvironmentObject var audioViewModel: AudioViewModel
    @Binding var selectedTab: Tabs
    let tabBarHeight: CGFloat = 60
    let gradientHeight: CGFloat = 28

    var body: some View {
        VStack {
            Spacer()
            ZStack(alignment: .top) {
                HStack(alignment: .center) {
                    CustomTab(selectedTab: $selectedTab, label: "Library", imageSystemName: "book.pages", targetTab: .library)
                    CustomTab(selectedTab: $selectedTab, label: "Settings", imageSystemName: "gearshape", targetTab: .settings)
                }
                .frame(height: tabBarHeight)
                .frame(maxWidth: .infinity)
                .background(Color.theme.contentBackground)
                .ignoresSafeArea(edges: .bottom)

                LinearGradient(
                    colors: [.clear, Color.theme.contentBackground],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: gradientHeight)
                .frame(maxWidth: .infinity)
                .offset(y: -gradientHeight)
                MiniAudioPlayerView()
                    .offset(y: -MiniAudioPlayerView.miniPlayerHeight)
            }
            
        }
    }
}

struct CustomTab: View {
    @Binding var selectedTab: Tabs
    var label: String
    var imageSystemName: String
    var targetTab: Tabs

    var body: some View {
        Button {
            selectedTab = targetTab
        } label: {
            VStack {
                Spacer()
                Image(systemName: imageSystemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                Text(label)
                    .font(.footnote)
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal, Spacing.lg)
        .foregroundStyle(selectedTab == targetTab ? Color.theme.companyColor : .gray)
    }
}

#Preview {
    @Previewable @State var selectedTab: Tabs = .library
    ZStack {
        Color.theme.companyColor.ignoresSafeArea()
        VStack {
            Spacer()
            CustomTabBarView(selectedTab: $selectedTab)
                .environmentObject(AudioViewModel(audioPlayer: .init()))
        }
    }
}
