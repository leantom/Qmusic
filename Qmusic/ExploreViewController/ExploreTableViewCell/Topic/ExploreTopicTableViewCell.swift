//
//  ExploreTopicTableViewCell.swift
//  Qmusic
//
//  Created by Macbook on 8/21/23.
//

import UIKit

struct FakeDataTopic{
    var name: String
    var image: String
}

class ExploreTopicTableViewCell: UITableViewCell {

    @IBOutlet weak var clView: UICollectionView!
    
    var data: [FakeDataTopic] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCollectionView()
    }

    func setupCollectionView(){
        self.clView.delegate = self
        self.clView.dataSource = self
        clView.register(UINib(nibName: "ExploreTopicCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ExploreTopicCollectionViewCell")
    }
    
    func setDataTopic(_ data: [FakeDataTopic]){
        self.data = data
        self.clView.reloadData()
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
