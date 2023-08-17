//
//  HomeWeeklyTableViewCell.swift
//  Qmusic
//
//  Created by QuangHo on 15/08/2023.
//

import UIKit
struct Item {
    var value: String = ""
    var imgAlbums: String = ""
    var imgAlbumsBG: String = ""
    var artist: String = ""
    var nameSong: String = ""
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
        self.items = [Item(value: "1", imgAlbums: "albums1", imgAlbumsBG: "albums1", artist: "Thuỳ Chi", nameSong: "Xe đạp"),
                      Item(value: "2", imgAlbums: "albums2", imgAlbumsBG: "albums2_bg", artist: "Quốc Thiên", nameSong: "Nắng ấm xa dần"),
                      Item(value: "3", imgAlbums: "albums3", imgAlbumsBG: "albums3_bg", artist: "Sơn Tùng MTP", nameSong: "Người ấy không phải là lựa chọn của em"),
                      Item(value: "4", imgAlbums: "albums4", imgAlbumsBG: "albums4_bg", artist: "Thanh hà", nameSong: "Sức mạnh của gió"),
                      Item(value: "5", imgAlbums: "albums5", imgAlbumsBG: "albums5_bg", artist: "Thuỷ Tiên", nameSong: "Ngôi nhà hoa hồng")]
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
