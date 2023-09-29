//
//  AlbumDetailViewController.swift
//  Qmusic
//
//  Created by QuangHo on 02/09/2023.
//

import UIKit
import RxSwift

class AlbumDetailViewController: UIViewController {
    
    
    @IBOutlet weak var tbContent: UITableView!
    // header
    
    // cell
    var albumViewModel = AlbumViewModel()
    var homeViewModel = HomeViewModel()
    
    var albumDetail: AlbumDetail?
    var albumMetadata: AlbumMetadata?
    var lyricDetail: [LyricLineModel]?
    
    @IBOutlet weak var lblTitle: UILabel!
    var titleName: String = "Album"
    var idSong: String = ""
    
    var indexPathSelected: IndexPath?
    var headerView: HeaderPlaylistDetailView?
    
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var bottomContraintTableView: NSLayoutConstraint!
    @IBOutlet weak var imgBg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
        // Do any additional setup after loading the view.
    }
    
    convenience init(title: String, id: String) {
        self.init(nibName: "PlaylistDetailViewController", bundle: nil)
        self.titleName = title
        self.idSong = id
    }
    
    func setupUI() {
        if MusicHelper.sharedHelper.isShowing {
            bottomContraintTableView.constant = 48
        }
        tbContent.register(UINib(nibName: "RecentlyMusicTableViewCell", bundle: nil), forCellReuseIdentifier: "RecentlyMusicTableViewCell")
        
        tbContent.register(UINib(nibName: "HeaderPlaylistDetailView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderPlaylistDetailView")
        tbContent.delegate = self
        tbContent.dataSource = self

        
    }
    
    func setupRx() {
        showLoading(on: self.view)
        albumViewModel.getAlbum(by: idSong)
        
        albumViewModel.output.getAlbumMetadata.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.albumMetadata = value
                if let urlStr = value.cover?.last?.url,
                   let url = URL(string: urlStr) {
                    self.imgBg.setImage(from: url)
                }
                self.tbContent.reloadData()
            })
            .disposed(by: self.albumViewModel.disposeBag)
        
        
        albumViewModel.output.getAlbumDetail.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                
                self?.albumDetail = value
                self?.tbContent.reloadData()
                removeLoading(on: self!.view)
            })
            .disposed(by: self.albumViewModel.disposeBag)
        
        homeViewModel.output.songdetail.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                MusicHelper.sharedHelper.playMusicWithURL(link: value.soundcloudTrack?.audio?.first?.url ?? "",
                                                          with: value.spotifyTrack?.name ?? "",
                                                          with: value.spotifyTrack?.artists?.first?.name ?? "")
                removeLoading(on: self.view)
            })
            .disposed(by: homeViewModel.disposeBag)
        
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.pop()
    }
    

}
extension AlbumDetailViewController: UITableViewDelegate, UITableViewDataSource, HeaderPlaylistDetailViewDelegate, RecentlyMusicTableViewCellDelegate {
    func didSelectShowDetail(cell: RecentlyMusicTableViewCell) {
        
    }
    
    func didSelectShufle() {
        
    }
    
    func didSelectSkipPre() {
        
    }
    
    func didSelectPauseOrPlaying() {
        
    }
    
    func didSelectSkipNext() {
        
    }
    
    func didSelectLoop() {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderPlaylistDetailView") as! HeaderPlaylistDetailView
        header.delegate = self
        headerView = header
        if let albumMetadata = self.albumMetadata {
            header.setupData(album: albumMetadata)
        }
        
        return header
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let playlistDetail = self.albumDetail,
           let items = playlistDetail.tracks?.items {
            return items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentlyMusicTableViewCell", for: indexPath) as! RecentlyMusicTableViewCell
        cell.delegate = self
        if let playlistDetail = self.albumDetail,
           let items = playlistDetail.tracks?.items {
            cell.popuplate(item: items[indexPath.row], index: indexPath.row)
        }
        if let index = self.indexPathSelected ,
           index.row == indexPath.row {
            if index.row == indexPath.row {
                cell.animateSpectrum(selected: true)
            } else {
                cell.animateSpectrum(selected: false)
            }
        } else {
            cell.animateSpectrum(selected: false)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.indexPathSelected = indexPath
        if let indexs = tableView.indexPathsForVisibleRows {
            tbContent.reloadRows(at: indexs, with: .automatic)
        }
        
        
        if let albumDetail = self.albumDetail,
           let items = albumDetail.tracks?.items,
           let id = items[indexPath.row].id{
            homeViewModel.getSongDetail(id: id)
            indexPathSelected = indexPath
            headerView?.setPlaying()
            bottomContraintTableView.constant = 48
            tbContent.reloadRows(at: [indexPath], with: .automatic)
            showLoading(on: self.view)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
       
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let minValue: CGFloat = 0
        let maxValue: CGFloat = 1
        
        let offset = 1 - scrollView.contentOffset.y/400
        lblTitle.alpha = scrollView.contentOffset.y/400
        btnLike.alpha = scrollView.contentOffset.y/400
        let alphaOffset = min(max(offset, minValue), maxValue)
        headerView?.alpha = alphaOffset
        
    }
}

