//
//  RadioWeeklyCollectionViewCell.swift
//  Qmusic
//
//  Created by QuangHo on 16/08/2023.
//

import UIKit

class RadioWeeklyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBG: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func populate(item: Item) {
        self.lblTitle.text = item.nameSong
        self.imgBG.setImageWithAnimation(image: UIImage(named: item.imgAlbumsBG))
    }
}
