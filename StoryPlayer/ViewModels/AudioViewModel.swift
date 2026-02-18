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
    @Published private(set) var isDisabled: Bool = true
    @Published private(set) var errorMessage: String?
    @Published private(set) var currentStory: Story?
    @Published private(set) var currentTime: TimeInterval = 0
    @Published private(set) var duration: TimeInterval = 0

    let emptyFormattedTime: String = ""

    private let audioPlayer: AudioPlayer

    var timePercentage: CGFloat {
        guard duration > 0 else { return 0 }
        return min(currentTime / duration, 1.0)
    }

    var formattedDurationRemaining: String {
        formatTime(duration - currentTime)
    }

    var formattedDuration: String {
        formatTime(duration)
    }

    var formattedCurrentTime: String {
        formatTime(currentTime)
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

    func changeTimeBySeconds(_ seconds: TimeInterval) {
        if seconds < 0 {
            audioPlayer.changeTimeBySeconds(abs(seconds), decrement: true)
        } else {
            audioPlayer.changeTimeBySeconds(seconds)
        }
    }
    
    func scrubTime(percentage: Double) {
        audioPlayer.changeTimePercentage(percentage)
    }

    func audioPlayer(_ player: AudioPlayer, didChangeState state: AudioPlayerState) {
        switch state {
            case .playing:
                isLoading = false
                isPlaying = true
                isDisabled = false
            case .paused, .stopped:
                isLoading = false
                isPlaying = false
                isDisabled = false
            case .idle:
                isLoading = false
                isPlaying = false
                isDisabled = true
            case .loading:
                isLoading = true
                isPlaying = false
                isDisabled = true
            case .error(let error):
                errorMessage = error.localizedDescription
                isLoading = false
                isDisabled = true
        }
    }

    func audioPlayer(_ player: AudioPlayer, didChangeDuration duration: TimeInterval) {
        self.duration = duration
    }

    func audioPlayer(_ player: AudioPlayer, didChangeCurrentTime currentTime: TimeInterval) {
        self.currentTime = currentTime
    }

    private func formatTime(_ time: TimeInterval) -> String {
        if duration == 0 { return emptyFormattedTime }
        return Duration.seconds(time).formatted(.time(pattern: .minuteSecond))
    }
}
