//
//  HomeAlbumsTableViewCell.swift
//  Qmusic
//
//  Created by QuangHo on 15/08/2023.
//

import UIKit
import AVFoundation

class HomeAlbumsTableViewCell: UITableViewCell {
    var player: AVPlayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let url = URL(string: "https://scd.dlod.link/?expire=1692113736456&p=Y9DkemAkYmM_73_lFw-Rkfu4Pq7ZzpJepfZKpfkeZq55kvpmkclFNAS5g1LVT85Ga5NJwAJ0nkb9Y_-ilUOZX0iiC7tX5aSjHFsHbrtAgZOIdHeiu712q7rRd0b9NfAEJxjE3CHbJTXxL9psIPJHe37d2wy7Sl_C19DjEjKYsNlQjd34NaEr3c_L2CJ7LWQx&s=fHnv9_Cn3LJV6lfrceUxXLyBqh1HNk2NkcroB6WRRDo") {
            let playerItem: AVPlayerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
            let playerLayer = AVPlayerLayer(player: player!)

            playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
            self.layer.addSublayer(playerLayer)
            
        }
        
    }

    @IBAction func actionPlay(_ sender: Any) {
        let btn = sender as! UIButton
        if player.timeControlStatus == .paused {
            player.play()
            btn.setImage(UIImage(systemName: "pause.circle"), for: .normal)
        } else {
            player.pause()
            btn.setImage(UIImage(systemName: "play.circle"), for: .normal)
        }
        
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
