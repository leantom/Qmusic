//
//  ShareScreenViewController.swift
//  Qmusic
//
//  Created by QuangHo on 02/09/2023.
//

import UIKit

class ShareScreenViewController: UIViewController {

    @IBOutlet weak var lblNameSong: UILabel!
    
    @IBOutlet weak var lblArtist: UILabel!
    
    @IBOutlet weak var imgCover: UIImageView!
    var song: PlaylistModel.ItemsPlaylist?
    
    @IBOutlet weak var bottomContraintMainView: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
        
    }
    @IBAction func actionartist(_ sender: Any) {
        let vc = ArtistViewController.loadFromNib()
        self.navigationController?.push(destinVC: vc)
    }
    
    @IBAction func actionAddplaylist(_ sender: Any) {
        guard let song = self.song else { return
        }
        let vc = UIAlertController(title: "Add Playlist", message: song.name, preferredStyle: .alert)
        vc.addTextField { tf in
            tf.placeholder = "Enter name playlist"
        }
        let OkAction = UIAlertAction(title: "Ok", style: .default) { action in
            // MARK: add playlist
        }
        vc.addAction(OkAction)
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(vc, animated: true)
    }
    @IBAction func actionShareSong(_ sender: Any) {
        guard let image = self.imgCover.image else {return}
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            print("success")
        }
    }
    
    @IBAction func actionReport(_ sender: Any) {
        
    }
    
    @IBAction func actionAlbum(_ sender: Any) {
        guard let song = self.song else {return}
        let vc = AlbumDetailViewController(title: song.album?.name ?? "", id: song.album?.id ?? "")
        self.navigationController?.push(destinVC: vc)
    }
    
    
    func setupUI() {
        if MusicHelper.sharedHelper.isShowing {
            bottomContraintMainView.constant = 74
        }
        
        guard let song = self.song else { return
        }
        
        lblArtist.text = song.artists?.first?.name
        lblNameSong.text = song.name
        
        if let url = URL(string: song.getImageCover()) {
            imgCover.setImage(from: url)
        }
    }
    
    convenience init(song: PlaylistModel.ItemsPlaylist?) {
        self.init(nibName: "ShareScreenViewController", bundle: nil)
        self.song = song
    }

    @IBAction func actionClose(_ sender: Any) {
        self.navigationController?.pop()
    }
}
