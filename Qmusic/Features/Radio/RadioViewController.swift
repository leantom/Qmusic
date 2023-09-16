//
//  RadioViewController.swift
//  Qmusic
//
//  Created by QuangHo on 16/08/2023.
//

import UIKit

class RadioViewController: UIViewController {
    @IBOutlet weak var tbContent: UITableView!
    public var items = [Item]() {
        didSet {
            tbContent.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tbContent.register(UINib(nibName: "RadioPopularTableViewCell", bundle: nil), forCellReuseIdentifier: "RadioPopularTableViewCell")
        tbContent.register(UINib(nibName: "RadioWeeklyTableViewCell", bundle: nil), forCellReuseIdentifier: "RadioWeeklyTableViewCell")
        
        tbContent.register(UINib(nibName: "HeaderRadioView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderRadioView")
        
        
        
        self.items = [Item(value: "1", imgAlbums: "albums1", imgAlbumsBG: "radio1", artist: "Thuỳ Chi", nameSong: "Xe đạp"),
                      Item(value: "2", imgAlbums: "albums2", imgAlbumsBG: "radio2", artist: "Quốc Thiên", nameSong: "Nắng ấm xa dần"),
                      Item(value: "3", imgAlbums: "albums3", imgAlbumsBG: "radio3", artist: "Sơn Tùng MTP", nameSong: "Người ấy không phải là lựa chọn của em"),
                      Item(value: "4", imgAlbums: "albums4", imgAlbumsBG: "radio4", artist: "Thanh hà", nameSong: "Sức mạnh của gió"),
                      Item(value: "5", imgAlbums: "albums5", imgAlbumsBG: "radio1", artist: "Thuỷ Tiên", nameSong: "Ngôi nhà hoa hồng")]
    }


   

}

extension RadioViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 71
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RadioWeeklyTableViewCell", for: indexPath) as! RadioWeeklyTableViewCell
            cell.items = items
            cell.selectionStyle = .none
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RadioPopularTableViewCell", for: indexPath) as! RadioPopularTableViewCell
        
        cell.selectionStyle = .none
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderRadioView")
        if section == 1 {
            (header as! HeaderRadioView).lblDesc.isHidden = true
        } 
        return header
    }
    
}
