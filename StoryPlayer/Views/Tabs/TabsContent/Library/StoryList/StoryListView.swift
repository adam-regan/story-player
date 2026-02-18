//
//  StoryList.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import SwiftUI

struct StoryListView: View {
    @EnvironmentObject var viewModel: StoriesViewModel
    let columns = [GridItem(.fixed(StoryCardView.size.height), spacing: 0)]
    var body: some View {
        if viewModel.stories.count > 0 {
            ScrollView(.horizontal) {
                LazyHGrid(rows: columns) {
                    Color.clear.frame(width: Spacing.md)
                    ForEach(viewModel.stories) { story in
                        NavigationLink(destination: StoryDetailView(story: story)) {
                            StoryCardView(story: story)
                        }.buttonStyle(.plain)
                    }
                    Color.clear.frame(width: Spacing.md)
                }
            }
            .scrollIndicators(.hidden)
            .frame(height: StoryCardView.size.height)
        }
    }
}

#Preview {
    NavigationStack {
        StoryListView()
            .environmentObject(StoriesViewModel())
            .environmentObject(AudioViewModel(audioPlayer: .init()))
    }
}
