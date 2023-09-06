//
//  ArtistViewController.swift
//  Qmusic
//
//  Created by QuangHo on 04/09/2023.
//

import UIKit
enum ArtistSectionType: Int {
    case Info = 0
    case Song = 1
    case Album = 2
    
    var description: String {
        switch self {
        case .Info:
            return ""
        case .Album:
            return "Album"
        case .Song:
            return "Song"
        }
    }
}
class ArtistViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var tbContent: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        tbContent.delegate = self
        tbContent.dataSource = self
        
        tbContent.register(UINib(nibName: "AlbumArtistCell", bundle: nil), forCellReuseIdentifier: "AlbumArtistCell")
        
        
        tbContent.register(UINib(nibName: "RecentlyMusicTableViewCell", bundle: nil), forCellReuseIdentifier: "RecentlyMusicTableViewCell")
        
        tbContent.register(UINib(nibName: "HeaderArtistDetailView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderArtistDetailView")
        
       
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.pop()
    }
    

  

}
extension ArtistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = ArtistSectionType(rawValue: section) else {return nil}
        
        
        switch sectionType {
        case .Info:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderArtistDetailView") as! HeaderArtistDetailView
           
            return header
            
        case .Song, .Album:
            let sectionHeader = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            
            let homeHeaderView = HomeHeaderView.instantiate()
            
            if section != 0 {
                homeHeaderView.btnViewAll.isHidden = true
            }
            sectionHeader.addSubview(homeHeaderView)
            homeHeaderView.layoutAttachAll()
            return sectionHeader
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = ArtistSectionType(rawValue: section) else {return 0}
        switch sectionType {
        case .Info:
            return 0
        case .Song:
            return 5
        case .Album:
            return 1
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = ArtistSectionType(rawValue: indexPath.section) else {return UITableViewCell()}
        switch sectionType {
        case .Info:
            return UITableViewCell()
        case .Song:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentlyMusicTableViewCell", for: indexPath)
            return cell
        case .Album:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumArtistCell", for: indexPath)
            return cell
        }
    }
    
}
