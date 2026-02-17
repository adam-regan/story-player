//
//  StoryListIcon.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import SwiftUI

struct StoryCardView: View {
    static let size = CGSize(width: 130, height: 195)
    let story: Story

    var body: some View {
        Image(story.imageUrl)
            .resizable()
            .scaledToFill()
            .frame(width: StoryCardView.size.width, height: StoryCardView.size.height)
            .cornerRadius(Radius.md)
    }
}

#Preview {
    StoryCardView(story: Story.testData[0])
}
