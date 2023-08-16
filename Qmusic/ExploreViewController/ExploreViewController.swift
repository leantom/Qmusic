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

class ExploreViewController: UIViewController {

    @IBOutlet weak var tbView: UITableView!
    
    let fakeData = [FakeDataGeekchart(id: "01", name: "Nice For Wha", des: "Avinci Nhọ", image: "albums1"),
                    FakeDataGeekchart(id: "02", name: "Nice For Wha", des: "Avinci Nhọ", image: "albums2"),
                    FakeDataGeekchart(id: "03", name: "Nice For Wha", des: "Avinci Nhọ", image: "albums3"),
                    FakeDataGeekchart(id: "04", name: "Nice For Wha", des: "Avinci Nhọ", image: "albums4"),
                    FakeDataGeekchart(id: "05", name: "Nice For Wha", des: "Avinci Nhọ", image: "albums5")]
    
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
        
        self.tbView.register(UINib(nibName: "ExploreGeezChartTableViewCell", bundle: nil), forCellReuseIdentifier: "ExploreGeezChartTableViewCell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreGeezChartTableViewCell", for: indexPath) as! ExploreGeezChartTableViewCell
        
        cell.setupDataGeekChart(data: self.fakeData)
        cell.selectionStyle = .none
        return cell
    }
    
    
}
