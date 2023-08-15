//
//  CarouselCollectionViewCell1.swift
//  Qmusic
//
//  Created by QuangHo on 15/08/2023.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgAlbumBG: UIImageView!
    @IBOutlet weak var imgAlbum: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func populate(item: Item) {
        self.imgAlbum.image = UIImage(named: item.imgAlbumsBG)
        self.imgAlbumBG.image = UIImage(named: item.imgAlbums)
        lblTitle.text = item.value
    }

}
