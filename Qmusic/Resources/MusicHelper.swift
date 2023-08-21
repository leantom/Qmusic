//
//  MusicHelper.swift
//  Qmusic
//
//  Created by QuangHo on 18/08/2023.
//

import Foundation
import AVFAudio
import AVFoundation

class MusicHelper {
    static let sharedHelper = MusicHelper()
    var audioPlayer: AVPlayer?
    
    func playBackgroundMusic() {
        audioPlayer?.play()
    }
    
    func stopPlayBackground()  {
        audioPlayer?.pause()
    }
}
