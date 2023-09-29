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
    var data: [TopTracks]? {
        didSet {
            clView.reloadData()
            setupPageControler()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vPageControl.numberOfPages = data?.count ?? 0
        self.clView.delegate = self
        self.clView.dataSource = self
        clView.register(UINib(nibName: "ExploreTopTrendingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ExploreTopTrendingCollectionViewCell")
    }
    
    func setupPageControler() {
        vPageControl.numberOfPages = data?.count ?? 0
    }
    
}

extension ExploreTopTrendingTableViewCell: UICollectionViewDataSource,
                                        UICollectionViewDelegate,
                                        UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = self.data {
            return data.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.clView.frame.width - 40, height: self.clView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreTopTrendingCollectionViewCell", for: indexPath) as? ExploreTopTrendingCollectionViewCell else {return UICollectionViewCell()}
        
        if let data = self.data {
            cell.setupData(data[indexPath.row], index: indexPath.row)
        }
        
        cell.ontapLikeTrending = { index in
           
        }
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
