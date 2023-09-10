//
//  SongDetail_LyricsTableViewCell.swift
//  Qmusic
//
//  Created by Macbook on 9/8/23.
//

import UIKit

class SongDetail_LyricsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblLyric: UILabel!
    
    func setupLyric(_ lyric: String) {
        self.lblLyric.text =  lyric
    }
}
