//
//  AudioPlayer.swift
//  StoryPlayer
//
//  Created by Adam Regan on 16/02/2026.
//

import AVFoundation
import Foundation

enum AudioPlayerState: Equatable {
    static func == (lhs: AudioPlayerState, rhs: AudioPlayerState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading),
             (.playing, .playing), (.paused, .paused),
             (.stopped, .stopped), (.error, .error): return true
        default: return false
        }
    }

    case idle
    case loading
    case playing
    case paused
    case stopped
    case error(Error)
}

protocol AudioPlayerDelegate: AnyObject {
    func audioPlayer(_ player: AudioPlayer, didChangeState state: AudioPlayerState)
    func audioPlayer(_ player: AudioPlayer, didChangeDuration duration: TimeInterval)
    func audioPlayer(_ player: AudioPlayer, didChangeCurrentTime currentTime: TimeInterval)
}

class AudioPlayer: ObservableObject {
    weak var delegate: AudioPlayerDelegate?
    private var player: AVPlayer?
    private var timeObserver: Any?
    private var itemObservation: NSKeyValueObservation?
    private var playWhenReady = false
    private(set) var currentTime: TimeInterval = 0 {
        didSet {
            delegate?.audioPlayer(self, didChangeCurrentTime: currentTime)
        }
    }

    private(set) var duration: TimeInterval = 0 {
        didSet {
            delegate?.audioPlayer(self, didChangeDuration: duration)
        }
    }

    private(set) var state: AudioPlayerState = .idle {
        didSet {
            delegate?.audioPlayer(self, didChangeState: state)
        }
    }

    var isPlaying: Bool {
        if case .playing = state {
            return true
        }
        return false
    }

    init() {
        setupAudioSession()
    }

    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .spokenAudio)
            try audioSession.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
            state = .error(error)
        }
    }

    func load(url: URL, playWhenReady: Bool = false) {
        clean()
        state = .loading
        self.playWhenReady = playWhenReady
        let playerItem = AVPlayerItem(url: url)

        itemObservation = playerItem.observe(\.status, options: [.new]) { [weak self] item, _ in
            DispatchQueue.main.async {
                switch item.status {
                case .readyToPlay:
                    self?.state = .stopped
                    let seconds = CMTimeGetSeconds(item.duration)
                    self?.duration = seconds.isFinite ? seconds : 0
                    if self?.playWhenReady == true {
                        self?.play()
                        self?.playWhenReady = false
                    }
                case .failed:
                    let error = item.error ?? URLError(.unknown)
                    self?.state = .error(error)
                    print("Player item failed: \(error)")
                default:
                    break
                }
            }
        }
        let avPlayer = AVPlayer(playerItem: playerItem)
        timeObserver = avPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 600), queue: .main) { [weak self] time in
            let seconds = CMTimeGetSeconds(time)
            self?.currentTime = seconds.isFinite ? seconds : 0
        }
        player = avPlayer
    }

    func play() {
        guard let player = player else { return }
        player.play()
        state = .playing
    }

    func stop() {
        guard let player = player else { return }
        player.pause()
        player.seek(to: CMTime.zero)
        state = .stopped
    }

    func pause() {
        guard let player = player else { return }
        player.pause()
        state = .paused
    }

    func clean() {
        if let player = player {
            player.pause()
            if let timeObserver = timeObserver {
                player.removeTimeObserver(timeObserver)
                self.timeObserver = nil
            }
        }
        itemObservation?.invalidate()
        itemObservation = nil
        duration = 0
        playWhenReady = false
        player = nil
        state = .idle
    }
}
