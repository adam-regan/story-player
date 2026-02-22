//
//  LibraryView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import SwiftUI

struct LibraryView: View {
    var body: some View {
        let storiesRepository = StoriesRepository()
        TabContent(topColor: Color.theme.palette1, headerImageSystemName: "book.pages", headerTitle: "Library") {
            ScrollView {
                StoryListView(title: "Favourites")
                    .environmentObject(StoriesViewModel(filter: .favorites, storiesRepository: storiesRepository))
                    .environment(\.storyListType, .horizontal)
                StoryListView(title: "Browse")
                    .environmentObject(StoriesViewModel(filter: .all, storiesRepository: storiesRepository))
                    .environment(\.storyListType, .grid)
                StoryListView(title: "For You")
                    .environmentObject(StoriesViewModel(filter: .all, storiesRepository: storiesRepository))
                    .environment(\.storyListType, .horizontal)
                Spacer()
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    LibraryView().environmentObject(AudioViewModel(audioPlayer: .init()))
}
