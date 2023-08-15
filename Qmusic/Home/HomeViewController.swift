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
    let headerTitles = ["New Albums", "Cyme Weekly"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tbContent.register(UINib(nibName: "HomeWeeklyTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeWeeklyTableViewCell")
        
        tbContent.register(UINib(nibName: "HomeAlbumsTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeAlbumsTableViewCell")
        tbContent.delegate = self
        tbContent.dataSource = self
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
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: ConstantsUI.widthScreen, height: 26))
        label.text = headerTitles[section]
        label.textColor = .white
        label.font = UIFont(name: "Roboto-Bold", size: 22)
        return label
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeWeeklyTableViewCell", for: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeAlbumsTableViewCell", for: indexPath)
        return cell
        
    }
    
    
}
