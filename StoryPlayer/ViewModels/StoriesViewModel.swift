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

    enum Filter {
        case all, favorites
    }

    init(filter: Filter, storiesRepository: StoriesRepositoryProtocol) {
        self.filter = filter
        self.storiesRepository = storiesRepository
    }

    func fetchStories() {
        Task {
            do {
                switch filter {
                case .all:
                    self.stories = try .loaded(await self.storiesRepository.fetchStories())
                case .favorites:
                    self.stories = try .loaded(await self.storiesRepository.fetchFavoriteStories())
                }
            } catch {
                print("Failed to load posts: \(error)")
            }
        }
    }
}
