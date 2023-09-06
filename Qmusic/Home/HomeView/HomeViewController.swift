//
//  HomeViewController.swift
//  Qmusic
//
//  Created by QuangHo on 14/08/2023.
//

import UIKit
import RxSwift
protocol HomeViewControllerDelegate: AnyObject {
    func didSelectRecentlySong(indexPath: IndexPath, item: HomePage.Items)
}

class HomeViewController: UIViewController {

    enum SectionHeader: Int {
        case SpotifyChoice = 1
        case Charts = 2
        case PianoPeaceful = 3
        case Mood = 4
        case Popular_new_releases = 5
        var describle: String {
            switch self {
                
            case .SpotifyChoice:
                return "Lựa chọn của Spotify"
            case .Charts:
                return "Charts"
            case .PianoPeaceful:
                return "Peaceful Piano"
            case .Mood:
                return "Mood"
            case .Popular_new_releases:
                return "Popular new releases"
            }
        }
    }
    
    
    // tableview
    // title section
    // section 1: - collectionview
    // section 2: avplayer
    // section 3: recently music
    // mainView
    
    @IBOutlet weak var tbContent: UITableView!
    
    var headerSections:[SectionHeader] = []
    weak var delegate: HomeViewControllerDelegate?
     
    @IBOutlet var header1: UIView!
    
    @IBOutlet weak var lblHeaderTitle1: UILabel!
    
    @IBOutlet var header2: UIView!
    
    @IBOutlet weak var lblHeaderTitle2: UILabel!
    
    var isSelectedSong = false
    var homePageModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tbContent.register(UINib(nibName: "HomeWeeklyTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeWeeklyTableViewCell")
        
        tbContent.register(UINib(nibName: "HomeAlbumsTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeAlbumsTableViewCell")
        
        tbContent.register(UINib(nibName: "RecentlyMusicTableViewCell", bundle: nil), forCellReuseIdentifier: "RecentlyMusicTableViewCell")
        
        tbContent.delegate = self
        tbContent.dataSource = self
        
        setupRx()
        
    }


    func setupRx() {
        homePageModel.getHomePage()
        if let data = AppSetting.shared.getHomeDataFromLocal() {
            headerSections.append(.SpotifyChoice)
            headerSections.append(.Charts)
            headerSections.append(.PianoPeaceful)
            headerSections.append(.Mood)
            headerSections.append(.Popular_new_releases)
            tbContent.reloadData()
        }
        homePageModel.output.SpotifysChoice.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                headerSections.append(.SpotifyChoice)
            })
            .disposed(by: homePageModel.disposeBag)
        
        homePageModel.output.charts.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                headerSections.append(.Charts)
            })
            .disposed(by: homePageModel.disposeBag)
        
        homePageModel.output.pianoAlbums.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                headerSections.append(.PianoPeaceful)
                headerSections.append(.Mood)
                headerSections.append(.Popular_new_releases)
                tbContent.reloadData()
            })
            .disposed(by: homePageModel.disposeBag)
        
        homePageModel.output.playlistDetail.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                if let playlist = homePageModel.getPlaylistSeleted() {
                    let vc = PlaylistDetailViewController(playlistDetail: value, playlist: playlist)
                    self.navigationController?.push(destinVC: vc)
                }
                
            })
            .disposed(by: homePageModel.disposeBag)
        
    }
    
    func showPlaylistDetailVC() {
        if let playlist = homePageModel.getPlaylistSeleted() {
            let vc = PlaylistDetailViewController(playlist: playlist)
            self.navigationController?.push(destinVC: vc)
        }
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
        
        homeHeaderView.lblTitle.text = headerSections[section].describle
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let headerSection = headerSections[indexPath.section]
        switch headerSection {
        case .SpotifyChoice:
            return tableView.estimatedRowHeight
        case .Charts:
            return 220
        default:
            return 83
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let headerSection = headerSections[section]
        switch headerSection {
            
        case .SpotifyChoice:
            return 1
        case .Charts:
            return 1
        case .PianoPeaceful:
            return homePageModel.getpianoAlbums().count
        case .Mood:
            return homePageModel.getmoodPlaylist().count
        case .Popular_new_releases:
            return homePageModel.getpopularNewRelease().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let headerSection = headerSections[indexPath.section]
        switch headerSection {
            
        case .SpotifyChoice:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeWeeklyTableViewCell", for: indexPath) as! HomeWeeklyTableViewCell
            cell.items = homePageModel.getSpotifyItems()
            cell.homePageModel = self.homePageModel
            cell.parentVC = self
            cell.selectionStyle = .none
            return cell
        case .Charts:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeAlbumsTableViewCell", for: indexPath) as! HomeAlbumsTableViewCell
            cell.parentVC = self
            if let chart = homePageModel.getChart() {
                cell.setupData(items: chart)
            }
            
            cell.selectionStyle = .none
            return cell
        case .PianoPeaceful:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentlyMusicTableViewCell", for: indexPath) as! RecentlyMusicTableViewCell
            cell.popuplate(item: homePageModel.getpianoAlbums()[indexPath.row], index: indexPath.row)
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .Mood:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentlyMusicTableViewCell", for: indexPath) as! RecentlyMusicTableViewCell
            cell.popuplate(item: homePageModel.getmoodPlaylist()[indexPath.row], index: indexPath.row)
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case .Popular_new_releases:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentlyMusicTableViewCell", for: indexPath) as! RecentlyMusicTableViewCell
            cell.popuplate(item: homePageModel.getpopularNewRelease()[indexPath.row], index: indexPath.row)
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        isSelectedSong = true
        let headerSection = headerSections[indexPath.section]
        switch headerSection {
        case .SpotifyChoice:
            break
        case .Charts:
            break
        case .PianoPeaceful:
            let item = homePageModel.getpianoAlbums()[indexPath.row]
            homePageModel.setPlaylistSeleted(item: item)
            if let itemID = item.id {
                homePageModel.getPlaylistDetail(id: itemID)
            }
            
            break
        case .Mood:
            let item = homePageModel.getmoodPlaylist()[indexPath.row]
            homePageModel.setPlaylistSeleted(item: item)
            self.showPlaylistDetailVC()
           
            
            break
        case .Popular_new_releases:
            let item = homePageModel.getpopularNewRelease()[indexPath.row]
            homePageModel.setPlaylistSeleted(item: item)
            self.showPlaylistDetailVC()
            
            break
        }
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
