//
//  HomeAlbumsTableViewCell.swift
//  Qmusic
//
//  Created by QuangHo on 15/08/2023.
//

import UIKit
import AVFoundation

class HomeAlbumsTableViewCell: UITableViewCell {
    var player: AVPlayer?
    @IBOutlet weak var lblTimeStart: UILabel!
    
    @IBOutlet weak var lblTImeEnd: UILabel!
    
    @IBOutlet weak var viewPlayer: UIView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var widthContraintProgressBar: NSLayoutConstraint!
    var timer: Timer?
    var countdown = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let url = URL(string: Constants.urlAudio) {
            let playerItem: AVPlayerItem = AVPlayerItem(url: url)
            
            player = AVPlayer(playerItem: playerItem)
            MusicHelper.sharedHelper.audioPlayer = player
            let playerLayer = AVPlayerLayer(player: player!)
            widthContraintProgressBar.constant = 0
            playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
            self.layer.addSublayer(playerLayer)
            
            NotificationCenter.default
                .addObserver(self,
                selector: #selector(playerDidFinishPlaying),
                name: .AVPlayerItemDidPlayToEndTime,
                object: player?.currentItem
            )
            
        }
        
    }

    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        btnPlay.setImage(UIImage(named: "ic_playing"), for: .normal)
        MusicHelper.sharedHelper.setFinishedPlaying()
    }
    
    // MARK: -- animation for progress bar
    @objc func startCountdown() {
        
        self.countdown += 1
        let offset = viewPlayer.frame.width/172
        widthContraintProgressBar.constant += offset
        if self.countdown > 172 {
            timer?.invalidate()
        }
        lblTimeStart.text = TimeInterval(countdown).showFormatTimerCoundown()
    }
    
    // MARK: - Remove Observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func actionPlay(_ sender: Any) {
        let btn = sender as! UIButton
        if player?.timeControlStatus == .paused {
            player?.play()
            btn.setImage(UIImage(named: "ic_pause"), for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.startCountdown), userInfo: nil, repeats: true)
            }
            
        } else {
            player?.pause()
            timer?.invalidate()
            btn.setImage(UIImage(named: "ic_playing"), for: .normal)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
