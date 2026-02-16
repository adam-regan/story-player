//
//  AudioViewModel.swift
//  StoryPlayer
//
//  Created by Adam Regan on 16/02/2026.
//

import Foundation

@MainActor
class AudioViewModel: ObservableObject, AudioPlayerDelegate {
    @Published var isLoading: Bool = false
    @Published var isPlaying: Bool = false
    @Published var errorMessage: String?
    @Published var currentStory: Story?

    private let audioPlayer: AudioPlayer

    init(audioPlayer: AudioPlayer) {
        self.audioPlayer = audioPlayer
        self.audioPlayer.delegate = self
    }

    func audioPlayer(_ player: AudioPlayer, didChangeState state: AudioPlayerState) {
        switch state {
            case .playing:
                isLoading = false
                isPlaying = true
            case .paused, .stopped, .idle:
                isLoading = false
                isPlaying = false
            case .loading:
                isLoading = true
                isPlaying = false
            case .error(let error):
                errorMessage = error.localizedDescription
                isLoading = false
        }
    }
}
