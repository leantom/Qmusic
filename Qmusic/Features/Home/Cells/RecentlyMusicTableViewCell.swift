//
//  RecentlyMusicTableViewCell.swift
//  Qmusic
//
//  Created by QuangHo on 15/08/2023.
//

import UIKit
import Lottie

protocol RecentlyMusicTableViewCellDelegate: AnyObject {
    func didSelectShowDetail(cell: RecentlyMusicTableViewCell)
}
class RecentlyMusicTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imgAlbums: UIImageView!
    
    @IBOutlet weak var lblNameSong: UILabel!
    
    @IBOutlet weak var lblArtist: UILabel!
    
    weak var delegate: RecentlyMusicTableViewCellDelegate?
    
    @IBOutlet weak var heightContraintSpectrum: NSLayoutConstraint!
    @IBOutlet weak var viewSpectrum: UIView!
    
    var animationView:LottieAnimationView?
    
    var songInPlaylist:PlaylistModel.ItemsPlaylist?
    var playlistInHome:HomePage.Items?
    var album: AlbumDetailResp.Items?
    var songSelectedInChart:TopTracks?
    
    @IBOutlet weak var widthContraintImg: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if animationView == nil {
            let animationV = createViewLotties(frame: viewSpectrum.bounds, name: "spectrum") 
            animationView = animationV
            self.viewSpectrum.addSubview(animationView!)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func animateSpectrum(selected: Bool) {
        if selected {
            animationView?.isHidden = false
            animationView?.play()
            heightContraintSpectrum.constant = 17
        } else {
            animationView?.isHidden = true
            animationView?.stop()
            heightContraintSpectrum.constant = 0
        }
    }
    
    @IBAction func actionShowDetail(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.didSelectShowDetail(cell: self)
        }
    }
    
    func popuplate(item: HomePage.Items, index: Int) {
        playlistInHome = item
        lblArtist.text = item.name
        lblNameSong.text = item.description
        if let urlImage = item.images?.first?.first,
           let url = URL(string: urlImage.url ?? "") {
            self.imgAlbums.setImage(from: url) { result in
                self.imgAlbums.image = result
            }
            
        }
        lblTitle.text = "\(index + 1)"
    }
    
    func popuplate(item: AlbumDetailResp.Items, index: Int) {
        self.album = item
        lblArtist.text = item.name
        lblNameSong.text = item.artists?.first?.name
        widthContraintImg.constant = 0
        lblTitle.text = "\(index + 1)"
    }
    
    func popuplate(with item: TopTracks, index: Int) {
        songSelectedInChart = item
        lblArtist.text = item.name
        lblNameSong.text = item.artists?.first?.name
        if let urlImage = item.imageSong,
           let url = URL(string: urlImage) {
            self.imgAlbums.setImage(from: url) { result in
                self.imgAlbums.image = result
            }
        }
        lblTitle.text = "\(index + 1)"
    }
    
    func popuplate(item: PlaylistModel.ItemsPlaylist, index: Int) {
        self.songInPlaylist = item
        self.backgroundColor = .clear
        lblArtist.text = item.artists?.first?.name
        lblNameSong.text = item.name
        if let urlImage = item.album?.cover?.first?.url,
           let url = URL(string: urlImage) {
            self.imgAlbums.setImage(from: url) { result in
                self.imgAlbums.image = result
            }
        }
        lblTitle.text = "\(index + 1)"
    }
    
    
}
