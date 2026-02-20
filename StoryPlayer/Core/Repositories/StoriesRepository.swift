//
//  StoriesRepository.swift
//  StoryPlayer
//
//  Created by Adam Regan on 19/02/2026.
//

/// Dummy repository behaviour
struct StoriesRepository: StoriesRepositoryProtocol {
    func fetchStories() async throws -> [Story] {
        try await Task.sleep(for: .seconds(2))
        return Story.testData
    }

    func fetchFavoriteStories() async throws -> [Story] {
        try await Task.sleep(for: .seconds(5))
        return Story.testData.compactMap { $0.isFavorite ? $0 : nil }
    }
}
