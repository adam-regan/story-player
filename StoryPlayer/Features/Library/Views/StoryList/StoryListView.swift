//
//  StoryListView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import SwiftUI

struct StoryListView: View {
    var title: String
    var stories: [Story]
    @Environment(\.storyListType) var listType

    var body: some View {
        if stories.isEmpty {
            StoryListContentView(title: title) {
                LoadingListView()
            }
            .scrollDisabled(true)
        } else {
            StoryListContentView(title: title) {
                ForEach(stories) { story in
                    NavigationLink(value: story) {
                        StoryCardView(story: story)
                    }.buttonStyle(.plain)
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

#if DEBUG
#Preview("Loaded") {
    NavigationStack {
        StoryListView(title: "Browse Stories", stories: Story.testData)
            .environmentObject(AudioViewModel(audioPlayer: .init()))
            .environment(\.storyListType, .grid)
    }
}

#Preview("Loading") {
    NavigationStack {
        StoryListView(title: "Browse Stories", stories: [])
            .environmentObject(AudioViewModel(audioPlayer: .init()))
            .environment(\.storyListType, .grid)
    }
}
#endif
