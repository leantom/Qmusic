//
//  SongDetailViewController+PlayMusicTimer.swift
//  Qmusic
//
//  Created by Macbook on 9/11/23.
//

import Foundation
import UIKit

extension SongDetailViewController {
    
    func playMusic() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(animationProgressBar), userInfo: nil, repeats: true)
    }

    @objc func animationProgressBar() {
        UIView.animate(withDuration: 1) {
            self.imgSong.transform = self.imgSong.transform.rotated(by: .pi / 18) // xoay 10 độ
        }
        self.duration += 1
        if !self.isScrollSlider{
            self.updateUIWhenTimeChange()
        }
    }
    
    func stopTimer(){
        self.timer?.invalidate()
        self.timer = nil
        self.duration = 0
    }
    
    func pausingMusic(){
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func playingMusic(){
        self.timer?.invalidate()
        self.timer = nil
        self.playMusic()
    }
}
