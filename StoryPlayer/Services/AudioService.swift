//
//  AudioService.swift
//  StoryPlayer
//
//  Created by Adam Regan on 16/02/2026.
//

import AVFoundation
import Foundation

class AudioService {
    func getAudio(from fileName: String) throws -> AVAudioFile {
        let url = Bundle.main.url(forResource: fileName, withExtension: "mp3")!
        return try AVAudioFile(forReading: url)
    }
}
