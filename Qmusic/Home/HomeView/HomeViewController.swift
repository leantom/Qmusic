//
//  HomeViewController.swift
//  Qmusic
//
//  Created by QuangHo on 14/08/2023.
//

import UIKit

class HomeViewController: UIViewController {

    // tableview
    // title section
    // section 1: - collectionview
    // section 2: avplayer
    // section 3: recently music
    // mainView
    
    @IBOutlet weak var tbContent: UITableView!
    let headerTitles = ["New Albums", "Cyme Weekly", "Recently Music "]
    
    @IBOutlet var header1: UIView!
    
    @IBOutlet weak var lblHeaderTitle1: UILabel!
    
    @IBOutlet var header2: UIView!
    
    @IBOutlet weak var lblHeaderTitle2: UILabel!
    
    public var items = [Item]() {
        didSet {
            tbContent.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tbContent.register(UINib(nibName: "HomeWeeklyTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeWeeklyTableViewCell")
        
        tbContent.register(UINib(nibName: "HomeAlbumsTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeAlbumsTableViewCell")
        
        tbContent.register(UINib(nibName: "RecentlyMusicTableViewCell", bundle: nil), forCellReuseIdentifier: "RecentlyMusicTableViewCell")
        
        tbContent.delegate = self
        tbContent.dataSource = self
        
        self.items = [Item(value: "1", imgAlbums: "albums1", imgAlbumsBG: "albums1"),
                      Item(value: "2", imgAlbums: "albums2", imgAlbumsBG: "albums2_bg"),
                      Item(value: "3", imgAlbums: "albums3", imgAlbumsBG: "albums3_bg"),
                      Item(value: "4", imgAlbums: "albums4", imgAlbumsBG: "albums4_bg"),
                      Item(value: "5", imgAlbums: "albums5", imgAlbumsBG: "albums5_bg")]
        
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
        if section == 2 {
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
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentlyMusicTableViewCell", for: indexPath) as! RecentlyMusicTableViewCell
            cell.popuplate(item: items[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeAlbumsTableViewCell", for: indexPath)
        cell.selectionStyle = .none
        return cell
        
    }
    
    
}