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
    
    func setupDataGeekChart(data: [FakeDataGeekchart]){
        var topConstraint: CGFloat = 0
        data.forEach { item in
            let sub = Explore_GeezChartSubView.instantiate()
            sub.translatesAutoresizingMaskIntoConstraints = false
            self.containerView.addArrangedSubview(sub)
//            NSLayoutConstraint.activate([
//                sub.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: topConstraint),
//                sub.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0),
//                sub.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0),
//                sub.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 0)
//            ])
//            topConstraint += sub.frame.height
        }
    }

}
