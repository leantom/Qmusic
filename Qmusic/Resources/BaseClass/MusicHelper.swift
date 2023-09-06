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
import MediaPlayer

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


class MusicHelper: NSObject {
    static let sharedHelper = MusicHelper()
    var audioPlayer: AVPlayer?
    var isFinished = false
    private var status:  MusicStatusPlay = .None
    private var type:  MusicTypePlaying = .None
    private var playlist: PlaylistDetail?
    private var song: PlaylistModel.ItemsPlaylist?
    private var youtubeModel: YoutubeMp3Info?
    
    private var index: Int = 0
    var homePageViewModel = HomeViewModel()
    
    let musicBar = MusicBarView.instantiate()
    var bottomContraint: NSLayoutConstraint?
    var isShowing = false
    
    override init() {
        super.init()
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
        
        
        WEBaseSceneDelegate.sharedInstance.addListener(listener: self)
        WEBaseSceneDelegate.sharedInstance.StartListening()
        setupRx()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        setupRemoteTransportControls()
    }
    
   @objc func methodSignatureForSelector() {
        
    }
    
    func setupRx() {
        homePageViewModel.output.songdetail.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                if let url = value.soundcloudTrack?.audio?.first?.url,
                   let items = self.playlist?.contents?.items {
                    let item = items[index]
                    self.playMusicWithURL(link: url,
                                          with: value.spotifyTrack?.name ?? "cyme",
                                          with: value.spotifyTrack?.artists?.first?.name ?? "cyme")
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
    
   @objc func nextSongInPlaylist() {
        if let playlistDetail = self.playlist,
           let items = playlistDetail.contents?.items {
            let item = items[index + 1]
            index += 1
            // MARK: -- call api to get song detail
            homePageViewModel.getSongDetail(id: item.id ?? "")
        }
    }
    
    @objc func previousSongInPlaylist() {
        if let playlistDetail = self.playlist,
           let items = playlistDetail.contents?.items {
            let item = items[index - 1]
            index -= 1
            // MARK: -- call api to get song detail
            homePageViewModel.getSongDetail(id: item.id ?? "")
        }
    }
    
    func getStatusPlayer() ->  MusicStatusPlay{
        return status
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
        self.musicBar.stopMusic()
    }
    
    func rewindPlaying(time: Double) {
        let targetTime = CMTime(seconds: time, preferredTimescale: 1)
        audioPlayer?.seek(to: targetTime)
        audioPlayer?.status
    }
    
    // MARK: -- play with playlist
    func playMusicWithPlaylist(link: String,
                               on view: UIView,
                               with index: Int,
                               with playlist: PlaylistDetail) {
        self.type = .Playlist
        showProgressBar()
        self.playlist = playlist
        self.index = index
        if let items = playlist.contents?.items,
           items.count > index {
            let item = items[index]
            self.song = item
             musicBar.populate(nameSong: item.name ?? "",
                               urlImage: item.album?.cover?.first?.url ?? "")
            musicBar.stopMusic()
            switch status {
            case .None:
                playMusicWithURL(link: link,
                                 with: item.name ?? "cyme",
                                 with: item.artists?.first?.name ?? "cyme")
            case .Playing, .Pause, .Finished:
                playMusicWithURL(link: link, with: item.name ?? "cyme", with: item.artists?.first?.name ?? "cyme")
            }
        }
        
        
    }
    // MARK: --playMusicWithYoutube
    func playMusicWithYoutube(link: String,
                              youtubeModel: YoutubeMp3Info,
                              with type: MusicTypePlaying) {
        self.type = type
        self.youtubeModel = youtubeModel
        let title = youtubeModel.title ?? "cyme"
        let desc = youtubeModel.author ?? "cyme"
        musicBar.populate(nameSong: title,
                          urlImage: youtubeModel.thumb ?? "")
        musicBar.stopMusic()
        showProgressBar()
        
        switch status {
        case .None:
            playMusicWithURL(link: link, with: title, with: desc)
        case .Playing, .Pause, .Finished:
            playMusicWithURL(link: link, with: title, with: desc)
        }
    }
    
    func isPlayable(url: URL, completion: @escaping (Bool) -> ()) {
        let asset = AVAsset(url: url)
        let playableKey = "playable"
        asset.loadValuesAsynchronously(forKeys: [playableKey]) {
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: playableKey, error: &error)
            let isPlayable = status == .loaded
            DispatchQueue.main.async {
                completion(isPlayable)
            }
        }
    }
    
    //MARK: get lyric form metadata
    func extractLyricsFromAudioFile(url: URL) -> String? {
        let asset = AVAsset(url: url)
        let metadata = asset.metadata
        
        for item in metadata {
            if let commonKey = item.commonKey?.rawValue, commonKey == "lyrics" {
                if let lyricsData = item.value as? Data, let lyricsString = String(data: lyricsData, encoding: .utf8) {
                    return lyricsString
                }
            }
        }
        
        return nil
    }

    // MARK: -- dùng cho auto chuyển bài hát
    func playMusicWithURL(link: String,
                          with tilte: String = "cyme",
                          with artist: String = "cyme") {
        Logger.log(message: "starting song url", event: .e)
        if let url = URL(string: link) {
            
            do {
                Logger.log(message: link, event: .e)
                Logger.log(message: "loading song url", event: .e)
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                self.isPlayable(url: url) {  [weak self] isPlayable in
                    guard let self = self else { return }
                    Logger.log(message: "isPlayable \(isPlayable)", event: .e)
                    if isPlayable == false {
                        self.playMusicWithURL(link: link)
                        
                        return
                    }
                    // MARK: -- show progress bar
                    if let items = self.playlist?.contents?.items,
                       items.count > index {
                        let item = items[index]
                        if let song = AppSetting.shared.getSongDataFromLocal(id: item.id ?? ""),
                        let durationMs = song.soundcloudTrack?.audio?.first?.durationMs {
                            musicBar.playMusic(with: durationMs/1000)
                        }
                    }

                    if let youtubeModel = self.youtubeModel {
                        musicBar.playMusic(with: Int(youtubeModel.duration))
                    }
                    
                    self.audioPlayer = AVPlayer(url: url)
                    
                    
                    let albumArt = MPMediaItemArtwork(image:  musicBar.imgAlbums.image!)
                    
                    let mpic = MPNowPlayingInfoCenter.default()
                    mpic.nowPlayingInfo = [MPMediaItemPropertyTitle:tilte,
                                          MPMediaItemPropertyArtist:artist,
                                         MPMediaItemPropertyArtwork: albumArt
                                           ]
                    
                    Logger.log(message: "loaded song url", event: .e)
                    
                    audioPlayer?.play()
                    
                    Logger.log(message: "audioPlayer: \(String(describing: audioPlayer?.rate))", event: .d)
                    status = .Playing
                    
                }
                
            } catch let err{
                print(err.localizedDescription)
            }
            
            
        }
    }
    // MARK: -- setup for command home center
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()

        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.audioPlayer?.rate == 0.0 {
                self.audioPlayer?.play()
                return .success
            }
            return .commandFailed
        }

        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.audioPlayer?.rate == 1.0 {
                self.audioPlayer?.pause()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            if self.audioPlayer?.rate == 1.0 {
                self.previousSongInPlaylist()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
            if self.audioPlayer?.rate == 1.0 {
                self.nextSongInPlaylist()
                return .success
            }
            return .commandFailed
        }
    }
    
    func moveToWhenBackHomeScreen() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        if let _ = window.viewWithTag(1000) {
            bottomContraint?.constant = -window.safeAreaBottom - 48
        }
        UIView.animate(withDuration: 0.3) {
            window.layoutIfNeeded()
        }
    }
    
    func moveUpWhenBackHomeScreen() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        if let _ = window.viewWithTag(1000) {
            bottomContraint?.constant = -window.safeAreaBottom
        }
        UIView.animate(withDuration: 0.3) {
            window.layoutIfNeeded()
        }
    }
    
    
    func showProgressBar() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        if let _ = window.viewWithTag(1000) {
            
        } else {
            
            self.musicBar.tag = 1000
            window.addSubview(self.musicBar)
            bottomContraint = self.musicBar.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -window.safeAreaBottom)
            
            NSLayoutConstraint.activate([
                self.musicBar.leadingAnchor.constraint(equalTo: window.leadingAnchor,constant: 0),
                self.musicBar.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: 0),
                self.musicBar.heightAnchor.constraint(equalToConstant: 71),
                self.bottomContraint!
            ])
            self.musicBar.delegate = self
        }
        // MARK: -- add music bar
        
        self.musicBar.btnPlay.setImage(UIImage(named: "ic_pause"), for: .normal)
        self.isShowing = true
    }
    
    func parseLyrics(lyricsText: String) -> [LyricLineModel] {
        var lyricLines: [LyricLineModel] = []
        
        let pattern = "\\[(\\d{2}:\\d{2}\\.\\d{2})\\]([^\\[]+)"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matches(in: lyricsText, options: [], range: NSRange(location: 0, length: lyricsText.utf16.count))
            
            for match in matches {
                if let timeRange = Range(match.range(at: 1), in: lyricsText),
                   let lyricRange = Range(match.range(at: 2), in: lyricsText) {
                    let time = String(lyricsText[timeRange])
                    let lyric = String(lyricsText[lyricRange])
                    
                    let lyricLine = LyricLineModel(time: time, lyric: lyric)
                    lyricLines.append(lyricLine)
                }
            }
        } catch {
            print("Error creating regular expression: \(error)")
        }
        
        return lyricLines
        
    }
    
    func removeMusicBarWhenLogout() {
        self.musicBar.removeFromSuperview()
        audioPlayer?.pause()
        audioPlayer = nil
    }
    
    func hiddenMusicBar(){
        UIView.animate(withDuration: 0.25) {
            self.musicBar.alpha = 0
        } completion: { _ in
            self.moveToSongDetail()
        }
    }
    
    func showMusicBar(){
        UIView.animate(withDuration: 0.25) {
            self.musicBar.alpha = 1
        }
    }
    
    private func moveToSongDetail(){
        if let topController = appDelegate.getTopMostViewController(){
            guard let song = self.song else {
                print("Data Playlist isEmpty")
                return
            }
            let vc = SongDetailViewController(data: song)
            (topController as? UINavigationController)?.push(destinVC: vc)
        }
    }
}
extension MusicHelper: MusicBarViewDelegate {
    func didSelectedView() {
        self.hiddenMusicBar()
        //MARK: Hidden Musicbar and show song detail
        
    }
    
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

extension MusicHelper: IWEBaseSceneDelegate {
    func notifyAppEnterBackground() {
        playBackgroundMusic()
    }
    
    func notifyAppEnterForground() {
        //stopPlayBackground()
    }
    
    
    
    
}
