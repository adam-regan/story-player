//
//  StoryListIcon.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import SwiftUI

struct StoryCardView: View {
    static let size = CGSize(width: 120, height: 180)
    @Binding var story: Story

    var body: some View {
        Image(story.imageUrl)
            .resizable()
            .scaledToFill()
            .frame(width: StoryCardView.size.width, height: StoryCardView.size.height)
            .cornerRadius(8)
    }
}

#Preview {
    @Previewable @State var story = Story.testData[0]
    StoryCardView(story: $story)
}
