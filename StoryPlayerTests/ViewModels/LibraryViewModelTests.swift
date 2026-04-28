//
//  LibraryViewModelTests.swift
//  StoryPlayerTests
//
//  Created by Adam Regan on 28/04/2026.
//

import Foundation
@testable import StoryPlayer
import Testing

@Suite("Library View Model Tests")
@MainActor
struct LibraryViewModelTests {
    // MARK: - Helper Extensions
    
    /// Helper to assert the current state of a Loadable matches the expected case
    private func expectState(
        _ loadable: Loadable<[Story]>,
        toBe expectedCase: Loadable<[Story]>,
        _ message: String
    ) {
        let matches = switch (loadable, expectedCase) {
        case (.loading, .loading): true
        case (.loaded, .loaded): true
        case (.error, .error): true
        default: false
        }
        
        #expect(matches, Comment(rawValue: message))
    }
    
    // MARK: - Mock Repository
    
    final class MockStoriesRepository: StoriesRepositoryProtocol {
        enum MockBehavior {
            case success([Story])
            case failure(Error)
            case delay(seconds: Double, then: [Story])
        }
        
        var behavior: MockBehavior
        var fetchStoriesCallCount = 0
        var favoriteCallCount = 0
        var unfavoriteCallCount = 0
        var shouldFailFavorite = false
        
        init(behavior: MockBehavior) {
            self.behavior = behavior
        }
        
        func fetchStories() async throws -> [Story] {
            fetchStoriesCallCount += 1
            return try await performBehavior()
        }
        
        func fetchFavoriteStories() async throws -> [Story] {
            return try await performBehavior()
        }
        
        func favorite(_ story: Story) async throws {
            favoriteCallCount += 1
            if shouldFailFavorite {
                throw MockError(message: "Favorite failed")
            }
        }
        
        func unfavorite(_ story: Story) async throws {
            unfavoriteCallCount += 1
            if shouldFailFavorite {
                throw MockError(message: "Unfavorite failed")
            }
        }
        
        private func performBehavior() async throws -> [Story] {
            switch behavior {
            case .success(let stories):
                return stories
            case .failure(let error):
                throw error
            case .delay(let seconds, let stories):
                try await Task.sleep(for: .seconds(seconds))
                return stories
            }
        }
    }
    
    struct MockError: Error, LocalizedError {
        let message: String
        var errorDescription: String? {
            message
        }
    }
    
    // MARK: - Test Data
    
    let testStories = [
        Story(
            title: "Test Story 1",
            description: "Description 1",
            author: "Author 1",
            imageUrl: "image1",
            url: "url1"
        ),
        Story(
            title: "Test Story 2",
            description: "Description 2",
            author: "Author 2",
            imageUrl: "image2",
            url: "url2",
            isFavorite: true
        ),
        Story(
            title: "Test Story 3",
            description: "Description 3",
            author: "Author 3",
            imageUrl: "image3",
            url: "url3"
        )
    ]
    
    // MARK: - Loading State Tests
    
    @Test("Initial state should be loading")
    func initialStateIsLoading() {
        let repository = MockStoriesRepository(behavior: .success(testStories))
        let viewModel = LibraryViewModel(storiesRepository: repository)
        
        expectState(viewModel.stories, toBe: .loading, "Expected initial state to be .loading")
    }
    
    @Test("Fetching stories should start in loading state")
    func fetchStoriesStartsWithLoading() {
        let repository = MockStoriesRepository(behavior: .delay(seconds: 0.1, then: testStories))
        let viewModel = LibraryViewModel(storiesRepository: repository)
        
        viewModel.fetchStories()
        
        expectState(viewModel.stories, toBe: .loading, "Expected state to be .loading during fetch")
    }
    
    // MARK: - Success State Tests
    
    @Test("Successfully fetching stories should transition to loaded state")
    func successfulFetchTransitionsToLoaded() async throws {
        let repository = MockStoriesRepository(behavior: .success(testStories))
        let viewModel = LibraryViewModel(storiesRepository: repository)
        
        viewModel.fetchStories()
        try await Task.sleep(for: .milliseconds(100))
        
        guard case .loaded(let stories) = viewModel.stories else {
            Issue.record("Expected state to be .loaded, but got \(viewModel.stories)")
            return
        }
        
        #expect(stories.count == testStories.count)
        #expect(stories[0].title == "Test Story 1")
        #expect(stories[1].title == "Test Story 2")
        #expect(stories[2].title == "Test Story 3")
    }
    
    // MARK: - Error State Tests
    
    @Test("Failed fetch should transition to error state")
    func failedFetchTransitionsToError() async throws {
        let expectedError = MockError(message: "Network connection failed")
        let repository = MockStoriesRepository(behavior: .failure(expectedError))
        let viewModel = LibraryViewModel(storiesRepository: repository)
        
        viewModel.fetchStories()
        try await Task.sleep(for: .milliseconds(100))
        
        guard case .error(let error) = viewModel.stories else {
            Issue.record("Expected state to be .error, but got \(viewModel.stories)")
            return
        }
        
        #expect(error.localizedDescription == "Network connection failed")
    }
    
    // MARK: - State Transition Tests
    
    @Test("Transitioning from loaded to loading on new fetch")
    func transitionFromLoadedToLoadingOnRefetch() async throws {
        let repository = MockStoriesRepository(behavior: .success(testStories))
        let viewModel = LibraryViewModel(storiesRepository: repository)
        
        viewModel.fetchStories()
        try await Task.sleep(for: .milliseconds(100))
        
        #expect(repository.fetchStoriesCallCount == 1)
        
        repository.behavior = .delay(seconds: 0.2, then: testStories)
        viewModel.fetchStories()
        try await Task.sleep(for: .milliseconds(50))
        
        expectState(viewModel.stories, toBe: .loading, "Expected loading state during refetch")
        
        try await Task.sleep(for: .milliseconds(300))
        #expect(repository.fetchStoriesCallCount == 2)
    }
    
    @Test("Transitioning from error to loaded on successful retry")
    func transitionFromErrorToLoadedOnRetry() async throws {
        let repository = MockStoriesRepository(behavior: .failure(MockError(message: "Initial error")))
        let viewModel = LibraryViewModel(storiesRepository: repository)
        
        viewModel.fetchStories()
        try await Task.sleep(for: .milliseconds(100))
        
        expectState(viewModel.stories, toBe: .error, "Expected error state initially")
        
        repository.behavior = .success(testStories)
        viewModel.fetchStories()
        try await Task.sleep(for: .milliseconds(100))
        
        guard case .loaded(let stories) = viewModel.stories else {
            #expect(Bool(false), "Expected loaded state after successful retry")
            return
        }
        
        #expect(stories.count == 3)
        #expect(repository.fetchStoriesCallCount == 2)
    }
    
    @Test("Multiple rapid fetches should be handled correctly")
    func multipleRapidFetchesHandledCorrectly() async throws {
        let repository = MockStoriesRepository(behavior: .success(testStories))
        let viewModel = LibraryViewModel(storiesRepository: repository)
        
        viewModel.fetchStories()
        viewModel.fetchStories()
        viewModel.fetchStories()
        
        try await Task.sleep(for: .milliseconds(200))
        
        guard case .loaded(let stories) = viewModel.stories else {
            Issue.record("Expected loaded state after multiple fetches")
            return
        }
        
        #expect(stories.count == testStories.count)
    }
    
    // MARK: - Filter Tests
    
    @Test("All filter should return all stories")
    func allFilterReturnsAllStories() async throws {
        let repository = MockStoriesRepository(behavior: .success(testStories))
        let viewModel = LibraryViewModel(storiesRepository: repository)
        
        viewModel.fetchStories()
        try await Task.sleep(for: .milliseconds(100))
        
        let allStories = viewModel.stories(for: .all)
        #expect(allStories.count == testStories.count)
    }
    
    @Test("Favorites filter should return only favorite stories")
    func favoritesFilterReturnsOnlyFavorites() async throws {
        let repository = MockStoriesRepository(behavior: .success(testStories))
        let viewModel = LibraryViewModel(storiesRepository: repository)
        
        viewModel.fetchStories()
        try await Task.sleep(for: .milliseconds(100))
        
        let favorites = viewModel.stories(for: .favorites)
        #expect(favorites.count == 1)
        #expect(favorites.allSatisfy { $0.isFavorite })
    }
    
    @Test("Filter should return empty array when not loaded")
    func filterReturnsEmptyWhenNotLoaded() {
        let repository = MockStoriesRepository(behavior: .success(testStories))
        let viewModel = LibraryViewModel(storiesRepository: repository)
        
        #expect(viewModel.stories(for: .all).isEmpty)
        #expect(viewModel.stories(for: .favorites).isEmpty)
    }
    
    // MARK: - Toggle Favorite Tests
    
    @Test("Toggle favorite should optimistically update story")
    func toggleFavoriteOptimisticallyUpdates() async throws {
        let repository = MockStoriesRepository(behavior: .success(testStories))
        let viewModel = LibraryViewModel(storiesRepository: repository)
        
        viewModel.fetchStories()
        try await Task.sleep(for: .milliseconds(100))
        
        let storyToToggle = testStories[0]
        #expect(storyToToggle.isFavorite == false)
        
        viewModel.toggleFavorite(storyToToggle)
        
        let updatedStories = viewModel.stories(for: .all)
        let updatedStory = updatedStories.first { $0.id == storyToToggle.id }
        #expect(updatedStory?.isFavorite == true)
    }
    
    @Test("Toggle favorite should revert on failure")
    func toggleFavoriteRevertsOnFailure() async throws {
        let repository = MockStoriesRepository(behavior: .success(testStories))
        let viewModel = LibraryViewModel(storiesRepository: repository)
        
        viewModel.fetchStories()
        try await Task.sleep(for: .milliseconds(100))
        
        let storyToToggle = testStories[0]
        #expect(storyToToggle.isFavorite == false)
        
        repository.shouldFailFavorite = true
        viewModel.toggleFavorite(storyToToggle)
        
        // Wait for the async revert
        try await Task.sleep(for: .milliseconds(100))
        
        let revertedStories = viewModel.stories(for: .all)
        let revertedStory = revertedStories.first { $0.id == storyToToggle.id }
        #expect(revertedStory?.isFavorite == false)
    }
}
