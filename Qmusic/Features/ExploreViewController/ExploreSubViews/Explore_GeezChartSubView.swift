//
//  Explore_GeezChartSubView.swift
//  Qmusic
//
//  Created by Macbook on 8/15/23.
//

import UIKit

class Explore_GeezChartSubView: UIView {

    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblID: UILabel!
   
    func setupData(item: FakeDataGeekchart){
        self.lblID.text = item.id
        self.lblTitle.text = item.name
        self.lblDesc.text = item.des
        self.imgAvatar.image = UIImage(named: item.image)
    }

}
