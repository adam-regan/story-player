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
    @State var alertPresented: Bool = false
    @State var errorMessage: String = ""

    var body: some View {
        VStack {
            switch viewModel.stories {
            case .loading, .error:
                StoryListContent(title: title) {
                    LoadingListView()
                }
                .scrollDisabled(true)
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
        .alert("Error", isPresented: $alertPresented) {
            Button("Retry") {
                alertPresented = false
                viewModel.fetchStories()
            }
        } message: {
            Text(errorMessage)
        }
        .onChange(of: viewModel.stories) {
            if case let .error(error) = viewModel.stories {
                errorMessage = error.localizedDescription
                alertPresented = true
            } else {
                errorMessage = ""
                alertPresented = false
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

#if DEBUG
@MainActor
private struct StoryListPreview: View {
    let state: Loadable<[Story]>

    var body: some View {
        let storiesRepository = StoriesRepositoryStub(state: state)
        let viewModel = StoriesViewModel(filter: .all, storiesRepository: storiesRepository)
        NavigationStack {
            StoryListView(title: "Browse Stories")
                .environmentObject(viewModel)
                .environmentObject(AudioViewModel(audioPlayer: .init()))
                .environment(\.storyListType, .grid)
        }
    }
}

#Preview("Loaded") {
    StoryListPreview(state: .loaded([Story.testData[0]]))
}

#Preview("Loading") {
    StoryListPreview(state: .loading)
}

#Preview("Error") {
    StoryListPreview(state: .error)
}

#endif
