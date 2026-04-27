//
//  LibraryView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import SwiftUI

struct LibraryView: View {
    @State private var storiesRepository = StoriesRepository()

    var body: some View {
        TabContent(topColor: Color.theme.palette1, headerImageSystemName: "book.pages", headerTitle: "Library") {
            Group {
                StoryListView(title: "Favourites")
                    .environmentObject(StoriesViewModel(filter: .favorites, storiesRepository: storiesRepository))
                    .environment(\.storyListType, .horizontal)
                StoryListView(title: "Browse")
                    .environmentObject(StoriesViewModel(filter: .all, storiesRepository: storiesRepository))
                    .environment(\.storyListType, .grid)
                StoryListView(title: "For You")
                    .environmentObject(StoriesViewModel(filter: .all, storiesRepository: storiesRepository))
                    .environment(\.storyListType, .horizontal)
            }
            .padding(.top, Spacing.sm)
        }
    }
}

#Preview {
    LibraryView().environmentObject(AudioViewModel(audioPlayer: .init()))
}
