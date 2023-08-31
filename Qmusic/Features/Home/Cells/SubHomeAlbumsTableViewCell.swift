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

  
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var imgCover: UIImageView!
    
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
   
}
