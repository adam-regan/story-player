//
//  ScrubbingBarView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 18/02/2026.
//

import SwiftUI

struct ScrubbingBarView: View {
    @EnvironmentObject var audioViewModel: AudioViewModel

    @State var isScrubbing: Bool = false
    @State var scrubbingProgress: CGFloat = 0

    var body: some View {
        let barHeight: CGFloat = 4
        if audioViewModel.isDisabled {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: barHeight)
                .cornerRadius(2)
        } else {
            GeometryReader { geo in
                let circleDiameter: CGFloat = 12
                let progress = max(0, min(1, isScrubbing ? scrubbingProgress : audioViewModel.timePercentage))
                let maxWidth = geo.size.width
                let barWidth = maxWidth * progress

                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: barHeight)
                    .cornerRadius(2)
                    .overlay(alignment: .leading) {
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.theme.palette1)
                                .frame(width: barWidth, height: barHeight)
                                .cornerRadius(2)

                            Circle()
                                .fill(Color.theme.palette1)
                                .frame(width: circleDiameter, height: circleDiameter)
                                .offset(x: barWidth - circleDiameter / 2)
                        }
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                isScrubbing = true
                                let x = max(0, min(maxWidth, value.location.x))
                                let progress = x / maxWidth
                                scrubbingProgress = progress
                                audioViewModel.scrubTime(percentage: Double(progress))
                            }
                            .onEnded { value in
                                let x = max(0, min(maxWidth, value.location.x))
                                let finalProgress = x / maxWidth
                                scrubbingProgress = finalProgress
                                audioViewModel.scrubTime(percentage: Double(finalProgress))
                                isScrubbing = false
                            }
                    )
            }
            .frame(height: 12)
            HStack {
                Text(audioViewModel.formattedCurrentTime)
                Spacer()
                Text(audioViewModel.formattedDurationRemaining == audioViewModel.emptyFormattedTime ? audioViewModel.formattedDurationRemaining : "-\(audioViewModel.formattedDurationRemaining)")
            }
            .font(.footnote)
            .foregroundStyle(Color(.secondaryLabel))
        }
    }
}

#Preview("Empty") {
    let vm = AudioViewModel(audioPlayer: .init())
    ScrubbingBarView()
        .environmentObject(vm)
}

#Preview("With Story") {
    let audioViewModel = AudioViewModel(audioPlayer: .init())
    let story = Story(title: "Little Red Riding Hood", description: "A young girl is chased by a cunning wolf", author: "Charles Perrault", imageUrl: "little-red-riding-hood", url: "little-red-riding-hood")
    audioViewModel.play(story: story)
    audioViewModel.pause()
    return ScrubbingBarView()
        .environmentObject(audioViewModel)
}
