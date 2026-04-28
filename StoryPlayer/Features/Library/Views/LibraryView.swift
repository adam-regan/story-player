//
//  LibraryView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import SwiftUI

struct LibraryView: View {
    @StateObject private var viewModel: LibraryViewModel
    @State private var alertPresented: Bool = false
    @State private var errorMessage: String = ""

    init(storiesRepository: StoriesRepositoryProtocol = StoriesRepository()) {
        _viewModel = StateObject(wrappedValue: LibraryViewModel(storiesRepository: storiesRepository))
    }

    var body: some View {
        NavigationStack {
            TabContentView(topColor: Color.theme.palette1, headerImageSystemName: "book.pages", headerTitle: "Library") {
                Group {
                    switch viewModel.stories {
                    case .loading, .error:
                        ForEach(viewModel.sections) { section in
                            StoryListView(title: section.title, stories: [])
                                .environment(\.storyListType, section.listType)
                        }
                    case .loaded:
                        ForEach(viewModel.sections) { section in
                            let stories = viewModel.stories(for: section.filter)
                            if !stories.isEmpty {
                                StoryListView(title: section.title, stories: stories)
                                    .environment(\.storyListType, section.listType)
                            }
                        }
                    }
                }
                .padding(.top, Spacing.sm)
            }
            .navigationDestination(for: Story.self) { story in
                StoryDetailView(story: story, onToggleFavorite: viewModel.toggleFavorite)
            }
        }
        .alert("Error", isPresented: $alertPresented) {
            Button("Retry") {
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
        .task {
            viewModel.fetchStories()
        }
    }
}

#Preview {
    LibraryView().environmentObject(AudioViewModel(audioPlayer: .init()))
}
