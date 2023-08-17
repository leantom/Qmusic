//
//  RecentlyMusicTableViewCell.swift
//  Qmusic
//
//  Created by QuangHo on 15/08/2023.
//

import UIKit
protocol RecentlyMusicTableViewCellDelegate: AnyObject {
    func didSelectShowDetail(cell: RecentlyMusicTableViewCell)
}
class RecentlyMusicTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imgAlbums: UIImageView!
    
    @IBOutlet weak var lblNameSong: UILabel!
    
    @IBOutlet weak var lblArtist: UILabel!
    
    weak var delegate: RecentlyMusicTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func actionShowDetail(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.didSelectShowDetail(cell: self)
        }
    }
    
    func popuplate(item: Item) {
        lblTitle.text = item.artist
        lblNameSong.text = item.nameSong
        self.imgAlbums.image = UIImage(named: item.imgAlbums)
        self.lblTitle.text = item.value
    }
    
}
