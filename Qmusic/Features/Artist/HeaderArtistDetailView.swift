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
    
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnPlaying: UIButton!
    weak var delegate: HeaderArtistDetailViewDelegate?
    var isTouchPlay : Bool = false
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    func setupData(item: HomePage.Items) {
        lblTitle.text = item.name
        lblSubDesc.text = item.description
        lblDesc.text = "\(item.trackCount ?? 0) tracks"
    }
    
    func setupData(album: AlbumMetadata) {
        lblTitle.text = album.name
        lblSubDesc.text = album.artists?.first?.name
        lblDesc.text = "\(album.trackCount ?? 0) tracks"
    }
    
    
    func setPlaying() {
        btnPlaying.setImage(UIImage(named: "ic_pause"), for: .normal)
    }
    
    func setPause() {
        btnPlaying.setImage(UIImage(named: "ic_playing"), for: .normal)
    }
    
    @IBAction func actionShufle(_ sender: Any) {
       
    }
    
    @IBAction func actionSkipPre(_ sender: Any) {
       
    }
    
    @IBAction func actionPauseOrPlaying(_ sender: Any) {
       
        isTouchPlay.toggle()
        if isTouchPlay {
            setPlaying()
        } else {
            setPause()
        }
        
    }
    
    @IBAction func actionSkipNext(_ sender: Any) {
        
    }
    
    @IBAction func actionLoop(_ sender: Any) {
       
    }
}
