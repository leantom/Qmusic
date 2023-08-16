//
//  ExploreTopTrendingTableViewCell.swift
//  Qmusic
//
//  Created by Macbook on 8/16/23.
//

import UIKit

struct FakeExploreTopTrendingData{
    var title: String
    var des: String
    var image: String
    var isLike: String
}

class ExploreTopTrendingTableViewCell: UITableViewCell {

    
    let listImage = ["splash_1", "splash_2", "splash_3", "splash_4", "splash_5", "splash_6"]
    let titles = ["Your Melody, Your Mood",
                  "Your Groove, Your Rules",
                  "Drown in Sound, Elevate Your Soul",
                  "Every Note, Every Emotion",
                  "Harmonize Your Day with Cyme",
                  "Discover, Stream, Repeat"
    ]
    
    let contents = ["Cyme Delivers the Soundtrack to Your Life",
                    "Cyme Customizes Your Music Experience.",
                    "Cyme Takes You on a Musical Journey.",
                    "Cyme Connects You to the Power of Music.",
                    "Where Rhythm Meets Routine.",
                    "Cyme Unlocks a World of Musical Exploration."
]
    
    @IBOutlet weak var clView: UICollectionView!
    @IBOutlet weak var vPageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vPageControl.numberOfPages = titles.count
        self.clView.delegate = self
        self.clView.dataSource = self
    }
    
}

extension ExploreTopTrendingTableViewCell: UICollectionViewDataSource,
                                        UICollectionViewDelegate,
                                        UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(UIScreen.main.bounds.width, self.clView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SplashScreenCellCollectionViewCell else {return UICollectionViewCell()}
        cell.imgCell.image = UIImage(named: listImage[indexPath.row])
//        if let image = cell.imgCell.image {
//            let primaryColor = image.getPrimaryColor()
//            cell.primaryColor = primaryColor
//            collectionView.backgroundColor = primaryColor
//
//        }
        return cell
    }
    
    // MARK: --scrollViewDidScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        if let indexPath = clView.indexPathForItem(at: scrollView.contentOffset),
           let cell = clView.cellForItem(at: indexPath) {
            vPageControl.currentPage = indexPath.row
            
        }
    }
    
    
}
