//
//  StoryList.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import SwiftUI

struct StoryListView: View {
    @EnvironmentObject var viewModel: StoriesViewModel
    var title: String
    @Environment(\.storyListType) var listType

    var body: some View {
        VStack {
            switch viewModel.stories {
            case .loading:
                StoryListContent(title: title) {
                    LoadingListView()
                }
                .scrollDisabled(true)
            case let .error(error):
                Text(error.localizedDescription)
            case .empty:
                EmptyView()
            case let .loaded(stories):
                StoryListContent(title: title) {
                    ForEach(stories) { story in
                        NavigationLink(destination: StoryDetailView(viewModel: viewModel.makeStoryDetailViewModel(for: story))) {
                            StoryCardView(story: story)
                        }.buttonStyle(.plain)
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .onAppear {
            switch viewModel.stories {
            case .loaded:
                if viewModel.changesAfterFetch {
                    viewModel.fetchStories()
                }
            case .loading, .error:
                viewModel.fetchStories()
            }
        }
    }
}

#Preview {
    NavigationStack {
        StoryListView(title: "Browse Stories")
            .environmentObject(StoriesViewModel(filter: .all, storiesRepository: StoriesRepository()))
            .environmentObject(AudioViewModel(audioPlayer: .init()))
            .environment(\.storyListType, .grid)
    }
}
