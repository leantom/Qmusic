//
//  HomeAlbumsTableViewCell.swift
//  Qmusic
//
//  Created by QuangHo on 15/08/2023.
//

import UIKit
import AVFoundation

class HomeAlbumsTableViewCell: UITableViewCell {
    var player: AVPlayer?
  
    var parentVC: HomeViewController?
    
    @IBOutlet weak var clContent: UICollectionView!
   
    var playlists: [HomePage.Items] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clContent.delegate = self
        clContent.dataSource = self
        
        
        clContent.register(UINib(nibName: "SubHomeAlbumsTableViewCell", bundle: nil), forCellWithReuseIdentifier: "SubHomeAlbumsTableViewCell")
    }

    func setupData(items: HomePage.Genres) {
        if let first = items.contents?.items {
            self.playlists.append(contentsOf: first)
        }
        clContent.reloadData()
    }

    // MARK: - Remove Observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func actionPlay(_ sender: Any) {
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension HomeAlbumsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubHomeAlbumsTableViewCell", for: indexPath) as! SubHomeAlbumsTableViewCell
        cell.delegate = self
        cell.setupData(item: playlists[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width , collectionView.frame.height)
    }
    
}
extension HomeAlbumsTableViewCell: SubHomeAlbumsTableViewCellDelegate {
    func didSelectedChart(item: HomePage.Items) {
        if let vc = self.parentVC {
            vc.homePageModel.setPlaylistSeleted(item: item)
            vc.homePageModel.getPlaylistDetail(id: item.id ?? "")
            
        }
    }
    
    
}
