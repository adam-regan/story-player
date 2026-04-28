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
    @State private var story: Story
    var onToggleFavorite: (Story) -> Void

    init(story: Story, onToggleFavorite: @escaping (Story) -> Void) {
        _story = State(initialValue: story)
        self.onToggleFavorite = onToggleFavorite
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Back", systemImage: "chevron.left", action: dismiss.callAsFunction)
                    .labelStyle(.iconOnly)
                    .imageScale(.large)
                    .tint(.black)
                Spacer()
                Button("Favorite", systemImage: "heart\(story.isFavorite ? ".fill" : "")") {
                    toggleFavorite()
                }
                .labelStyle(.iconOnly)
                .imageScale(.large)
                .tint(.black)
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
                                .clipShape(.rect(cornerRadius: Radius.md))
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    let isPlaying = audioViewModel.isPlaying && audioViewModel.isCurrentStory(story)

                                    Button(isPlaying ? "Pause" : "Play", systemImage: "\(isPlaying ? "pause" : "play").circle.fill") {
                                        if isPlaying {
                                            audioViewModel.pause()
                                        } else {
                                            audioViewModel.play(story: story)
                                        }
                                    }
                                    .labelStyle(.iconOnly)
                                    .buttonStyle(.plain)
                                    .font(.system(size: 36))
                                    .foregroundStyle(Color.theme.palette1, Color.theme.contentBackground)
                                    .shadow(color: Color.black.opacity(0.5), radius: 4)
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

    private func toggleFavorite() {
        story.isFavorite.toggle()
        onToggleFavorite(story)
    }
}

#Preview {
    NavigationStack {
        StoryDetailView(story: Story.testData[3], onToggleFavorite: { _ in })
    }
    .environmentObject(AudioViewModel(audioPlayer: .init()))
}
