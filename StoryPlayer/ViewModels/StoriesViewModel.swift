//
//  StoriesViewModel.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import Foundation

@MainActor
class StoriesViewModel: ObservableObject {
    @Published var stories: Loadable<[Story]> = .loading
    private let storiesRepository: StoriesRepositoryProtocol
    private let filter: Filter

    var changesAfterFetch: Bool {
        filter == .favorites
    }

    enum Filter {
        case all, favorites
    }

    init(filter: Filter, storiesRepository: StoriesRepositoryProtocol) {
        self.filter = filter
        self.storiesRepository = storiesRepository
    }

    func makeStoryDetailViewModel(for story: Story) -> StoryDetailViewModel {
        let favoriteAction: StoryDetailViewModel.Action = { [weak self] newValue in
            try await newValue ? self?.storiesRepository.favorite(story) : self?.storiesRepository.unfavorite(story)

            guard case .loaded(let stories) = self?.stories else { return }
            var newStories = stories
            guard let i = newStories.firstIndex(of: story) else { return }
            newStories[i].isFavorite = newValue
            self?.stories = .loaded(newStories)
        }
        return StoryDetailViewModel(
            story: story,
            favoriteAction: favoriteAction
        )
    }

    func fetchStories() {
        Task {
            do {
                stories = .loading
                switch self.filter {
                case .all:
                    self.stories = try .loaded(await self.storiesRepository.fetchStories())
                case .favorites:
                    self.stories = try .loaded(await self.storiesRepository.fetchFavoriteStories())
                }
            } catch {
                stories = .error(error)
            }
        }
    }
}
