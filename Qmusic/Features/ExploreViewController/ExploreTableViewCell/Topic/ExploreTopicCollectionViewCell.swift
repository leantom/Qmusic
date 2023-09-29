//
//  ExploreTopicCollectionViewCell.swift
//  Qmusic
//
//  Created by Macbook on 8/21/23.
//

import UIKit

class ExploreTopicCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgTopic: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupData(_ data: HotTopic){
        self.lblTitle.text = data.name
        self.imgTopic.image = UIImage(named: data.image)
    }

}
