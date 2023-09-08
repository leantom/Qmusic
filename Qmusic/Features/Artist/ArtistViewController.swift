//
//  ArtistViewController.swift
//  Qmusic
//
//  Created by QuangHo on 04/09/2023.
//

import UIKit
import RxSwift

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
    
    var idArtist = ""
    var artistViewModel: ArtistViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    convenience init(id: String) {
        self.init(nibName: "ArtistViewController", bundle: nil)
        self.idArtist = id
        artistViewModel = ArtistViewModel(id: id)
    }
    
    func setupUI() {
        tbContent.delegate = self
        tbContent.dataSource = self
        
        tbContent.register(UINib(nibName: "AlbumArtistCell", bundle: nil), forCellReuseIdentifier: "AlbumArtistCell")
        
        
        tbContent.register(UINib(nibName: "RecentlyMusicTableViewCell", bundle: nil), forCellReuseIdentifier: "RecentlyMusicTableViewCell")
        
        tbContent.register(UINib(nibName: "HeaderArtistDetailView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderArtistDetailView")
        
        tbContent.register(UINib(nibName: "HomeHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HomeHeaderView")
        
        setupRx()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.pop()
    }
    
    func setupRx() {
        artistViewModel?.output.artisDetail.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.tbContent.reloadData()
            })
            .disposed(by: artistViewModel!.disposeBag)
    }
  

}
extension ArtistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = ArtistSectionType(rawValue: section) else {return nil}
        
        
        switch sectionType {
        case .Info:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderArtistDetailView") as! HeaderArtistDetailView
            if let artist = artistViewModel?.artistDetail {
                header.setupData(item: artist)
            }
            
            return header
            
        case .Song, .Album:
            guard let sectionType = ArtistSectionType(rawValue: section) else {return nil}
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeHeaderView") as! HomeHeaderView
            header.lblTitle.text = sectionType.description
            header.btnViewAll.isHidden = true
            return header
            
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = ArtistSectionType(rawValue: section) else {return 0}
        switch sectionType {
        case .Info:
            return 0
        case .Song:
            return artistViewModel?.topTracks.count ?? 0
        case .Album:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sectionType = ArtistSectionType(rawValue: indexPath.section) else {return 0}
        switch sectionType {
        case .Info, .Song:
            return tableView.estimatedRowHeight
        case .Album:
            return 90
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentlyMusicTableViewCell", for: indexPath) as! RecentlyMusicTableViewCell
            if let track = self.artistViewModel?.topTracks[indexPath.row] {
                cell.popuplate(with: track, index: indexPath.row)
            }
            cell.selectionStyle = .none
            return cell
        case .Album:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumArtistCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }
    }
    
}
