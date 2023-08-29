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
    
    @IBOutlet weak var widthContraintProcessingBar: NSLayoutConstraint!
    weak var delegate:MusicBarViewDelegate?
    var durationMs: Int = 1 // số giây của bài hát
    var timer: Timer?
    var isTogglePlaying = false
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
        stopMusic()
    }
    
    @IBAction func actionPlay(_ sender: Any) {
        isTogglePlaying.toggle()
        if isTogglePlaying {
            btnPlay.setImage(UIImage(named: "ic_playing"), for: .normal)
        } else {
            btnPlay.setImage(UIImage(named: "ic_pause"), for: .normal)
        }
        
        if let delegate = self.delegate {
            delegate.didSelectedPlay()
        }
        stopMusic()
    }
    
    @IBAction func actionNext(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.didSelectedPrevious()
        }
        stopMusic()
    }
    
    func stopMusic() {
        timer?.invalidate()
        timer = nil
        self.widthContraintProcessingBar.constant = 0
    }
    
    func playMusic(with durationMs: Int) {
        self.durationMs = durationMs
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(animationProgressBar), userInfo: nil, repeats: true)
    }
    
    @objc func animationProgressBar() {
        
        let width = Int(self.frame.width)
        let offset = width/durationMs
        if self.widthContraintProcessingBar.constant > self.frame.width {return}
        self.widthContraintProcessingBar.constant += CGFloat(offset)
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
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
