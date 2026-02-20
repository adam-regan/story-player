//
//  StoryListTypeEnvironmentKey.swift
//  StoryPlayer
//
//  Created by Adam Regan on 20/02/2026.
//

import SwiftUI

private struct StoryListTypeKey: EnvironmentKey {
    static let defaultValue: StoryListType = .grid
}

extension EnvironmentValues {
    var storyListType: StoryListType {
        get { self[StoryListTypeKey.self] }
        set { self[StoryListTypeKey.self] = newValue }
    }
}
