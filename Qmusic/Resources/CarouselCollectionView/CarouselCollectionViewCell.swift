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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func populate(item: HomePage.Items) {
        
        if let urlImage = item.images?.first?.first,
           let url = URL(string: urlImage.url ?? "") {
            self.imgAlbum.setImage(from: url)
        }
    }

}
