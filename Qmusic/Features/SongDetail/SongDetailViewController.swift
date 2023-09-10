//
//  SongDetailViewController.swift
//  Qmusic
//
//  Created by Macbook on 9/6/23.
//

import UIKit
import RxSwift

class SongDetailViewController: UIViewController {

    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var btnLoop: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnShufflet: UIButton!
    
    @IBOutlet weak var vSlider: UISlider!
    @IBOutlet weak var lblSliderMin: UILabel!
    @IBOutlet weak var lblSliderMax: UILabel!
    
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnDownload: UIButton!
    
    @IBOutlet weak var imgSong: UIImageView!
    @IBOutlet weak var lblTitleSong: UILabel!
    @IBOutlet weak var lblArtistSong: UILabel!
    @IBOutlet weak var lblDescSong: UILabel!
    @IBOutlet weak var vPageControl: UIPageControl!
    
    @IBOutlet weak var vScroll: UIScrollView!
    @IBOutlet weak var vTable: UITableView!
    
    var stepMs: Float = 0
    var isPlayMusic: Bool = true
    var isLoveSong: Bool = false
    var lyricDetail: [LyricLineModel]?
    
    var homePageViewModel: HomeViewModel?
    var songDetail: PlaylistModel.ItemsPlaylist?
    var isScrollSlider = false
    
    var duration: Int = 1
    var timer: Timer?
    
    convenience init(data: PlaylistModel.ItemsPlaylist, duration: Int) {
        self.init(nibName: "SongDetailViewController", bundle: nil)
        self.songDetail = data
        self.duration = duration
        self.stepMs = 1 / Float(data.durationMs ?? 0)
    }
    
    func updateUIWhenTimeChange(){
        self.moveSliderPositionTo(value: Float(self.duration))
        let min = self.millisecondsToMMSS(self.duration * 1000)
        self.setupTextSlider(min: min)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRx()
        self.vPageControl.numberOfPages = 2
        self.vScroll.delegate = self
//        self.vTextView.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
//        vPageControl.currentPage = indexPath.row
    }
    
    func setupRx() {
        self.homePageViewModel = HomeViewModel()
        guard let homePageViewModel = self.homePageViewModel else {return}
        
        homePageViewModel.output.lyricDetail.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                if value.isEmpty{
                    self.lblDescSong.text = "..."
                } else {
                    self.lyricDetail = value
                    self.lblDescSong.text = value.first?.lyric
                    self.vTable.reloadData()
//                    let joinedText = value.map { $0.lyric }.joined(separator: "")
//                    self.setTextView(joinedText)
                }
            })
            .disposed(by: homePageViewModel.disposeBag)
        
        if let song = self.songDetail, let id = song.id{
            homePageViewModel.getLyricDetail(id: id)
            self.setupData(data: song)
        }
    }
    
   private func setupUI(){
       self.setupSlider()
       self.setupTableView()
    }
    
    private func setupTableView(){
        self.vTable.delegate = self
        self.vTable.dataSource = self
        self.vTable.register(UINib(nibName: "SongDetail_LyricsTableViewCell", bundle: nil), forCellReuseIdentifier: "SongDetail_LyricsTableViewCell")
    }
    
    @IBAction func actionSlider(_ sender: UISlider) {

    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.stopTimer()
        self.navigationController?.popWithCompletion(completion: {
            MusicHelper.sharedHelper.showMusicBar()
        })
    }
    
    @IBAction func actionShare(_ sender: Any) {
        
    }
    
    @IBAction func actionAddMenu(_ sender: Any) {
        
    }
    
    @IBAction func actionLike(_ sender: Any) {
        self.isLoveSong = !self.isLoveSong
        let image = isLoveSong ? "ic_songdetail_like" : "ic_explore_heart_white"
        UIView.animate(withDuration: 0.3) {
            self.btnLike.setImage(UIImage(named: image), for: .normal)
        }
    }
    
    @IBAction func actionDownload(_ sender: Any) {
        
    }
    
    @IBAction func actionShuffle(_ sender: Any) {
        
    }
    
    @IBAction func actionPrevious(_ sender: Any) {
        
    }
    
    @IBAction func actionPlay(_ sender: Any) {
        self.isPlayMusic = !self.isPlayMusic
        let img = self.isPlayMusic ? "ic_songdetail_pausing" : "ic_songdetail_playing"
        UIView.animate(withDuration: 0.3) {
            self.btnPlay.setImage(UIImage(named: img), for: .normal)
        } completion: { _ in
            if self.isPlayMusic{
                MusicHelper.sharedHelper.playBackgroundMusic()
                self.playingMusic()
            } else {
                MusicHelper.sharedHelper.stopPlayBackground()
                self.pausingMusic()
            }
        }

    }
    
    @IBAction func actionNext(_ sender: Any) {
        
    }
    
    @IBAction func actionLoop(_ sender: Any) {
        
    }
    
}

extension SongDetailViewController{
    
    private func millisecondsToMMSS(_ milliseconds: Int) -> String {
        let seconds = milliseconds / 1000
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    func timeStringToSeconds(_ timeString: String) -> Float? {
        let timeComponents = timeString.components(separatedBy: ":")
        if timeComponents.count == 2,
            let minutes = Float(timeComponents[0]),
            let secondsAndMilliseconds = Float(timeComponents[1]) {
            return (minutes * 60) + secondsAndMilliseconds
        }
        return nil
    }

    
    //MARK: setup firstlaunch
    func setupData(data: PlaylistModel.ItemsPlaylist) {
        
        self.setupTextSong(data: data)
        
        self.playMusic()
        UIView.animate(withDuration: 0.3) {
            self.btnPlay.setImage(UIImage(named: "ic_songdetail_pausing"), for: .normal)
        }
    }
    
    func setupTextSlider(min: String){
        self.lblSliderMin.text = min
        self.lblSliderMax.text = self.songDetail?.durationText ?? "00:00"
    }
    
    private func setupTextSong(data: PlaylistModel.ItemsPlaylist) {
        self.lblTitleSong.text = data.name ?? ""
        self.lblArtistSong.text = data.artists?.first?.name ?? ""
        let urlImage = data.album?.cover?.first?.url ?? ""
        if let url = URL(string: urlImage) {
            self.imgSong.layer.masksToBounds = true
            self.imgSong.layer.cornerRadius = self.imgSong.frame.height / 2
            self.imgSong.setImage(from: url)
        }
    }
    
    func changeBackGroundImage(){
        self.imgBackground.image = UIImage(named: "")
    }
    
    func setupSlider(){
        self.vSlider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                self.isScrollSlider = true
            case .moved:
                self.isScrollSlider = true
            case .ended:
                // handle drag ended
                let roundedValue = round(slider.value / stepMs) * stepMs
                let time = Int((roundedValue/stepMs).rounded()) / 1000
                self.duration = time
                self.updateUIWhenTimeChange()
                MusicHelper.sharedHelper.rewindPlaying(time: Double(time))
                self.isScrollSlider = false
            default:
                break
            }
        }
    }
    
    func moveSliderPositionTo(value: Float){
        UIView.animate(withDuration: 0.1) {
            
            self.vSlider.value = (value * 1000) * self.stepMs
            self.vSlider.layoutIfNeeded()
            
            //MARK: HANDLE SCROLL LYRIC TIME
            if let lyric = self.lyricDetail{
                for (inde, _) in lyric.enumerated(){
                    let time = self.timeStringToSeconds(lyric[inde].time) ?? 0
                    if inde == lyric.count - 1{
                        //MARK: current
                        if value > time{
                            self.vTable.scrollToRow(at: IndexPath(row: inde, section: 0), at: .top, animated: true)
                        }
                    } else {
                        let nextTime = self.timeStringToSeconds(lyric[inde + 1].time) ?? 0
                        if value > time && value < nextTime{
                            self.vTable.scrollToRow(at: IndexPath(row: inde, section: 0), at: .top, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func setTextView(_ text: String) {
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 8
//        // Lấy các thuộc tính font và màu từ UITextView
//        let existingAttributes: [NSAttributedString.Key : Any] = [
//            .font: self.vTextView.font as Any,
//            .foregroundColor: self.vTextView.textColor as Any,
//            .paragraphStyle: paragraphStyle
//        ]
//        let attributedString = NSAttributedString(string: text, attributes: existingAttributes)
//
//        self.vTextView.attributedText = attributedString
    }
}

extension SongDetailViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.stoppedScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.stoppedScrolling()
        }
    }

    func stoppedScrolling() {
        let width = Double(self.view.frame.width)
        let offSetX = self.vScroll.contentOffset.x
        let currentScreen = (Double(offSetX) / width).rounded()
        UIView.animate(withDuration: 0.2) {
            self.vScroll.contentOffset = CGPoint(x: (width * currentScreen), y: 0)
            self.vPageControl.currentPage = Int(currentScreen)
        }
    }
}

extension SongDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.lyricDetail?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongDetail_LyricsTableViewCell", for: indexPath) as! SongDetail_LyricsTableViewCell
        if let data = self.lyricDetail{
            let lyric = data[indexPath.row].lyric
            cell.setupLyric(lyric)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
}
extension SongDetailViewController {
    
    func playMusic() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(animationProgressBar), userInfo: nil, repeats: true)
    }

    @objc func animationProgressBar() {
        UIView.animate(withDuration: 1) {
            self.imgSong.transform = self.imgSong.transform.rotated(by: .pi / 18) // xoay 10 độ
        }
        self.duration += 1
        if !self.isScrollSlider{
            self.updateUIWhenTimeChange()
        }
    }
    
    func stopTimer(){
        self.timer?.invalidate()
        self.timer = nil
        self.duration = 0
    }
    
    func pausingMusic(){
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func playingMusic(){
        self.timer?.invalidate()
        self.timer = nil
        self.playMusic()
    }
}

