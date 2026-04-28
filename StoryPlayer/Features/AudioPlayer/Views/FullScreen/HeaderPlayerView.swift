//
//  HeaderPlayerView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 18/02/2026.
//

import SwiftUI

struct HeaderPlayerView: View {
    @EnvironmentObject var audioViewModel: AudioViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
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

            ScrubbingBarView()
        }
    }
}

#Preview {
    let audioViewModel = AudioViewModel(audioPlayer: .init())
    HeaderPlayerView()
        .environmentObject(audioViewModel)
}
