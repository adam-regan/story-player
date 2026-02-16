//
//  AudioPlayer.swift
//  StoryPlayer
//
//  Created by Adam Regan on 16/02/2026.
//

import AVFoundation
import Foundation

enum AudioPlayerState {
    case idle
    case loading
    case playing
    case paused
    case stopped
    case error(Error)
}

protocol AudioPlayerDelegate: AnyObject {
    func audioPlayer(_ player: AudioPlayer, didChangeState state: AudioPlayerState)
}

class AudioPlayer: ObservableObject {
    weak var delegate: AudioPlayerDelegate?
    private var player: AVPlayer?
    private var itemObservation: NSKeyValueObservation?
    private var playWhenReady = false
    private(set) var state: AudioPlayerState = .idle {
        didSet {
            delegate?.audioPlayer(self, didChangeState: state)
        }
    }

    var currentTime: TimeInterval {
        guard let player = player else { return 0 }
        return CMTimeGetSeconds(player.currentTime())
    }

    var duration: TimeInterval {
        guard let player = player,
              let duration = player.currentItem?.duration else { return 0 }
        return CMTimeGetSeconds(duration)
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
        player = AVPlayer(playerItem: playerItem)
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
        }
        itemObservation?.invalidate()
        itemObservation = nil
        playWhenReady = false
        player = nil
        state = .idle
    }
}
