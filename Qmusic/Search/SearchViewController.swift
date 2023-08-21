//
//  SearchViewController.swift
//  Qmusic
//
//  Created by QuangHo on 18/08/2023.
//

import UIKit
import AVFoundation

class SearchViewController: UIViewController {
    var player: AVPlayer?
    
    @IBOutlet weak var tbContent: UITableView!
    var objectMp3: YoutubeDataMP3?
    @IBOutlet weak var tfSearch: UITextField!
    var musicBar: MusicBarView = {
        let v = MusicBarView.instantiate()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    @IBOutlet weak var musicContainView: UIView!
    
    @IBOutlet weak var heightContraintMusicBarView: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbContent.register(UINib(nibName: "RadioPopularTableViewCell", bundle: nil), forCellReuseIdentifier: "RadioPopularTableViewCell")
        tbContent.delegate = self
        tbContent.dataSource = self
        tfSearch.delegate = self
        // Do any additional setup after loading the view.
        
        musicContainView.addSubview(musicBar)
        musicBar.layoutAttachAll()
        heightContraintMusicBarView.constant = 0
        
        NotificationCenter.default
            .addObserver(self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
        
        
        NotificationCenter.default
            .addObserver(self,
            selector: #selector(failedToPlayToEndTime),
            name: .AVPlayerItemFailedToPlayToEndTime,
            object: player?.currentItem
        )
        
        NotificationCenter.default
            .addObserver(self,
            selector: #selector(playbackStalled),
            name: .AVPlayerItemPlaybackStalled,
            object: player?.currentItem
        )
        
        NotificationCenter.default
            .addObserver(self,
            selector: #selector(newAccessLogEntry),
            name: .AVPlayerItemNewAccessLogEntry,
            object: player?.currentItem
        )
        
        NotificationCenter.default
            .addObserver(self,
            selector: #selector(newErrorLogEntry),
            name: .AVPlayerItemNewErrorLogEntry,
            object: player?.currentItem
        )
        
        
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
    
    

    @IBAction func actionHideKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func showError() {
        let ac = UIAlertController(title: "Xin lỗi", message: "Link bạn tìm kiếm không đúng", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default) { alert in
            
        })
        self.present(ac, animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let inputSearch =  textField.text,
           let _ = URL(string: inputSearch) {
            NetworkYoutube.sharedInstance.searchLinkMp3(linkURL: inputSearch) { result in
                switch result {
                case .success(let object):
                    self.objectMp3 = object
                    DispatchQueue.main.async {
                        self.tbContent.reloadData()
                    }
                    
                case .failure(_):
                    DispatchQueue.main.async {
                        self.showError()
                    }
                    
                }
            }
        }
        
        
    }
    
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objectMp3 == nil {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RadioPopularTableViewCell", for: indexPath) as! RadioPopularTableViewCell
        cell.lblDesc.text = objectMp3?.title ?? ""
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objectMp3 = self.objectMp3 {
            playMusic(link: objectMp3.link)
        }
    }
    
    func playMusic(link: String) {
        if let url = URL(string: link) {
            let playerItem: AVPlayerItem = AVPlayerItem(url: url)
            
            player = AVPlayer(playerItem: playerItem)
            MusicHelper.sharedHelper.audioPlayer = player
            let playerLayer = AVPlayerLayer(player: player!)
            playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
            self.view.layer.addSublayer(playerLayer)
            player?.play()
            if let objectMp3 = self.objectMp3 {
                setupMusicBar(object: objectMp3)
            }
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    func setupMusicBar(object: YoutubeDataMP3) {
        heightContraintMusicBarView.constant = 71
        musicBar.lblNameSong.text = object.title
        musicBar.btnNext.isHidden = true
        musicBar.btnPrevious.isHidden = true
        musicBar.btnPlay.setImage(UIImage(named: "ic_pausing_black"), for: .normal)
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        musicBar.btnPlay.setImage(UIImage(named: "ic_playing_black"), for: .normal)
        
    }
    
}
