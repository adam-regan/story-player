//
//  StoriesRepository.swift
//  StoryPlayer
//
//  Created by Adam Regan on 19/02/2026.
//

import SwiftUI

/// Dummy repository behaviour
struct StoriesRepository: StoriesRepositoryProtocol {
    @AppStorage("colorTheme") private var isDarkMode = false

    func fetchStories() async throws -> [Story] {
        return Story.testData
    }

    func fetchFavoriteStories() async throws -> [Story] {
        return Story.testData.compactMap { $0.isFavorite ? $0 : nil }
    }

    func favorite(_ story: Story) async throws {
        guard let i = Story.testData.firstIndex(of: story) else { return }
        Story.testData[i].isFavorite = true
    }

    func unfavorite(_ story: Story) async throws {
        guard let i = Story.testData.firstIndex(of: story) else { return }
        Story.testData[i].isFavorite = false
    }
}
