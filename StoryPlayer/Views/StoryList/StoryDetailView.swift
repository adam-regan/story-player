//
//  StoryDetailView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import SwiftUI

struct StoryDetailView: View {
    @Binding var story: Story
    var body: some View {
        Text( /*@START_MENU_TOKEN@*/"Hello, World!" /*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    @Previewable @State var story = Story.testData[0]
    StoryDetailView(story: $story)
}
