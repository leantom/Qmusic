//
//  ExploreViewController.swift
//  Qmusic
//
//  Created by Macbook on 8/14/23.
//

import UIKit

class ExploreViewController: UIViewController {

    @IBOutlet weak var tbView: UITableView!
    
    let fakeData = [FakeDataGeekchart(id: "01", name: "", des: "", image: ""),
                    FakeDataGeekchart(id: "01", name: "", des: "", image: ""),
                    FakeDataGeekchart(id: "01", name: "", des: "", image: ""),
                    FakeDataGeekchart(id: "01", name: "", des: "", image: ""),
                    FakeDataGeekchart(id: "01", name: "", des: "", image: "")]
    
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreGeezChartTableViewCell", for: indexPath) as! ExploreGeezChartTableViewCell
        
        cell.setupDataGeekChart(data: self.fakeData)
        return cell
    }
    
    
}
