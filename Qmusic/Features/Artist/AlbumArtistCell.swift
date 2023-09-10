//
//  AlbumArtistCell.swift
//  Qmusic
//
//  Created by QuangHo on 05/09/2023.
//

import UIKit

class AlbumArtistCell: UITableViewCell {
    @IBOutlet weak var clContent: UICollectionView!
    var albums : [ArtistModel.Items]?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clContent.delegate = self
        clContent.dataSource = self
        
        clContent.register(UINib(nibName: "SubAlbumArtistViewCell", bundle: nil), forCellWithReuseIdentifier: "SubAlbumArtistViewCell")
    }

    func setupUI() {
        clContent.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension AlbumArtistCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let albums = self.albums {
            return albums.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubAlbumArtistViewCell", for: indexPath) as! SubAlbumArtistViewCell
        if let albums = self.albums {
            let album = albums[indexPath.row]
            cell.lblName.text = album.name
            if let url = URL(string: album.cover?.last?.url ?? "") {
                cell.imgBg.setImage(from: url)
            }
           
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake((collectionView.frame.width - 20) / 3 , collectionView.frame.height)
    }
    
}
