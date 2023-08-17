//
//  MusicBarView.swift
//  Qmusic
//
//  Created by QuangHo on 16/08/2023.
//

import UIKit

class MusicBarView: UIView {
    @IBOutlet weak var imgAlbums: UIImageView!
    
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lblNameSong: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    */
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    @IBAction func actionPrevious(_ sender: Any) {
    }
    
    @IBAction func actionPlay(_ sender: Any) {
    }
    @IBAction func actionNext(_ sender: Any) {
    }
    
    
    func populate(item: Item) {
        lblNameSong.text = item.nameSong
        if let image = UIImage(named: item.imgAlbumsBG),
           let imageCircle = image.maskRoundedImage(radius: imgAlbums.frame.width/2) {
            imgAlbums.setImageWithAnimation(image: imageCircle)
        }
        
        
    }
}
