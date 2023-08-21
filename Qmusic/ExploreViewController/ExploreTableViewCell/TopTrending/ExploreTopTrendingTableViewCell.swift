//
//  ExploreTopTrendingTableViewCell.swift
//  Qmusic
//
//  Created by Macbook on 8/16/23.
//

import UIKit

class ExploreTopTrendingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var clView: UICollectionView!
    @IBOutlet weak var vPageControl: UIPageControl!
    
    var dataCollection = [FakeExploreTopTrendingData(title: "Do it", des: "What the fuck are u doing", image: "splash_1", isLike: false),
                          FakeExploreTopTrendingData(title: "Do it", des: "What the fuck are u doing", image: "splash_2", isLike: false),
                          FakeExploreTopTrendingData(title: "Do it", des: "What the fuck are u doing", image: "splash_3", isLike: false),
                          FakeExploreTopTrendingData(title: "Do it", des: "What the fuck are u doing", image: "splash_4", isLike: false)]
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vPageControl.numberOfPages = dataCollection.count
        self.clView.delegate = self
        self.clView.dataSource = self
        clView.register(UINib(nibName: "ExploreTopTrendingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ExploreTopTrendingCollectionViewCell")
    }
    
}

extension ExploreTopTrendingTableViewCell: UICollectionViewDataSource,
                                        UICollectionViewDelegate,
                                        UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.clView.frame.width, height: self.clView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreTopTrendingCollectionViewCell", for: indexPath) as? ExploreTopTrendingCollectionViewCell else {return UICollectionViewCell()}
        let data = self.dataCollection[indexPath.row]
        cell.setupData(data)
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
