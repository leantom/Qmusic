//
//  SplashScreenCellCollectionViewCell.swift
//  Qmusic
//
//  Created by QuangHo on 13/08/2023.
//

import UIKit

class SplashScreenCellCollectionViewCell: UICollectionViewCell {
    var primaryColor: UIColor?
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imgCell: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setPrimaryColor(color: UIColor?) {
        self.primaryColor = color
    }

}
