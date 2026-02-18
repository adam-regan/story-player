//
//  MainPlayerButtonsView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 18/02/2026.
//

import SwiftUI

struct MainPlayerButtonsView: View {
    @EnvironmentObject var audioViewModel: AudioViewModel

    var body: some View {
        HStack(spacing: Spacing.xxl) {
            MainPlayerButton(imageSystemName: "15.arrow.trianglehead.counterclockwise", width: 30) {
                audioViewModel.changeTimeBySeconds(-15)
            }
            MainPlayerButton(imageSystemName: "\(audioViewModel.isPlaying ? "pause" : "play").circle", width: 60) {
                if audioViewModel.isPlaying {
                    audioViewModel.pause()
                } else {
                    audioViewModel.play()
                }
            }
            MainPlayerButton(imageSystemName: "15.arrow.trianglehead.clockwise", width: 30) {
                audioViewModel.changeTimeBySeconds(15)
            }
        }
        .padding(.vertical, Spacing.xl)
    }
}

struct MainPlayerButton: View {
    var imageSystemName: String
    var width: CGFloat
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: imageSystemName)
                .resizable()
                .fontWeight(.thin)
                .foregroundStyle(Color.theme.contentBackground)
                .scaledToFit()
                .frame(width: width)
        }
    }
}

#Preview {
    let audioViewModel = AudioViewModel(audioPlayer: .init())
    let story = Story(title: "Little Red Riding Hood", description: "A young girl is chased by a cunning wolf", author: "Charles Perrault", imageUrl: "little-red-riding-hood", url: "little-red-riding-hood")
    audioViewModel.play(story: story)
    audioViewModel.pause()

    return ZStack {
        Color.theme.companyColor.ignoresSafeArea()
        MainPlayerButtonsView()
            .environmentObject(audioViewModel)
    }
}
