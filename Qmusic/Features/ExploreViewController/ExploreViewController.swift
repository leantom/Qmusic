//
//  ExploreViewController.swift
//  Qmusic
//
//  Created by Macbook on 8/14/23.
//

import UIKit
import RxSwift

struct FakeSectonExplore{
    var title: String
    var button: String
}

enum TypeOfExploreSection: Int{
    case GeekChart = 0
    case TopTrending
    case Topic
}

class ExploreViewController: UIViewController {

    @IBOutlet weak var tbView: UITableView!
    var homePageViewModel: HomeViewModel?
    
    let fakeDataGeekCharts = [FakeDataGeekchart(id: "01", name: "Nice For Wha", des: "Avinci Nhọ", image: "albums1"),
                    FakeDataGeekchart(id: "02", name: "Nice For Wha", des: "Avinci Nhọ", image: "albums2"),
                    FakeDataGeekchart(id: "03", name: "Nice For Wha", des: "Avinci Nhọ", image: "albums3"),
                    FakeDataGeekchart(id: "04", name: "Nice For Wha", des: "Avinci Nhọ", image: "albums4"),
                    FakeDataGeekchart(id: "05", name: "Nice For Wha", des: "Avinci Nhọ", image: "albums5")]
    
    let fakeSection = [FakeSectonExplore(title: "Cyme Chart", button: ""),
                       FakeSectonExplore(title: "Xu hướng", button: ""),
                       FakeSectonExplore(title: "Thể loại", button: "")]
    var trendingCell : ExploreTopTrendingTableViewCell?
    var indexPathSelected: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.setupRx()
    }
    
    func initUI(){
        self.tbView.delegate = self
        self.tbView.dataSource = self
        self.tbView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.registerCell()
    }
    
    func setupRx() {
        self.homePageViewModel = HomeViewModel()
        guard let homePageViewModel = self.homePageViewModel else {return}
        homePageViewModel.getTrending()
        homePageViewModel.getChartIntoDBNotSpotify()
        
        homePageViewModel.output.trendingDetail.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
               print(value)
                if let trendingCell = self.trendingCell {
                    trendingCell.data = homePageViewModel.getItemsInTrending()
                }
            })
            .disposed(by: homePageViewModel.disposeBag)
        
        homePageViewModel.output.chartByDB.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.tbView.reloadData()
            })
            .disposed(by: homePageViewModel.disposeBag)
        
        homePageViewModel.output.songdetail.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                MusicHelper.sharedHelper.playMusicWithArtist(link: value.soundcloudTrack?.audio?.first?.url ?? "",
                                                             with: indexPathSelected?.row ?? 0,
                                                             with: homePageViewModel.getTotalTrackInChart())
                
            })
            .disposed(by: homePageViewModel.disposeBag)
        
        
    }
    
    func registerCell(){
        self.tbView.register(UINib(nibName: "RecentlyMusicTableViewCell", bundle: nil), forCellReuseIdentifier: "RecentlyMusicTableViewCell")
        
        self.tbView.register(UINib(nibName: "ExploreTopTrendingTableViewCell", bundle: nil), forCellReuseIdentifier: "ExploreTopTrendingTableViewCell")
        
        self.tbView.register(UINib(nibName: "ExploreTopicTableViewCell", bundle: nil), forCellReuseIdentifier: "ExploreTopicTableViewCell")
    }

}

extension ExploreViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let sectionHeader = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let headerView = ExploreGeezChartHeaderTableView.instantiate()
        let data = self.fakeSection[section]
        headerView.setupData(title: data.title, button: data.button)
        sectionHeader.addSubview(headerView)
        headerView.layoutAttachAll()
        return sectionHeader
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fakeSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let homePageViewModel = self.homePageViewModel else {return 0}
        let type = TypeOfExploreSection(rawValue: section) ?? .GeekChart
        switch type {
        case .GeekChart:
            return homePageViewModel.getItemsInChart()
        case .TopTrending:
            return 1
        case .Topic:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        let type = TypeOfExploreSection(rawValue: indexPath.section) ?? .GeekChart
        switch type {
        case .GeekChart:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentlyMusicTableViewCell", for: indexPath) as! RecentlyMusicTableViewCell
            guard let homePageViewModel = self.homePageViewModel else {return cell}
            guard let item = homePageViewModel.getItemChart(by: indexPath.row) else {return cell}
            cell.popuplate(with: item, index: indexPath.row)
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case .TopTrending:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreTopTrendingTableViewCell", for: indexPath) as! ExploreTopTrendingTableViewCell
            trendingCell = cell
            return cell
        case .Topic:
            cell = tableView.dequeueReusableCell(withIdentifier: "ExploreTopicTableViewCell", for: indexPath) as! ExploreTopicTableViewCell
            if let topic = cell as? ExploreTopicTableViewCell,
               let homePageViewModel = self.homePageViewModel {
                topic.setDataTopic(homePageViewModel.getTopics())
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = TypeOfExploreSection(rawValue: indexPath.section) ?? .GeekChart
        switch type {
        case .GeekChart:
            print("GeekChart")
            if let track = homePageViewModel?.getItemChart(by: indexPath.row) {
                homePageViewModel?.getSongDetail(id: track.id ?? "")
            }
            indexPathSelected = indexPath
        case .TopTrending:
            print("TopTrending")
        case .Topic:
            print("topic")
        }
    }
    
}
extension ExploreViewController: RecentlyMusicTableViewCellDelegate {
    func didSelectShowDetail(cell: RecentlyMusicTableViewCell) {
        if let song = cell.songSelectedInChart {
            let vc = ShareScreenViewController(songInChart: song)
            self.navigationController?.push(destinVC: vc)
        }
        
    }
}
