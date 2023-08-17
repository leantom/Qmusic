//
//  RadioWeeklyTableViewCell.swift
//  Qmusic
//
//  Created by QuangHo on 16/08/2023.
//

import UIKit

class RadioWeeklyTableViewCell: UITableViewCell {

    @IBOutlet weak var clContent: UICollectionView!
    var items: [Item] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        clContent.register(UINib(nibName: "RadioWeeklyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RadioWeeklyCollectionViewCell")
        clContent.delegate = self
        clContent.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.minimumLineSpacing = 30
        clContent.collectionViewLayout = layout
        clContent.contentOffset = CGPoint(x: 0, y: 0)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension RadioWeeklyTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RadioWeeklyCollectionViewCell", for: indexPath) as! RadioWeeklyCollectionViewCell
        cell.populate(item: items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(UIScreen.main.bounds.width * 2 / 3, collectionView.frame.height)
    }
    
   
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        centerCell()
    }
    
    
    func centerCell () {
        let centerPoint = CGPoint(x: clContent.contentOffset.x + clContent.frame.midX, y: 100)
        if let path = clContent.indexPathForItem(at: centerPoint) {
            clContent.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
        }
    }
    
}
