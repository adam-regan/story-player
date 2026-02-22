//
//  StoriesRepository.swift
//  StoryPlayer
//
//  Created by Adam Regan on 19/02/2026.
//

import Foundation

/// Dummy repository that saves to JSON rather than hitting a real backend
class StoriesRepository: StoriesRepositoryProtocol {
    private let fileURL: URL

    init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documentsDirectory.appendingPathComponent("stories.json")
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            saveStories(Story.testData)
        }
    }

    private func loadStoriesFromFile() -> [Story] {
        guard let data = try? Data(contentsOf: fileURL),
              let stories = try? JSONDecoder().decode([Story].self, from: data)
        else {
            return Story.testData
        }
        return stories
    }

    private func saveStories(_ stories: [Story]) {
        guard let data = try? JSONEncoder().encode(stories) else { return }
        try? data.write(to: fileURL)
    }

    func fetchStories() async throws -> [Story] {
        return loadStoriesFromFile()
    }

    func fetchFavoriteStories() async throws -> [Story] {
        return loadStoriesFromFile().filter { $0.isFavorite }
    }

    func favorite(_ story: Story) async throws {
        var stories = loadStoriesFromFile()
        guard let index = stories.firstIndex(where: { $0.id == story.id }) else { return }
        stories[index].isFavorite = true
        saveStories(stories)
    }

    func unfavorite(_ story: Story) async throws {
        var stories = loadStoriesFromFile()
        guard let index = stories.firstIndex(where: { $0.id == story.id }) else { return }
        stories[index].isFavorite = false
        saveStories(stories)
    }
}
