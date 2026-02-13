//
//  StoriesViewModel.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import Foundation

@MainActor
class StoriesViewModel: ObservableObject {
    @Published var stories: [Story] = Story.testData
}
