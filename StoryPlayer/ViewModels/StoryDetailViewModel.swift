//
//  StoryDetailViewModel.swift
//  StoryPlayer
//
//  Created by Adam Regan on 22/02/2026.
//

import Foundation

@MainActor
@dynamicMemberLookup
class StoryDetailViewModel: ObservableObject {
    typealias Action = (Bool) async throws -> Void

    @Published var story: Story

    private let favoriteAction: Action

    init(story: Story, favoriteAction: @escaping Action) {
        self.story = story
        self.favoriteAction = favoriteAction
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Story, T>) -> T {
        story[keyPath: keyPath]
    }

    func favoritePost() {
        story.isFavorite.toggle()
        let newValue = story.isFavorite

        Task {
            do {
                try await favoriteAction(newValue)
            } catch {
                story.isFavorite.toggle()
                print("[PostRowViewModel] Error: \(error)")
            }
        }
    }
}
