//
//  StoriesViewModelTests.swift
//  StoryPlayerTests
//
//  Created by Adam Regan on 23/02/2026.
//

import Foundation
@testable import StoryPlayer
import Testing

@Suite("Stories View Model State Tests")
@MainActor
struct StoriesViewModelTests {
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
        var fetchFavoritesCallCount = 0
        
        init(behavior: MockBehavior) {
            self.behavior = behavior
        }
        
        func fetchStories() async throws -> [Story] {
            fetchStoriesCallCount += 1
            return try await performBehavior()
        }
        
        func fetchFavoriteStories() async throws -> [Story] {
            fetchFavoritesCallCount += 1
            return try await performBehavior()
        }
        
        func favorite(_ story: Story) async throws {
            // Mock implementation
        }
        
        func unfavorite(_ story: Story) async throws {
            // Mock implementation
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
        // Given
        let repository = MockStoriesRepository(behavior: .success(testStories))
        let viewModel = StoriesViewModel(filter: .all, storiesRepository: repository)
        
        // Then
        expectState(viewModel.stories, toBe: .loading, "Expected initial state to be .loading")
    }
    
    @Test("Fetching stories should start in loading state")
    func fetchStoriesStartsWithLoading() {
        // Given
        let repository = MockStoriesRepository(behavior: .delay(seconds: 0.1, then: testStories))
        let viewModel = StoriesViewModel(filter: .all, storiesRepository: repository)
        
        // When
        viewModel.fetchStories()
        
        // Then
        expectState(viewModel.stories, toBe: .loading, "Expected state to be .loading during fetch")
    }
    
    // MARK: - Success State Tests
    
    @Test("Successfully fetching stories should transition to loaded state")
    func successfulFetchTransitionsToLoaded() async throws {
        // Given
        let repository = MockStoriesRepository(behavior: .success(testStories))
        let viewModel = StoriesViewModel(filter: .all, storiesRepository: repository)
        
        // When
        viewModel.fetchStories()
        
        // Wait for async operation to complete
        try await Task.sleep(for: .milliseconds(100))
        
        // Then
        guard case .loaded(let stories) = viewModel.stories else {
            Issue.record("Expected state to be .loaded, but got \(viewModel.stories)")
            return
        }
        
        #expect(stories.count == testStories.count)
        #expect(stories[0].title == "Test Story 1")
        #expect(stories[1].title == "Test Story 2")
        #expect(stories[2].title == "Test Story 3")
    }
    
    @Test("Successfully fetching empty stories should transition to empty state")
    func successfulEmptyFetchTransitionsToEmpty() async throws {
        // Given
        let repository = MockStoriesRepository(behavior: .success([]))
        let viewModel = StoriesViewModel(filter: .all, storiesRepository: repository)
        
        // When
        viewModel.fetchStories()
        
        // Wait for async operation
        try await Task.sleep(for: .milliseconds(100))
        
        // Then
        expectState(viewModel.stories, toBe: .empty, "Expected state to be .empty for empty array")
    }
    
    // MARK: - Error State Tests
    
    @Test("Failed fetch should transition to error state")
    func failedFetchTransitionsToError() async throws {
        // Given
        let expectedError = MockError(message: "Network connection failed")
        let repository = MockStoriesRepository(behavior: .failure(expectedError))
        let viewModel = StoriesViewModel(filter: .all, storiesRepository: repository)
        
        // When
        viewModel.fetchStories()
        
        // Wait for async operation
        try await Task.sleep(for: .milliseconds(100))
        
        // Then
        guard case .error(let error) = viewModel.stories else {
            Issue.record("Expected state to be .error, but got \(viewModel.stories)")
            return
        }
        
        #expect(error.localizedDescription == "Network connection failed")
    }
    
    // MARK: - State Transition Tests
    
    @Test("Transitioning from loaded to loading on new fetch")
    func transitionFromLoadedToLoadingOnRefetch() async throws {
        // Given - first fetch succeeds
        let repository = MockStoriesRepository(behavior: .success(testStories))
        let viewModel = StoriesViewModel(filter: .all, storiesRepository: repository)
        
        viewModel.fetchStories()
        try await Task.sleep(for: .milliseconds(100))
        
        #expect(repository.fetchStoriesCallCount == 1)
        
        // When - fetch again with delay
        repository.behavior = .delay(seconds: 0.2, then: testStories)
        viewModel.fetchStories()
        try await Task.sleep(for: .milliseconds(50))
        
        // Then
        expectState(viewModel.stories, toBe: .loading, "Expected loading state during refetch")
        
        // Wait for completion
        try await Task.sleep(for: .milliseconds(300))
        #expect(repository.fetchStoriesCallCount == 2)
    }
    
    @Test("Transitioning from error to loaded on successful retry")
    func transitionFromErrorToLoadedOnRetry() async throws {
        // Given - initial fetch fails
        let repository = MockStoriesRepository(behavior: .failure(MockError(message: "Initial error")))
        let viewModel = StoriesViewModel(filter: .all, storiesRepository: repository)
        
        viewModel.fetchStories()
        try await Task.sleep(for: .milliseconds(100))
        
        expectState(viewModel.stories, toBe: .error, "Expected error state initially")
        
        // When - retry succeeds
        repository.behavior = .success(testStories)
        viewModel.fetchStories()
        try await Task.sleep(for: .milliseconds(100))
        
        // Then - should be in loaded state
        guard case .loaded(let stories) = viewModel.stories else {
            #expect(Bool(false), "Expected loaded state after successful retry")
            return
        }
        
        #expect(stories.count == 3)
        #expect(repository.fetchStoriesCallCount == 2)
    }
    
    @Test("Multiple rapid fetches should be handled correctly")
    func multipleRapidFetchesHandledCorrectly() async throws {
        // Given
        let repository = MockStoriesRepository(behavior: .success(testStories))
        let viewModel = StoriesViewModel(filter: .all, storiesRepository: repository)
        
        // When - trigger multiple fetches rapidly
        viewModel.fetchStories()
        viewModel.fetchStories()
        viewModel.fetchStories()
        
        try await Task.sleep(for: .milliseconds(200))
        
        // Then - should end up in loaded state
        guard case .loaded(let stories) = viewModel.stories else {
            Issue.record("Expected loaded state after multiple fetches")
            return
        }
        
        #expect(stories.count == testStories.count)
    }
    
    // MARK: - Filter Tests
    
    @Test("All filter should fetch all stories")
    func allFilterFetchesAllStories() async throws {
        // Given
        let repository = MockStoriesRepository(behavior: .success(testStories))
        let viewModel = StoriesViewModel(filter: .all, storiesRepository: repository)
        
        // When
        viewModel.fetchStories()
        try await Task.sleep(for: .milliseconds(100))
        
        // Then
        #expect(repository.fetchStoriesCallCount == 1)
        #expect(repository.fetchFavoritesCallCount == 0)
        guard case .loaded(let stories) = viewModel.stories else {
            Issue.record("Expected loaded state")
            return
        }
        #expect(stories.count == testStories.count)
    }
    
    @Test("Favorites filter should fetch favorite stories")
    func favoritesFilterFetchesFavoriteStories() async throws {
        // Given
        let favoriteStories = testStories.filter { $0.isFavorite }
        let repository = MockStoriesRepository(behavior: .success(favoriteStories))
        let viewModel = StoriesViewModel(filter: .favorites, storiesRepository: repository)
        
        // When
        viewModel.fetchStories()
        try await Task.sleep(for: .milliseconds(100))
        
        // Then
        #expect(repository.fetchFavoritesCallCount == 1)
        
        guard case .loaded(let stories) = viewModel.stories else {
            Issue.record("Expected loaded state")
            return
        }
        
        #expect(stories.allSatisfy { $0.isFavorite })
    }
}
