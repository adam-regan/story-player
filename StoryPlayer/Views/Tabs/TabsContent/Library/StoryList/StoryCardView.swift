//
//  StoryListIcon.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import SwiftUI

struct StoryCardView: View {
    @EnvironmentObject var audioViewModel: AudioViewModel

    static let size = CGSize(width: 130, height: 195)
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
                            .foregroundStyle( Color.theme.palette1,Color.theme.contentBackground)
                            .scaledToFit()
                            .frame(width: 26)
                            .shadow(color: Color.black.opacity(0.6), radius: 4)
                    }
                }
            }
            .padding(Spacing.sm)
        }
        .frame(width: StoryCardView.size.width, height: StoryCardView.size.height)
    }
}

#Preview {
    StoryCardView(story: Story.testData[0]).environmentObject(AudioViewModel(audioPlayer: .init()))
}
