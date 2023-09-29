//
//  ExploreGeezChartTableViewCell.swift
//  Qmusic
//
//  Created by Macbook on 8/14/23.
//

import UIKit

struct FakeDataGeekchart{
    let id: String
    let name: String
    let des: String
    let image: String
}

class ExploreGeezChartTableViewCell: UITableViewCell {
 
    @IBOutlet weak var containerView: UIStackView!
    
    lazy var subView: Explore_GeezChartSubView = {
        let v = Explore_GeezChartSubView.instantiate()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    func setupDataGeekChart(data: Trending_DataResult){
//        var topConstraint: CGFloat = 0
        guard let items = data.tracks?.items else {return}
        items.forEach { item in
            let sub = Explore_GeezChartSubView.instantiate()
            sub.translatesAutoresizingMaskIntoConstraints = false
            self.containerView.addArrangedSubview(sub)
            sub.setupData(item: item)
        }
    }

}
