//
//  SongDetailViewController+UI.swift
//  Qmusic
//
//  Created by Macbook on 9/11/23.
//

import Foundation
import UIKit

extension SongDetailViewController{
    
    func moveToRow(_ row: Int){
        self.lblDescSong.text = self.lyricDetail?[row].lyric ?? "..."
        let index = IndexPath(row: row, section: 0)
        self.vTable.scrollToRow(at: index, at: .top, animated: true)
        
        print("Index highLight: \(row)")
        let cell = self.vTable.cellForRow(at: index) as! SongDetail_LyricsTableViewCell
        cell.highLightText()
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
                            self.moveToRow(inde)
                        }
                    } else {
                        let nextTime = self.timeStringToSeconds(lyric[inde + 1].time) ?? 0
                        if value > time && value < nextTime{
                            self.moveToRow(inde)
                        }
                    }
                }
            }
        }
    }
    
    func updateUIWhenTimeChange(){
        self.moveSliderPositionTo(value: Float(self.duration))
        let min = self.millisecondsToMMSS(self.duration * 1000)
        self.setupTextSlider(min: min)
    }
    
    func setupTextSlider(min: String){
        self.lblSliderMin.text = min
        self.lblSliderMax.text = self.songDetail?.durationText ?? "00:00"
    }
    
    func setupTextSong(data: PlaylistModel.ItemsPlaylist) {
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
