//
//  StoryDetailView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 13/02/2026.
//

import SwiftUI

struct StoryDetailView: View {
    @EnvironmentObject var audioViewModel: AudioViewModel
    @Environment(\.dismiss) private var dismiss
    var story: Story

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .tint(.black)
                    .onTapGesture { dismiss() }
                Spacer()
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.vertical, Spacing.md)
            .background(Color.theme.palette4)
            ScrollView {
                VStack {
                    ZStack(alignment: .top) {
                        Color.theme.palette4
                            .frame(maxWidth: .infinity)
                            .frame(height: 250)
                        ZStack {
                            Image(story.imageUrl)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 200)
                                .clipped()
                                .cornerRadius(Radius.md)
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    let isPlaying = audioViewModel.isPlaying && audioViewModel.isCurrentStory(story)

                                    Button(action: {
                                        if isPlaying {
                                            audioViewModel.pause()
                                        } else {
                                            audioViewModel.play(story: story)
                                        }
                                    }) {
                                        Image(systemName: "\(isPlaying ? "pause" : "play").circle.fill")
                                            .resizable()
                                            .foregroundStyle(Color.theme.palette1, Color.theme.contentBackground)
                                            .scaledToFit()
                                            .frame(width: 36)
                                            .shadow(color: Color.black.opacity(0.5), radius: 4)
                                    }
                                }
                            }
                            .padding(Spacing.sm)
                        }
                        .frame(maxWidth: 200)
                    }
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(story.title)
                                    .font(.title)
                                    .bold()
                                    .padding(.bottom, Spacing.xs)
                                Text("By \(story.author)")
                                    .font(.body)
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                    .disabled(audioViewModel.isLoading)
                }
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        StoryDetailView(story: Story.testData[0])
    }
    .environmentObject(AudioViewModel(audioPlayer: .init()))
}
