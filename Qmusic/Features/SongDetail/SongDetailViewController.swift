//
//  SongDetailViewController.swift
//  Qmusic
//
//  Created by Macbook on 9/6/23.
//

import UIKit
//ic_explore_heart_white
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
    
    convenience init(hmm: String) {
        self.init(nibName: "SongDetailViewController", bundle: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
   private func setupUI(){
        self.setupSlider()
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
        let img = self.isPlayMusic ? "Playing" : "Pausing"
        UIView.animate(withDuration: 0.3) {
            self.btnPlay.setImage(UIImage(named: img), for: .normal)
        }
    }
    
    @IBAction func actionNext(_ sender: Any) {
        
    }
    
    @IBAction func actionLoop(_ sender: Any) {
        
    }
    
}

extension SongDetailViewController{
    
    func changeBackGroundImage(){
        self.imgBackground.image = UIImage(named: "")
    }
    
    func setupSlider(){
//        self.vSlider.setThumbImage(UIImage(named: "ic_songdetail_thumb"), for: .normal)
        
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

}
