//
//  HeaderPlaylistDetailView.swift
//  Qmusic
//
//  Created by QuangHo on 22/08/2023.
//

import UIKit

protocol HeaderPlaylistDetailViewDelegate: AnyObject {
    func didSelectShufle()
    func didSelectSkipPre()
    func didSelectPauseOrPlaying()
    func didSelectSkipNext()
    func didSelectLoop()
}

class HeaderPlaylistDetailView: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
  
    */
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubDesc: UILabel!
    
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnPlaying: UIButton!
    weak var delegate: HeaderPlaylistDetailViewDelegate?
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    func setupData(item: HomePage.Items) {
        lblTitle.text = item.name
        lblSubDesc.text = item.description
    }
    
    func setPlaying() {
        btnPlaying.setImage(UIImage(named: "ic_pause"), for: .normal)
    }
    
    @IBAction func actionShufle(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.didSelectShufle()
        }
    }
    
    @IBAction func actionSkipPre(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.didSelectSkipPre()
        }
    }
    
    @IBAction func actionPauseOrPlaying(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.didSelectPauseOrPlaying()
        }
        setPlaying()
    }
    
    @IBAction func actionSkipNext(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.didSelectSkipNext()
        }
    }
    
    @IBAction func actionLoop(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.didSelectLoop()
        }
    }
}