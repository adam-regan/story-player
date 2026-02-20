//
//  LibraryView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import SwiftUI

struct LibraryView: View {
    @StateObject var viewModel = StoriesViewModel(filter: .all, storiesRepository: StoriesRepository())
    var body: some View {
        TabContent(topColor: Color.theme.palette1, headerImageSystemName: "book.pages", headerTitle: "Library") {
            ScrollView {
                StoryListView(viewModel: StoriesViewModel(filter: .favorites, storiesRepository: StoriesRepository()), title: "Favourites")
                    .environment(\.storyListType, .horizontal)
                StoryListView(viewModel: StoriesViewModel(filter: .all, storiesRepository: StoriesRepository()), title: "Browse")
                    .environment(\.storyListType, .grid)
                StoryListView(viewModel: StoriesViewModel(filter: .all, storiesRepository: StoriesRepository()), title: "For You")
                    .environment(\.storyListType, .horizontal)
                Spacer()
            }
            .padding(.vertical, Spacing.sm)
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    LibraryView().environmentObject(AudioViewModel(audioPlayer: .init()))
}
