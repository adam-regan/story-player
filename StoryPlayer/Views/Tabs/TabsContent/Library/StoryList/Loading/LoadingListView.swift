//
//  LoadingListView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 19/02/2026.
//

import SwiftUI

struct LoadingListView: View {
    @Environment(\.storyListType) var listType
    var body: some View {
        ForEach(0 ... 5, id: \.self) { index in
            LoadingCardView(size: StoryCardView.size(for: listType), index: index)
        }
    }
}

#Preview("Horizontal") {
    StoryListContent {
        LoadingListView()
    }
    .environment(\.storyListType, .horizontal)
    .scrollDisabled(true)
}

#Preview("Grid") {
    StoryListContent {
        LoadingListView()
    }
    .environment(\.storyListType, .grid)
    .scrollDisabled(true)
}
