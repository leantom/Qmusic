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
    
    var step: Float = 0
    var isPlayMusic: Bool = true
    var isLoveSong: Bool = false
    var lyricDetail: [LyricLineModel]?
    
    var homePageViewModel: HomeViewModel?
    var songDetail: PlaylistModel.ItemsPlaylist?
    
    convenience init(data: PlaylistModel.ItemsPlaylist) {
        self.init(nibName: "SongDetailViewController", bundle: nil)
        self.songDetail = data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRx()
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
    }
    
    @IBAction func actionSlider(_ sender: UISlider) {

    }
    
    @IBAction func actionBack(_ sender: Any) {
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
        let image = isLoveSong ? "ic_explore_heart_red" : "ic_explore_heart_white"
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
        let img = self.isPlayMusic ? "Pausing" : "Playing"
        UIView.animate(withDuration: 0.3) {
            self.btnPlay.setImage(UIImage(named: img), for: .normal)
        } completion: { _ in
            if self.isPlayMusic{
                MusicHelper.sharedHelper.playBackgroundMusic()
            } else {
                MusicHelper.sharedHelper.stopPlayBackground()
            }
        }

    }
    
    @IBAction func actionNext(_ sender: Any) {
        
    }
    
    @IBAction func actionLoop(_ sender: Any) {
        
    }
    
}

extension SongDetailViewController{
    
    func setupData(data: PlaylistModel.ItemsPlaylist) {
        self.setupTextSlider(min: "00:00", max: data.durationText ?? "00:00")
        self.setupTextSong(data: data)
        self.imgSong.layer.masksToBounds = true
        self.imgSong.layer.cornerRadius = self.imgSong.frame.height / 2
        self.step = 1 / Float(data.durationMs ?? 0)
        UIView.animate(withDuration: 0.3) {
            self.btnPlay.setImage(UIImage(named: "Pausing"), for: .normal)
        }
    }
    
    func setupTextSlider(min: String, max: String){
        self.lblSliderMin.text = min
        self.lblSliderMax.text = max
    }
    
    private func setupTextSong(data: PlaylistModel.ItemsPlaylist) {
        self.lblTitleSong.text = data.name ?? ""
        self.lblArtistSong.text = data.artists?.first?.name ?? ""
        let urlImage = data.album?.cover?.first?.url ?? ""
        if let url = URL(string: urlImage) {
            self.imgSong.setImage(from: url)
        }
    }
    
    func changeBackGroundImage(){
        self.imgBackground.image = UIImage(named: "")
    }
    
    func setupSlider(){
//        self.vSlider.setThumbImage(UIImage(named: "ic_songdetail_thumb"), for: .normal)
        self.vSlider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                // handle drag began
                break
            case .moved:
                // handle drag moved
                break
            case .ended:
                // handle drag ended
                let roundedValue = round(slider.value / step) * step
                let time = Int((roundedValue/step).rounded())
                MusicHelper.sharedHelper.rewindPlaying(time: Double(time))
                    break
            default:
                break
            }
        }
    }
    
    func setValueDefautlSlider(){
//        self.step = 1/Float(arrSlide.count - 1)
    }
    
    func setValueSlider(_ value: String){
        //    UIView.animate(withDuration: 0.1) {
        //        self.slider.value = Float(self.arrSlide.last ?? 0)/Float(self.arrSlide.count - 1)
        //        self.slider.layoutIfNeeded()
        //    }
    }
    
    func moveSliderPositionTo(value: Float){
        UIView.animate(withDuration: 0.1) {
            self.vSlider.value = value
            self.vSlider.layoutIfNeeded()
        }
    }
}
