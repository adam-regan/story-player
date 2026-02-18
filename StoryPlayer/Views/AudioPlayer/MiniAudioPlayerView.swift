//
//  MiniAudioPlayer.swift
//  StoryPlayer
//
//  Created by Adam Regan on 18/02/2026.
//

import SwiftUI

struct MiniAudioPlayerView: View {
    @EnvironmentObject var audioViewModel: AudioViewModel
    static let miniPlayerHeight: CGFloat = 50
    @State private var audioPlayerOpen: Bool = false

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.theme.contentBackground)
                .frame(maxWidth: .infinity)
                .frame(height: MiniAudioPlayerView.miniPlayerHeight)
                .cornerRadius(Radius.md)
                .shadow(color: Color.black.opacity(0.2), radius: 8)
            HStack {
                if audioViewModel.isDisabled {
                    VStack {
                        Text("Nothing is playing").font(.footnote)
                    }
                } else {
                    VStack {
                        HStack {
                            Text(audioViewModel.currentStory?.title ?? "").font(.footnote)
                            Spacer()
                            Button(action: {
                                if audioViewModel.isPlaying {
                                    audioViewModel.pause()
                                } else {
                                    audioViewModel.play()
                                }
                            }) {
                                Image(systemName: "\(audioViewModel.isPlaying ? "pause" : "play").circle")
                                    .resizable()
                                    .fontWeight(.thin)
                                    .scaledToFit()
                                    .frame(width: 38, height: 38)
                                    .foregroundStyle(Color.theme.companyColor)
                            }
                        }
                        .padding(.horizontal, Spacing.sm)
                    }
                }
                Spacer()
                Button(action: {
                    audioPlayerOpen = true
                }) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .resizable()
                        .rotationEffect(Angle(degrees: 90))
                        .fontWeight(.thin)
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                .foregroundStyle(Color.theme.pallete2)
                .buttonStyle(.plain)
            }
            .padding(Spacing.md)
        }
        .frame(height: MiniAudioPlayerView.miniPlayerHeight)
        .padding(.horizontal, Spacing.md)
        .fullScreenCover(isPresented: $audioPlayerOpen) {
            AudioPlayerView()
        }
    }
}

#Preview {
    MiniAudioPlayerView().environmentObject(AudioViewModel(audioPlayer: .init()))
}
