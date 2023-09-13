//
//  SongDetail_LyricsTableViewCell.swift
//  Qmusic
//
//  Created by Macbook on 9/8/23.
//

import UIKit

class SongDetail_LyricsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblLyric: UILabel!
    
    func setupLyric(_ lyric: String, isHighlight: Bool) {
        self.lblLyric.text =  lyric
        if isHighlight{
            self.lblLyric.textColor = AppColors.kCBFB5E
        } else {
            self.lblLyric.textColor = .white
        }
    }
//
//    func highLightText(){
//        self.isHighlight = true
//        self.lblLyric.textColor = AppColors.kCBFB5E
//        print("Text highLight: \(self.lblLyric.text ?? "")")
//    }
}
