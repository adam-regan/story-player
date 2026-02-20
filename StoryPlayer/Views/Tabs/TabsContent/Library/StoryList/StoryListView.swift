//
//  StoryList.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import SwiftUI

struct StoryListView: View {
    @StateObject var viewModel: StoriesViewModel
    var title: String
    @Environment(\.storyListType) var listType

    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.title)
                    .bold()
                Spacer()
            }
            .padding(.horizontal, Spacing.md)
            switch viewModel.stories {
                case .loading:
                    StoryListContent {
                        LoadingListView()
                    }
                    .scrollDisabled(true)
                case let .error(error):
                    Text(error.localizedDescription)
                case .empty:
                    EmptyView()
                case let .loaded(stories):
                    StoryListContent {
                        ForEach(stories) { story in
                            NavigationLink(destination: StoryDetailView(story: story)) {
                                StoryCardView(story: story)
                            }.buttonStyle(.plain)
                        }
                    }
                    .scrollIndicators(.hidden)
            }
        }
        .onAppear {
            viewModel.fetchStories()
        }
    }
}

#Preview {
    NavigationStack {
        StoryListView(viewModel: StoriesViewModel(filter: .all, storiesRepository: StoriesRepository()), title: "Browse Stories")
            .environmentObject(AudioViewModel(audioPlayer: .init()))
            .environment(\.storyListType, .grid)
    }
}
