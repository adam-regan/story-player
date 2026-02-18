//
//  LibraryView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import SwiftUI

struct LibraryView: View {
    @StateObject var viewModel = StoriesViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.contentBackground
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "book.pages")
                        Text("Library")
                        Spacer()
                    }
                    .padding(.horizontal, Spacing.lg)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.theme.headerBackgroundColor)
                    ScrollView {
                        StoryListView()
                        StoryListView()
                        StoryListView()
                        StoryListView()
                        StoryListView()
                        StoryListView()
                        StoryListView()
                        StoryListView()
                        StoryListView()
                        Spacer()
                    }
                }
                VStack {
                    Color.theme.pallete1.ignoresSafeArea(edges: .top)
                        .frame(height: 0)
                    Spacer()
                }
            }
        }
        .background(.clear)
        .environmentObject(viewModel)
    }
}

#Preview {
    LibraryView().environmentObject(AudioViewModel(audioPlayer: .init()))
}
