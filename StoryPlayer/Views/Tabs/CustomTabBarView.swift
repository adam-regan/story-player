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
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var audioViewModel: AudioViewModel
    @Binding var selectedTab: Tabs
    let gradientHeight: CGFloat = 28
    static let tabContainerHeight: (light: CGFloat, dark: CGFloat) = (light: 60, dark: 120)

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                VStack(spacing: 0) {
                    Spacer()
                    if colorScheme == .light {
                        LinearGradient(
                            colors: [.clear, Color.theme.tabBarBackground],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: gradientHeight)
                        .frame(maxWidth: .infinity)
                        .offset(y: 0)
                    }
                    HStack(alignment: .center) {
                        CustomTab(selectedTab: $selectedTab, label: "Library", imageSystemName: "book.pages", targetTab: .library)
                        CustomTab(selectedTab: $selectedTab, label: "Settings", imageSystemName: "gearshape", targetTab: .settings)
                    }
                    .frame(height: colorScheme == .light ? CustomTabBarView.tabContainerHeight.light : CustomTabBarView.tabContainerHeight.dark)
                    .frame(maxWidth: .infinity)
                    .background(Color.theme.tabBarBackground)
                    .ignoresSafeArea(edges: .bottom)
                }
                VStack {
                    Spacer()
                    MiniAudioPlayerView()
                        .offset(y: -CustomTabBarView.tabContainerHeight.light)
                }
            }
            .frame(maxHeight: .infinity)
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

private struct TabBarPreview: View {
    @State private var selectedTab: Tabs = .library

    var body: some View {
        ZStack {
            Color.theme.companyColor.ignoresSafeArea()
            VStack {
                Spacer()
                CustomTabBarView(selectedTab: $selectedTab)
                    .environmentObject(AudioViewModel(audioPlayer: .init()))
            }
        }
    }
}

#Preview(".light") {
    TabBarPreview()
}

#Preview(".dark") {
    TabBarPreview()
        .preferredColorScheme(.dark)
}
