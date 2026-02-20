//
//  StoryListIcon.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import SwiftUI

struct StoryCardView: View {
    @EnvironmentObject var audioViewModel: AudioViewModel
    @Environment(\.storyListType) var listType

    static func size(for listType: StoryListType) -> CGSize {
        switch listType {
        case .horizontal: CGSize(width: 130, height: 195)
        case .grid: CGSize(width: 110, height: 165)
        }
    }

    let story: Story

    var body: some View {
        ZStack {
            Image(story.imageUrl)
                .resizable()
                .scaledToFill()
                .cornerRadius(Radius.md)
            let isPlaying = audioViewModel.isPlaying && audioViewModel.isCurrentStory(story)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        if !isPlaying {
                            audioViewModel.play(story: story)
                        }
                    }) {
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .foregroundStyle(Color.theme.palette1, Color.theme.contentBackground)
                            .scaledToFit()
                            .frame(width: 26)
                            .shadow(color: Color.black.opacity(0.6), radius: 4)
                    }
                }
            }
            .padding(Spacing.sm)
        }
        .frame(width: StoryCardView.size(for: listType).width, height: StoryCardView.size(for: listType).height)
    }
}

#Preview {
    StoryCardView(story: Story.testData[0]).environmentObject(AudioViewModel(audioPlayer: .init()))
        .environment(\.storyListType, .horizontal)
}
