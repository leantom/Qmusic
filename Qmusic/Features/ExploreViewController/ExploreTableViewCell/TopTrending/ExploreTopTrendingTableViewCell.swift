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
    
    @IBOutlet weak var collectionLayout: WLCollectionViewLayout!
    var data: Trending_DataResult?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//
        self.vPageControl.numberOfPages = 3
        self.clView.delegate = self
        self.clView.dataSource = self
        clView.register(UINib(nibName: "ExploreTopTrendingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ExploreTopTrendingCollectionViewCell")
        
        
    }
    
    func setDataChart(_ data: Trending_DataResult){
        self.data = data
        self.clView.reloadData()
        self.vPageControl.numberOfPages = self.data?.tracks?.items?.count ?? 0
        
        collectionLayout.itemSize = CGSize(width: self.clView.frame.width - 40, height: self.clView.frame.height)
        collectionLayout.minimumLineSpacing = 20
    }
    
}

extension ExploreTopTrendingTableViewCell: UICollectionViewDataSource,
                                           UICollectionViewDelegate,
                                           UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = self.data,
           let tracks = data.tracks,
           let items = tracks.items {
            return items.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.clView.frame.width - 40, height: self.clView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreTopTrendingCollectionViewCell", for: indexPath) as? ExploreTopTrendingCollectionViewCell else {return UICollectionViewCell()}
        if let data = self.data, let tracks = data.tracks, let items = tracks.items {
            let item = items[indexPath.row]
            cell.setupData(item, index: indexPath.row)
            cell.ontapLikeTrending = { index in
    //            self.data[index].isLike = !self.dataCollection[index].isLike
            }
        }
        return cell
    }
    
    // MARK: --scrollViewDidScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let indexPath = clView.indexPathForItem(at: scrollView.contentOffset),
           let cell = clView.cellForItem(at: indexPath) {
            vPageControl.currentPage = indexPath.row
        }
    }
    
    
    
    
    
}
