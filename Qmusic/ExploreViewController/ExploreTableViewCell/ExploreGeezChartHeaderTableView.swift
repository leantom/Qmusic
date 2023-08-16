//
//  ExploreGeezChartHeaderTableView.swift
//  Qmusic
//
//  Created by Macbook on 8/16/23.
//

import Foundation
import UIKit

class ExploreGeezChartHeaderTableView: UIView{
    
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        
    }
    
    func setupData(title: String, button: String){
        self.lblTitle.text = title
        self.btnRight.setTitle(button, for: .normal)
    }
}
