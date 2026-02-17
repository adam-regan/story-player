//
//  AudioViewModel.swift
//  StoryPlayer
//
//  Created by Adam Regan on 16/02/2026.
//

import Foundation

@MainActor
class AudioViewModel: ObservableObject, AudioPlayerDelegate {
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isPlaying: Bool = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var currentStory: Story?
    @Published private(set) var currentTime: TimeInterval = 0
    @Published private(set) var duration: TimeInterval = 0

    private let audioPlayer: AudioPlayer

    var formattedDuration: String {
        Duration.seconds(duration).formatted(.time(pattern: .minuteSecond))
    }
    
    var formattedCurrentTime: String {
        Duration.seconds(currentTime).formatted(.time(pattern: .minuteSecond))
    }

    init(audioPlayer: AudioPlayer) {
        self.audioPlayer = audioPlayer
        self.audioPlayer.delegate = self
    }

    func isCurrentStory(_ story: Story) -> Bool {
        currentStory?.id == story.id
    }

    func play(story newStory: Story? = nil) {
        if newStory != nil, newStory?.id != currentStory?.id {
            currentStory = newStory
            if let url = Bundle.main.url(forResource: currentStory?.url, withExtension: ".mp3") {
                audioPlayer.load(url: url, playWhenReady: true)
            }
        } else if audioPlayer.state != .playing {
            audioPlayer.play()
        }
    }

    func pause() {
        audioPlayer.pause()
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

    func audioPlayer(_ player: AudioPlayer, didChangeDuration duration: TimeInterval) {
        self.duration = duration
    }

    func audioPlayer(_ player: AudioPlayer, didChangeCurrentTime currentTime: TimeInterval) {
        self.currentTime = currentTime
    }
}
