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
    
    
    
    let fakeSection = [FakeSectonExplore(title: "Cyme Chart", button: ""),
                       FakeSectonExplore(title: "Trending", button: ""),
                       FakeSectonExplore(title: "Thể loại", button: "")]
    var dataTrending: Trending_DataResult?
    var dataChart: Trending_DataResult?
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
        let callData = DispatchGroup()
        
        callData.enter()
        homePageViewModel.getTrending {
            callData.leave()
        }
        
        callData.enter()
        homePageViewModel.getExploreChart {
            callData.leave()
        }
        
        callData.notify(queue: .main, execute: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                guard let self = self else {return}
                self.tbView.reloadData()
            }
        })
        
        homePageViewModel.output.trendingDetail.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.dataTrending = value
            })
            .disposed(by: homePageViewModel.disposeBag)
        
        homePageViewModel.output.chartDetail.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.dataChart = value
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
            let cell = (tableView.dequeueReusableCell(withIdentifier: "RecentlyMusicTableViewCell", for: indexPath) as! RecentlyMusicTableViewCell)
            if let toptrack = self.homePageViewModel?.getItemChart(by: indexPath.row) {
                cell.popuplate(with: toptrack, index: indexPath.row)
            }
            cell.selectionStyle = .none
            return cell
        case .TopTrending:
            cell = tableView.dequeueReusableCell(withIdentifier: "ExploreTopTrendingTableViewCell", for: indexPath) as! ExploreTopTrendingTableViewCell
            if let trending = cell as? ExploreTopTrendingTableViewCell , let data = self.dataTrending {
                trending.setDataChart(data)
            }
            
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
