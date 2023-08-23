//
//  MusicBarView.swift
//  Qmusic
//
//  Created by QuangHo on 16/08/2023.
//

import UIKit

protocol MusicBarViewDelegate: AnyObject {
    func didSelectedPrevious()
    func didSelectedPlay()
    func didSelectedNext()
}

class MusicBarView: UIView {
    @IBOutlet weak var imgAlbums: UIImageView!
    
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lblNameSong: UILabel!
    
    weak var delegate:MusicBarViewDelegate?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    */
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    @IBAction func actionPrevious(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.didSelectedPrevious()
        }
    }
    
    @IBAction func actionPlay(_ sender: Any) {
        btnPlay.setImage(UIImage(named: "ic_playing_black"), for: .normal)
        if let delegate = self.delegate {
            delegate.didSelectedPlay()
        }
    }
    
    @IBAction func actionNext(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.didSelectedPrevious()
        }
    }
    
    
    
    func playMusic() {
        
    }
    
    func populate(item: Item) {
        lblNameSong.text = item.nameSong
        if let image = UIImage(named: item.imgAlbumsBG),
           let imageCircle = image.maskRoundedImage(radius: imgAlbums.frame.width/2) {
            imgAlbums.setImageWithAnimation(image: imageCircle)
        }
    }
    
    func populate(nameSong: String, urlImage: String) {
        lblNameSong.text = nameSong
        if let url = URL(string: urlImage) {
            imgAlbums.setImage(from: url)
        }
        
    }
    
}
