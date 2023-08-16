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
        return CGSizeMake(UIScreen.main.bounds.width, self.clContent.frame.height)
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
        if let indexPath = clContent.indexPathForItem(at: scrollView.contentOffset),
           let cell = clContent.cellForItem(at: indexPath) {
            pageControl.currentPage = indexPath.row
            lblTitle.text = titles[indexPath.row]
            lblDesc.text = contents[indexPath.row]
        }
    }
    
    
}
