//
//  ExploreTopTrendingCollectionViewCell.swift
//  Qmusic
//
//  Created by Macbook on 8/21/23.
//

import UIKit

struct FakeExploreTopTrendingData{
    var title: String
    var des: String
    var image: String
    var isLike: Bool
}

class ExploreTopTrendingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var imgMain: UIImageView!
    
    var index = 0
    var ontapLikeTrending: ((_ index: Int)-> Void)?
    var data: FakeExploreTopTrendingData?
    
    func setupData(_ data: FakeExploreTopTrendingData, index: Int){
        self.data = data
        self.index = index
        self.lblTitle.text = data.title
        self.lblDesc.text = data.des
        self.imgMain.image = UIImage(named: data.image)
//        self.imgStatus.image =
    }

    @IBAction func actionLike(_ sender: Any) {
        guard let data = self.data else {return}
        let image = data.isLike ? "" : ""
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowAnimatedContent) {
            self.btnLike.setImage(UIImage(named: image), for: .normal)
        } completion: { _ in
            self.ontapLikeTrending?(self.index)
        }
    }
}
