//
//  HeaderPlaylistDetailView.swift
//  Qmusic
//
//  Created by QuangHo on 22/08/2023.
//

import UIKit

protocol HeaderArtistDetailViewDelegate: AnyObject {
    func didSelectFollow()
}
    
class HeaderArtistDetailView: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
  
    */
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubDesc: UILabel!
    
    @IBOutlet weak var lblNumberListener: UILabel!
    @IBOutlet weak var lblNumberFollower: UILabel!
    
    @IBOutlet weak var lblNumberAlbum: UILabel!
    weak var delegate: HeaderArtistDetailViewDelegate?
    var isTouchPlay : Bool = false
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    func setupData(item: ArtistDetailModel) {
        lblTitle.text = item.name
        lblSubDesc.text = item.biography
        lblNumberFollower.text = "\(item.stats?.followers ?? 0)"
        lblNumberListener.text = "\(item.stats?.monthlyListeners ?? 0)"
        lblNumberAlbum.text = "\(item.discography?.albums?.totalCount ?? 0)"
    }
    
    
    
}
