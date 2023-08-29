//
//  PlaylistDetailViewController.swift
//  Qmusic
//
//  Created by QuangHo on 22/08/2023.
//

import UIKit
import RxSwift

class PlaylistDetailViewController: UIViewController {

    @IBOutlet weak var tbContent: UITableView!
    // header
    
    // cell
    var homePageViewModel = HomeViewModel()
    
    var playlistDetail: PlaylistDetail?
    var playlist: HomePage.Items?
    
    @IBOutlet weak var lblTitle: UILabel!
    var titleName: String = "Playlist"
    var musicBar: MusicBarView = {
        let v = MusicBarView.instantiate()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    var indexPathSelected: IndexPath?
    var headerView: HeaderPlaylistDetailView?
    
    @IBOutlet weak var imgBg: UIImageView!
    convenience init(playlistDetail: PlaylistDetail, titlePlaylist: String) {
        self.init(nibName: "PlaylistDetailViewController", bundle: nil)
        self.titleName = titlePlaylist
        self.playlistDetail = playlistDetail
    }
    
    convenience init(playlistDetail: PlaylistDetail, playlist: HomePage.Items) {
        self.init(nibName: "PlaylistDetailViewController", bundle: nil)
        self.playlistDetail = playlistDetail
        self.playlist = playlist
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tbContent.register(UINib(nibName: "RecentlyMusicTableViewCell", bundle: nil), forCellReuseIdentifier: "RecentlyMusicTableViewCell")
        
        tbContent.register(UINib(nibName: "HeaderPlaylistDetailView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderPlaylistDetailView")
        tbContent.delegate = self
        tbContent.dataSource = self
        
        setupRx()
        NotificationCenter.default
            .addObserver(self,
            selector: #selector(playerDidFinishPlaying),
                         name: .songplayfinished,
            object: nil
        )
        if let playlist = self.playlist,
           let cover = playlist.images?.first?.first?.url ,
           let url = URL(string: cover) {
            imgBg.setImage(from: url)
            lblTitle.text = self.playlist?.name
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        //MARK: -- next song
        if let index = self.indexPathSelected {
            self.indexPathSelected = IndexPath(row: index.row + 1, section: index.section)
        }
        
        if let playlistDetail = self.playlistDetail,
           let items = playlistDetail.contents?.items,
           let indexPath = self.indexPathSelected {
            homePageViewModel.getSongDetail(id: items[indexPath.row].id ?? "")
        }
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.pop()
    }
    

    func setupRx() {
        homePageViewModel.output.songdetail.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                if let url = value.soundcloudTrack?.audio?.first?.url,
                   let detail = self.playlistDetail,
                   let indexPathSelected = self.indexPathSelected {
                    
                
                    
//                    #if DEBUG
//                    let url = "https://cyme-doc.s3.ap-southeast-1.amazonaws.com/mp3/test1_test1.mp3"
//
//                    MusicHelper.sharedHelper.playMusicWithPlaylist(link: url,
//                                                                   on: self.view,
//                                                                   with: indexPathSelected.row,
//                                                                   with: detail)
//                    return
//                    #endif
                    
                    
                    MusicHelper.sharedHelper.playMusicWithPlaylist(link: url,
                                                                   on: self.view,
                                                                   with: indexPathSelected.row,
                                                                   with: detail)
                }
                
            })
            .disposed(by: homePageViewModel.disposeBag)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension PlaylistDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderPlaylistDetailView") as! HeaderPlaylistDetailView
        header.delegate = self
        headerView = header
        if let playlist = self.playlist {
            header.setupData(item: playlist)
        }
        
        return header
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let playlistDetail = self.playlistDetail,
           let items = playlistDetail.contents?.items {
            return items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentlyMusicTableViewCell", for: indexPath) as! RecentlyMusicTableViewCell
        
        if let playlistDetail = self.playlistDetail,
           let items = playlistDetail.contents?.items {
            cell.popuplate(item: items[indexPath.row], index: indexPath.row)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let playlistDetail = self.playlistDetail,
           let items = playlistDetail.contents?.items {
            homePageViewModel.getSongDetail(id: items[indexPath.row].id ?? "")
            indexPathSelected = indexPath
            headerView?.setPlaying()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    
}

extension PlaylistDetailViewController: HeaderPlaylistDetailViewDelegate {
    func didSelectShufle() {
        
        MusicHelper.sharedHelper.shufflePlaylist()
    }
    
    func didSelectSkipPre() {
        if let index = self.indexPathSelected,
           index.row > 0 {
            self.indexPathSelected = IndexPath(row: index.row - 1, section: index.section)
        }
        
        if let playlistDetail = self.playlistDetail,
           let items = playlistDetail.contents?.items,
           let indexPath = self.indexPathSelected {
            homePageViewModel.getSongDetail(id: items[indexPath.row].id ?? "")
        }
    }
    
    func didSelectPauseOrPlaying() {
        MusicHelper.sharedHelper.didSelectedPlay()
    }
    
    func didSelectSkipNext() {
        
        if let index = self.indexPathSelected {
            self.indexPathSelected = IndexPath(row: index.row + 1, section: index.section)
        }
        
        if let playlistDetail = self.playlistDetail,
           let items = playlistDetail.contents?.items,
           let indexPath = self.indexPathSelected {
            homePageViewModel.getSongDetail(id: items[indexPath.row].id ?? "")
        }
    }
    
    func didSelectLoop() {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var minValue: CGFloat = 0
        var maxValue: CGFloat = 1
        
        let offset = 1 - scrollView.contentOffset.y/400
        lblTitle.alpha = scrollView.contentOffset.y/400
        
        let alphaOffset = min(max(offset, minValue), maxValue)
        headerView?.alpha = alphaOffset
    }
    
    
}
