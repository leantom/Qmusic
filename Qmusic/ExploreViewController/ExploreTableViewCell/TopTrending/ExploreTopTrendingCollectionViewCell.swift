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
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var imgMain: UIImageView!
    
    func setupData(_ data: FakeExploreTopTrendingData){
        self.lblTitle.text = data.title
        self.lblDesc.text = data.des
        self.imgMain.image = UIImage(named: data.image)
//        self.imgStatus.image =
    }

}
