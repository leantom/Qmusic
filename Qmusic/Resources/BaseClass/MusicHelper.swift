//
//  MusicHelper.swift
//  Qmusic
//
//  Created by QuangHo on 18/08/2023.
//

import Foundation
import AVFAudio
import AVFoundation
import UIKit

enum MusicStatusPlay {
    case None
    case Playing
    case Pause
    case Finished
}

class MusicHelper {
    static let sharedHelper = MusicHelper()
    var audioPlayer: AVPlayer?
    var isFinished = false
    private var status:  MusicStatusPlay = .None
    
    func playBackgroundMusic() {
        status = .Playing
        audioPlayer?.play()
    }
    
    func stopPlayBackground()  {
        status = .Pause
        audioPlayer?.pause()
    }
    
    func setFinishedPlaying() {
        status = .Finished
        audioPlayer?.seek(to: CMTime.zero)
    }
    
    func checkPlayingMusic() {
        
    }
    
    func playMusicWithURL(link: String,
                          on view: UIView ) {
        if let url = URL(string: link) {
            let playerItem: AVPlayerItem = AVPlayerItem(url: url)
            audioPlayer = AVPlayer(playerItem: playerItem)
            
            let playerLayer = AVPlayerLayer(player: audioPlayer!)
            playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
            view.layer.addSublayer(playerLayer)
            audioPlayer?.play()
           
            UIView.animate(withDuration: 0.3) {
                view.layoutIfNeeded()
            }
            
        }
    }
    
}
