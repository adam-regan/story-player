//
//  StoryListContent.swift
//  StoryPlayer
//
//  Created by Adam Regan on 19/02/2026.
//

import SwiftUI

enum StoryListType: Equatable {
    case horizontal, grid
}

struct StoryListContent<Content: View>: View {
    @Environment(\.storyListType) var listType
    var title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        HStack {
            Text(title)
                .font(.title)
                .bold()
            Spacer()
        }
        .padding(.horizontal, Spacing.md)
        switch listType {
            case .horizontal:
                let gridItem = GridItem(.fixed(StoryCardView.size(for: listType).height), spacing: 0)
                let rows = [gridItem]
                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows) {
                        Color.clear.frame(width: Spacing.md)
                        content()
                        Color.clear.frame(width: Spacing.md)
                    }
                }
                .frame(height: StoryCardView.size(for: listType).height)
                .scrollIndicators(.hidden)
                .frame(height: StoryCardView.size(for: listType).height)
            case .grid:
                let gridItem = GridItem(.fixed(StoryCardView.size(for: listType).width), spacing: Spacing.xs)
                let columns = [gridItem, gridItem, gridItem]
                VStack(alignment: .leading) {
                    LazyVGrid(columns: columns) {
                        content()
                    }
                    .padding(.horizontal, Spacing.lg)
                    .scrollIndicators(.hidden)
                }
        }
    }
}

#Preview("Horizontal") {
    StoryListContent(title: "Browse") {
        LoadingListView()
    }
    .environment(\.storyListType, .horizontal)
}

#Preview("Grid") {
    StoryListContent(title: "Browse") {
        LoadingListView()
    }
    .environment(\.storyListType, .grid)
}
