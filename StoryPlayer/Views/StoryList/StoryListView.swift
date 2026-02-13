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
        NavigationStack {
            ScrollView(.horizontal) {
                LazyHGrid(rows: columns) {
                    ForEach($viewModel.stories) { story in
                        NavigationLink(destination: StoryDetailView(story: story)) {
                            StoryCardView(story: story)
                        }.buttonStyle(.plain)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .frame(height: StoryCardView.size.height)
        }
    }
}

#Preview {
    StoryListView()
        .environmentObject(StoriesViewModel())
}
