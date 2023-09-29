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
    var data: Trending_TrackItems?
    
    func setupData(_ data: Trending_TrackItems, index: Int){
        self.data = data
        self.index = index
        self.lblTitle.text = data.name
        self.lblDesc.text = data.artists?.first?.name
        if let url = URL(string: data.imageSong ?? "") {
            self.imgMain.setImage(from: url)
        }
//        let image = data.isLike ? "ic_explore_heart_red" : "ic_explore_heart_white"
//        self.btnLike.setImage(UIImage(named: image), for: .normal)
    }
    

    @IBAction func actionLike(_ sender: Any) {
//        let originalTransform = btnLike.transform
//        let isLike = self.data?.isLike ?? false
//        self.data?.isLike = !isLike
        
//        guard let data = self.data else {return}
//        let image = data.isLike ? "ic_explore_heart_red" : "ic_explore_heart_white"
//        UIView.animate(withDuration: 0.15) {
//            self.btnLike.transform = originalTransform.scaledBy(x: 1.3, y: 1.3)
//            self.btnLike.setImage(UIImage(named: image), for: .normal)
//        } completion: { _ in
//            self.ontapLikeTrending?(self.index)
//            UIView.animate(withDuration: 0.15) {
//                self.btnLike.transform = originalTransform
//            }
//        }
    }
}
