//
//  StoriesRepositoryProtocol.swift
//  StoryPlayer
//
//  Created by Adam Regan on 19/02/2026.
//

protocol StoriesRepositoryProtocol {
    func fetchStories() async throws -> [Story]
    func fetchFavoriteStories() async throws -> [Story]
}
