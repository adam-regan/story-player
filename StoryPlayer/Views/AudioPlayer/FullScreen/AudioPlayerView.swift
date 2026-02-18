//
//  AudioPlayerView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 17/02/2026.
//

import SwiftUI

struct AudioPlayerView: View {
    @EnvironmentObject var audioViewModel: AudioViewModel
    @Environment(\.dismiss) private var dismiss
    @State var isScrubbing: Bool = false
    @State var scrubbingProgress: CGFloat = 0

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Color.theme.headerBackgroundColor.ignoresSafeArea()
                Color.theme.companyColor.ignoresSafeArea()
            }
            VStack {
                HeaderPlayerView()
                if let imageURL = audioViewModel.currentStory?.imageUrl {
                    Image(imageURL)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 320)
                        .cornerRadius(Radius.md)
                }
                Spacer()
                if !audioViewModel.isDisabled {
                    MainPlayerButtonsView()
                } else {
                    Text("Choose a story and come back!")
                        .font(.largeTitle)
                        .foregroundStyle(Color.theme.headerBackgroundColor)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
            .padding(.horizontal, Spacing.lg)
        }
    }
}

#Preview("Empty - No Current Story") {
    let audioViewModel = AudioViewModel(audioPlayer: .init())
    AudioPlayerView()
        .environmentObject(audioViewModel)
}

#Preview("With Current Story") {
    let audioViewModel = AudioViewModel(audioPlayer: .init())
    let story = Story(title: "Little Red Riding Hood", description: "A young girl is chased by a cunning wolf", author: "Charles Perrault", imageUrl: "little-red-riding-hood", url: "little-red-riding-hood")
    audioViewModel.play(story: story)
    audioViewModel.pause()
    return AudioPlayerView()
        .environmentObject(audioViewModel)
}
