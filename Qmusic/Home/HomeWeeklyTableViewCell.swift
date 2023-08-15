//
//  HomeWeeklyTableViewCell.swift
//  Qmusic
//
//  Created by QuangHo on 15/08/2023.
//

import UIKit
struct Item {
    var value: String = ""
}


class HomeWeeklyTableViewCell: UITableViewCell {
    @IBOutlet weak private var carouselView: CarouselCollectionView!
    
    /// Carousel view Data source containing promotionItem
    private var carouselDataSource: CarouselDataSource<Item>?
    
    // MARK: - Properties
    /// The list of promotionItems
    public var items = [Item]() {
        didSet {
            updateDataSource()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        carouselView.register(UINib(nibName: "CarouselCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CarouselCollectionViewCell")
        self.items = [Item(value: "1"), Item(value: "2"), Item(value: "3"), Item(value: "4"), Item(value: "5")]
    }
    
    // MARK: - Userdefined methods
    /// Set up the data source variable with promotionItems
    private func updateDataSource() {
        carouselDataSource = CarouselDataSource(model: items, reuseIdentifier: "CarouselCollectionViewCell") { item, cell in
            guard let cell = cell as? CarouselCollectionViewCell else {
                return
            }
            cell.populate(item: item)
        }
        
        carouselView.dataSource = carouselDataSource
        carouselView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - UICollectionViewDelegate
extension HomeWeeklyTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        print("Selected Item at index: \(indexPath.row)")
    }
}
