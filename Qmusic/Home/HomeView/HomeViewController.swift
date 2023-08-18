//
//  HomeViewController.swift
//  Qmusic
//
//  Created by QuangHo on 14/08/2023.
//

import UIKit
protocol HomeViewControllerDelegate: AnyObject {
    func didSelectRecentlySong(indexPath: IndexPath, item: Item)
}

class HomeViewController: UIViewController {

    // tableview
    // title section
    // section 1: - collectionview
    // section 2: avplayer
    // section 3: recently music
    // mainView
    
    @IBOutlet weak var tbContent: UITableView!
    let headerTitles = ["New Albums", "Cyme Weekly", "Recently Music", "Selected by Artist"]
    weak var delegate: HomeViewControllerDelegate?
     
    @IBOutlet var header1: UIView!
    
    @IBOutlet weak var lblHeaderTitle1: UILabel!
    
    @IBOutlet var header2: UIView!
    
    @IBOutlet weak var lblHeaderTitle2: UILabel!
    
    public var items = [Item]() {
        didSet {
            tbContent.reloadData()
        }
    }
    var isSelectedSong = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tbContent.register(UINib(nibName: "HomeWeeklyTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeWeeklyTableViewCell")
        
        tbContent.register(UINib(nibName: "HomeAlbumsTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeAlbumsTableViewCell")
        
        tbContent.register(UINib(nibName: "RecentlyMusicTableViewCell", bundle: nil), forCellReuseIdentifier: "RecentlyMusicTableViewCell")
        
        tbContent.delegate = self
        tbContent.dataSource = self
        
        self.items = [Item(value: "1", imgAlbums: "albums1", imgAlbumsBG: "albums1", artist: "Thuỳ Chi", nameSong: "Xe đạp"),
                      Item(value: "2", imgAlbums: "albums2", imgAlbumsBG: "albums2_bg", artist: "Quốc Thiên", nameSong: "Nắng ấm xa dần"),
                      Item(value: "3", imgAlbums: "albums3", imgAlbumsBG: "albums3_bg", artist: "Sơn Tùng MTP", nameSong: "Người ấy không phải là lựa chọn của em"),
                      Item(value: "4", imgAlbums: "albums4", imgAlbumsBG: "albums4_bg", artist: "Thanh hà", nameSong: "Sức mạnh của gió"),
                      Item(value: "5", imgAlbums: "albums5", imgAlbumsBG: "albums5_bg", artist: "Thuỷ Tiên", nameSong: "Ngôi nhà hoa hồng")]
        
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let sectionHeader = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let homeHeaderView = HomeHeaderView.instantiate()
        
        homeHeaderView.lblTitle.text = headerTitles[section]
        if section != 0 {
            homeHeaderView.btnViewAll.isHidden = true
        }
        sectionHeader.addSubview(homeHeaderView)
        homeHeaderView.layoutAttachAll()
        return sectionHeader
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section >= 2 {
            return 5
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeWeeklyTableViewCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }
        
        if indexPath.section >= 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentlyMusicTableViewCell", for: indexPath) as! RecentlyMusicTableViewCell
            cell.popuplate(item: items[indexPath.row])
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeAlbumsTableViewCell", for: indexPath)
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            delegate.didSelectRecentlySong(indexPath: indexPath, item: items[indexPath.row])
        }
        isSelectedSong = true
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section > 2 {return 44}
        return 1
    }
    
    
}

extension HomeViewController: RecentlyMusicTableViewCellDelegate {
    func didSelectShowDetail(cell: RecentlyMusicTableViewCell) {
        if let fromIndex = tbContent.indexPath(for: cell)
            {
            let firstIndex = IndexPath(row: 0, section: fromIndex.section)
            self.move(from: fromIndex, to: firstIndex)
        }
    }
    
    func move(from: IndexPath, to: IndexPath) {
        UIView.animate(withDuration: 0.3, animations: {
                self.tbContent.moveRow(at: from, to: to)
            }) { (true) in
                // write here code to remove score from array at position "at" and insert at position "to" and after reloadData()
            }
        }
    
    
}
