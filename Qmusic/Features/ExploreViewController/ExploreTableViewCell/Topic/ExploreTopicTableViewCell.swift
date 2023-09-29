//
//  ExploreTopicTableViewCell.swift
//  Qmusic
//
//  Created by Macbook on 8/21/23.
//

import UIKit

class ExploreTopicTableViewCell: UITableViewCell {

    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    @IBOutlet weak var clView: UICollectionView!
    
    var data: [HotTopic] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCollectionView()
    }

    func setupCollectionView(){
        self.clView.delegate = self
        self.clView.dataSource = self
        clView.register(UINib(nibName: "ExploreTopicCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ExploreTopicCollectionViewCell")
    }
    
    func setDataTopic(_ data: [HotTopic]){
        self.data = data
       
        UIView.animate(withDuration: 0.2) {
            let height = self.setHeightConstraint()
            self.constraintHeight.constant = height
        } completion: { _ in
            self.clView.reloadData()
        }
    }
    
    func setHeightConstraint() -> CGFloat{
        let margin = 16
        let widthItem = (self.clView.frame.width - 32) / 3
        let heightItem = widthItem * 61/99
        let _ceil = Int(ceil(Double(self.data.count) / 3.0))
        
        let height = (margin * (_ceil - 1)) + (Int(heightItem) * _ceil)
        return CGFloat(height)
    }
    
}

extension ExploreTopicTableViewCell: UICollectionViewDataSource,
                                        UICollectionViewDelegate,
                                        UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.clView.frame.width - 32) / 3
        let height = width * 61/99
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreTopicCollectionViewCell", for: indexPath) as? ExploreTopicCollectionViewCell else {return UICollectionViewCell()}
        let data = self.data[indexPath.row]
        cell.setupData(data)
        return cell
    }
    
}
