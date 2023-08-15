//
//  HomeMasterViewController.swift
//  Qmusic
//
//  Created by QuangHo on 14/08/2023.
//

import UIKit

class HomeMasterViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    var homeVC : HomeViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        if let viewHome = homeVC?.view {
            contentView.addSubview(viewHome)
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
