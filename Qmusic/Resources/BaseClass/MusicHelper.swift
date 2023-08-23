//
//  MusicHelper.swift
//  Qmusic
//
//  Created by QuangHo on 18/08/2023.
//

import Foundation
import AVFAudio
import AVFoundation
import UIKit
import RxSwift

enum MusicStatusPlay {
    case None
    case Playing
    case Pause
    case Finished
}

enum MusicTypePlaying {
    case Single
    case Playlist
    case YoutubeLink
    case None
}

class MusicHelper {
    static let sharedHelper = MusicHelper()
    var audioPlayer: AVPlayer?
    var isFinished = false
    private var status:  MusicStatusPlay = .None
    private var type:  MusicTypePlaying = .None
    private var playlist: PlaylistDetail?
    private var index: Int = 0
    var homePageViewModel = HomeViewModel()
    
    var musicBar: MusicBarView = {
        let v = MusicBarView.instantiate()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    init() {
        print("MusicHelper init")
        NotificationCenter.default
            .addObserver(self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: audioPlayer?.currentItem
        )
        
        
        NotificationCenter.default
            .addObserver(self,
            selector: #selector(failedToPlayToEndTime),
            name: .AVPlayerItemFailedToPlayToEndTime,
            object: audioPlayer?.currentItem
        )
        
        NotificationCenter.default
            .addObserver(self,
            selector: #selector(playbackStalled),
            name: .AVPlayerItemPlaybackStalled,
            object: audioPlayer?.currentItem
        )
        
        NotificationCenter.default
            .addObserver(self,
            selector: #selector(newAccessLogEntry),
            name: .AVPlayerItemNewAccessLogEntry,
            object: audioPlayer?.currentItem
        )
        
        NotificationCenter.default
            .addObserver(self,
            selector: #selector(newErrorLogEntry),
            name: .AVPlayerItemNewErrorLogEntry,
            object: audioPlayer?.currentItem
        )
        setupRx()
    }
    
    func setupRx() {
        homePageViewModel.output.songdetail.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                if let url = value.soundcloudTrack?.audio?.first?.url {
                   self.playMusicWithURL(link: url)
                }
            })
            .disposed(by: homePageViewModel.disposeBag)
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        musicBar.btnPlay.setImage(UIImage(named: "ic_playing_black"), for: .normal)
        MusicHelper.sharedHelper.setFinishedPlaying()
        NotificationCenter.default.post(name: .songplayfinished, object: nil)
    }
    
    
    @objc func failedToPlayToEndTime(noti: NSNotification) {
        print(noti)
    }
    
    @objc func playbackStalled(noti: NSNotification) {
        print(noti)
    }
    
    @objc func newAccessLogEntry(noti: NSNotification) {
        print(noti)
    }
    
    @objc func newErrorLogEntry(noti: NSNotification) {
        print(noti)
    }
    
    func shufflePlaylist() {
        if var playlistDetail = self.playlist,
           let items = playlistDetail.contents?.items {
            playlistDetail.contents?.items = items.shuffled()
        }
    }
    
    func nextSongInPlaylist() {
        if let playlistDetail = self.playlist,
           let items = playlistDetail.contents?.items {
            let item = items[index + 1]
            index += 1
            // MARK: -- call api to get song detail
            homePageViewModel.getSongDetail(id: item.id ?? "")
        }
    }
    
    func previousSongInPlaylist() {
        if let playlistDetail = self.playlist,
           let items = playlistDetail.contents?.items {
            let item = items[index - 1]
            index -= 1
            // MARK: -- call api to get song detail
            homePageViewModel.getSongDetail(id: item.id ?? "")
        }
    }
    
    
    
    func playBackgroundMusic() {
        status = .Playing
        audioPlayer?.play()
    }
    
    func stopPlayBackground()  {
        status = .Pause
        audioPlayer?.pause()
    }
    
    func setFinishedPlaying() {
        status = .Finished
        audioPlayer?.seek(to: CMTime.zero)
    }
    
    func checkPlayingMusic() {
        
    }
    
    func playMusicWithPlaylist(link: String,
                               on view: UIView,
                               with index: Int,
                               with playlist: PlaylistDetail) {
        self.type = .Playlist
        showProgressBar()
        self.playlist = playlist
        self.index = index
        if let item = playlist.contents?.items,
           item.count > index {
             musicBar.populate(nameSong: item[index].name ?? "", urlImage: item[index].album?.cover?.first?.url ?? "")
        }
        switch status {
        case .None:
            if let url = URL(string: link) {
                let playerItem: AVPlayerItem = AVPlayerItem(url: url)
                audioPlayer = AVPlayer(playerItem: playerItem)
                
                let playerLayer = AVPlayerLayer(player: audioPlayer!)
                
                playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
                view.layer.addSublayer(playerLayer)
                audioPlayer?.play()
                status = .Playing
                UIView.animate(withDuration: 0.3) {
                    view.layoutIfNeeded()
                }
            }
        case .Playing, .Pause, .Finished:
            if let url = URL(string: link) {
                
                let playerItem: AVPlayerItem = AVPlayerItem(url: url)
                audioPlayer?.replaceCurrentItem(with: playerItem)
                audioPlayer?.play()
                self.status = .Playing
            }
        }
        
    }
    
    func playMusicWithURL(link: String,
                          on view: UIView,
                          with type: MusicTypePlaying) {
        self.type = type
       
        showProgressBar()
        
        switch status {
        case .None:
            if let url = URL(string: link) {
                let playerItem: AVPlayerItem = AVPlayerItem(url: url)
                audioPlayer = AVPlayer(playerItem: playerItem)
                
                let playerLayer = AVPlayerLayer(player: audioPlayer!)
                playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
                view.layer.addSublayer(playerLayer)
                audioPlayer?.play()
                status = .Playing
                UIView.animate(withDuration: 0.3) {
                    view.layoutIfNeeded()
                }
                
            }
        case .Playing, .Pause, .Finished:
            if let url = URL(string: link) {
                let playerItem: AVPlayerItem = AVPlayerItem(url: url)
                audioPlayer = AVPlayer(playerItem: playerItem)
                audioPlayer?.play()
                self.status = .Playing
            }
        }
    }
    // MARK: -- dùng cho auto chuyển bài hát
    func playMusicWithURL(link: String) {
       
        if let url = URL(string: link) {
            let playerItem: AVPlayerItem = AVPlayerItem(url: url)
            audioPlayer?.replaceCurrentItem(with: playerItem)
            audioPlayer?.play()
            self.status = .Playing
        }
    }
    
    
    func showProgressBar() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            
            if let _ = window.viewWithTag(1000) {
                
            } else {
                self.musicBar.tag = 1000
                window.addSubview(self.musicBar)
                NSLayoutConstraint.activate([
                    self.musicBar.leadingAnchor.constraint(equalTo: window.leadingAnchor,constant: 0),
                    self.musicBar.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: 0),
                    self.musicBar.heightAnchor.constraint(equalToConstant: 71),
                    self.musicBar.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -window.safeAreaBottom)
                ])
                self.musicBar.delegate = self
            }
            // MARK: -- add music bar
            
            self.musicBar.btnPlay.setImage(UIImage(named: "ic_pausing_black"), for: .normal)
            
        }
    }
    
}
extension MusicHelper: MusicBarViewDelegate {
    func didSelectedPrevious() {
        self.previousSongInPlaylist()
    }
    
    func didSelectedPlay() {
        switch status {
        case .None, .Playing:
            self.stopPlayBackground()
        case .Pause, .Finished:
            self.playBackgroundMusic()
            
        }
    }
    
    func didSelectedNext() {
        self.nextSongInPlaylist()
    }
    
    
}
