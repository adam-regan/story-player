//
//  AudioPlayerView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 17/02/2026.
//

import SwiftUI

struct AudioPlayerView: View {
    @EnvironmentObject var audioViewModel: AudioViewModel

    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                if audioViewModel.isPlaying {
                    audioViewModel.pause()
                } else {
                    audioViewModel.play()
                }
            }) {
                Image(systemName: "\(audioViewModel.isPlaying ? "pause" : "play").circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
            }
            .padding(.vertical, Spacing.sm)
            ZStack(alignment: .leading) {
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
                .frame(height: 4)
            }
            HStack {
                Text(audioViewModel.formattedCurrentTime)
                Spacer()
                Text(audioViewModel.formattedDurationRemaining == audioViewModel.emptyFormattedTime ? audioViewModel.formattedDurationRemaining : "-\(audioViewModel.formattedDurationRemaining)")
            }
            .font(.footnote)
            .foregroundStyle(Color(.secondaryLabel))
        }
        .padding(.horizontal, Spacing.lg)
        .disabled(audioViewModel.isDisabled)
    }
}

#Preview {
    AudioPlayerView().environmentObject(AudioViewModel(audioPlayer: .init()))
}
