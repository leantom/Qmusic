//
//  SubHomeAlbumsTableViewCell.swift
//  Qmusic
//
//  Created by QuangHo on 30/08/2023.
//

import UIKit
protocol SubHomeAlbumsTableViewCellDelegate: AnyObject {
    func didSelectedChart(item: HomePage.Items)
}

class SubHomeAlbumsTableViewCell: UICollectionViewCell {

    @IBOutlet weak var lblTimeStart: UILabel!
    
    @IBOutlet weak var lblTImeEnd: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var viewPlayer: UIView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var widthContraintProgressBar: NSLayoutConstraint!
    weak var delegate: SubHomeAlbumsTableViewCellDelegate?
    
    var timer: Timer?
    var countdown = 0
    var item: HomePage.Items?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupData(item: HomePage.Items) {
        self.item = item
        
        self.lblTitle.text = item.name
        self.lblDesc.text = item.description
        if let url = item.images?.last?.last?.url,
        let _url = URL(string: url){
            imgCover.setImage(from: _url)
        }
           
    }
    
    @IBAction func actionGoPlaylist(_ sender: Any) {
        if let delegate = self.delegate,
           let item = self.item {
            delegate.didSelectedChart(item: item)
        }
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
    
}
