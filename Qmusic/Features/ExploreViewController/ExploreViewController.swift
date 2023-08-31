//
//  ExploreViewController.swift
//  Qmusic
//
//  Created by Macbook on 8/14/23.
//

import UIKit

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
    
    let fakeDataGeekCharts = [FakeDataGeekchart(id: "01", name: "Nice For Wha", des: "Avinci Nhọ", image: "albums1"),
                    FakeDataGeekchart(id: "02", name: "Nice For Wha", des: "Avinci Nhọ", image: "albums2"),
                    FakeDataGeekchart(id: "03", name: "Nice For Wha", des: "Avinci Nhọ", image: "albums3"),
                    FakeDataGeekchart(id: "04", name: "Nice For Wha", des: "Avinci Nhọ", image: "albums4"),
                    FakeDataGeekchart(id: "05", name: "Nice For Wha", des: "Avinci Nhọ", image: "albums5")]
    
    let dataTopic = [FakeDataTopic(name: "Help", image: "albums1"),
                FakeDataTopic(name: "Me", image: "albums2"),
                FakeDataTopic(name: "Bro", image: "albums3"),
                FakeDataTopic(name: "LC-D", image: "albums4"),
                FakeDataTopic(name: "WTF-R", image: "albums5"),
                FakeDataTopic(name: "SWIFT-QMUSIC", image: "albums6"),
                FakeDataTopic(name: "BestApp", image: "albums7"),
                FakeDataTopic(name: "Hihu", image: "albums8")]
    
    let fakeSection = [FakeSectonExplore(title: "Geez Chart", button: "ViewAll"),
                       FakeSectonExplore(title: "Top Trending", button: ""),
                       FakeSectonExplore(title: "Topic", button: "ViewAll")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }
    
    func initUI(){
        self.tbView.delegate = self
        self.tbView.dataSource = self
        self.tbView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.registerCell()
    }
    
    func registerCell(){
        self.tbView.register(UINib(nibName: "ExploreGeezChartTableViewCell", bundle: nil), forCellReuseIdentifier: "ExploreGeezChartTableViewCell")
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        let type = TypeOfExploreSection(rawValue: indexPath.section) ?? .GeekChart
        switch type {
        case .GeekChart:
            cell = (tableView.dequeueReusableCell(withIdentifier: "ExploreGeezChartTableViewCell", for: indexPath) as! ExploreGeezChartTableViewCell)
            if let geek = cell as? ExploreGeezChartTableViewCell{
                geek.setupDataGeekChart(data: self.fakeDataGeekCharts)
            }
        case .TopTrending:
            cell = tableView.dequeueReusableCell(withIdentifier: "ExploreTopTrendingTableViewCell", for: indexPath) as! ExploreTopTrendingTableViewCell
        case .Topic:
            cell = tableView.dequeueReusableCell(withIdentifier: "ExploreTopicTableViewCell", for: indexPath) as! ExploreTopicTableViewCell
            if let topic = cell as? ExploreTopicTableViewCell{
                topic.setDataTopic(self.dataTopic)
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
}
