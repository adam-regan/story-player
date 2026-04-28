//
//  LibraryViewModel.swift
//  StoryPlayer
//
//  Created by Adam Regan on 27/04/2026.
//

import Foundation

@MainActor
class LibraryViewModel: ObservableObject {
    @Published var stories: Loadable<[Story]> = .loading

    private let storiesRepository: StoriesRepositoryProtocol

    let sections: [Section]

    struct Section: Identifiable {
        let id = UUID()
        let title: String
        let filter: Filter
        let listType: StoryListType
    }

    enum Filter {
        case all, favorites
    }

    init(storiesRepository: StoriesRepositoryProtocol) {
        self.storiesRepository = storiesRepository
        self.sections = LibraryViewModel.defaultSections
    }

    init(storiesRepository: StoriesRepositoryProtocol, sections: [Section]) {
        self.storiesRepository = storiesRepository
        self.sections = sections
    }

    static let defaultSections: [Section] = [
        Section(title: "Favourites", filter: .favorites, listType: .horizontal),
        Section(title: "Browse", filter: .all, listType: .grid),
        Section(title: "For You", filter: .all, listType: .horizontal),
    ]

    func stories(for filter: Filter) -> [Story] {
        guard case .loaded(let all) = stories else { return [] }
        switch filter {
        case .all: return all
        case .favorites: return all.filter(\.isFavorite)
        }
    }

    func fetchStories() {
        stories = .loading
        Task {
            do {
                stories = try .loaded(await storiesRepository.fetchStories())
            } catch {
                stories = .error(error)
            }
        }
    }

    func toggleFavorite(_ story: Story) {
        guard case .loaded(var currentStories) = stories,
              let index = currentStories.firstIndex(where: { $0.id == story.id }) else { return }

        let newValue = !currentStories[index].isFavorite
        currentStories[index].isFavorite = newValue
        stories = .loaded(currentStories)

        Task {
            do {
                if newValue {
                    try await storiesRepository.favorite(story)
                } else {
                    try await storiesRepository.unfavorite(story)
                }
            } catch {
                // Revert on failure
                guard case .loaded(var revertStories) = stories,
                      let i = revertStories.firstIndex(where: { $0.id == story.id }) else { return }
                revertStories[i].isFavorite = !newValue
                stories = .loaded(revertStories)
            }
        }
    }
}
