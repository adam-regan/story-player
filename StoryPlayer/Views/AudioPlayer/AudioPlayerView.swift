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

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Color.theme.headerBackgroundColor.ignoresSafeArea()
                Color.theme.companyColor.ignoresSafeArea()
            }
            VStack {
                VStack {
                    HStack {
                        Text(audioViewModel.currentStory?.title ?? "Nothing is playing")
                        Spacer()
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrow.down.right.and.arrow.up.left")
                                .resizable()
                                .rotationEffect(Angle(degrees: 90))
                                .fontWeight(.thin)
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, Spacing.md)
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 4)
                            .cornerRadius(2)

                        GeometryReader { geo in
                            Rectangle()
                                .fill(Color.accentColor)
                                .frame(width: geo.size.width * audioViewModel.timePercentage, height: 4)
                                .cornerRadius(2)
                        }
                    }
                    .frame(height: 4)
                    HStack {
                        Text(audioViewModel.formattedCurrentTime)
                        Spacer()
                        Text(audioViewModel.formattedDurationRemaining == audioViewModel.emptyFormattedTime ? audioViewModel.formattedDurationRemaining : "-\(audioViewModel.formattedDurationRemaining)")
                    }
                    .font(.footnote)
                    .foregroundStyle(Color(.secondaryLabel))
                }
                if let imageURL = audioViewModel.currentStory?.imageUrl {
                    Image(imageURL)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 320)
                        .cornerRadius(Radius.md)
                }
                Spacer()
                if !audioViewModel.isDisabled {
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
                } else {
                    Text("Choose a story and come back!")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
            .padding(.horizontal, Spacing.lg)
        }
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

#Preview("Empty - No Current Story") {
    let vm = AudioViewModel(audioPlayer: .init())
    AudioPlayerView()
        .environmentObject(vm)
}

#Preview("With Current Story") {
    let audioViewModel = AudioViewModel(audioPlayer: .init())
    let story = Story(title: "Little Red Riding Hood", description: "A young girl is chased by a cunning wolf", author: "Charles Perrault", imageUrl: "little-red-riding-hood", url: "little-red-riding-hood")
    audioViewModel.play(story: story)
    audioViewModel.pause()
    return AudioPlayerView()
        .environmentObject(audioViewModel)
}
