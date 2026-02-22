//
//  StoriesRepositoryStub.swift
//  StoryPlayer
//
//  Created by Adam Regan on 22/02/2026.
//

#if DEBUG
struct StoriesRepositoryStub: StoriesRepositoryProtocol {
    let state: Loadable<[Story]>

    func favorite(_ post: Story) async throws {}

    func unfavorite(_ post: Story) async throws {}

    func fetchFavoriteStories() async throws -> [Story] {
        return try await state.simulate()
    }

    func fetchStories() async throws -> [Story] {
        return try await state.simulate()
    }
}
#endif
