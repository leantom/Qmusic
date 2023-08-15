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

    @IBAction func actionHome(_ sender: Any) {
        let btn = sender as! UIButton
        //btn.tintColor = UIColor(hexString: "8D92A3")
        btn.tintColor = UIColor(hexString: "CBFB5E")
        
    }
    
    @IBAction func actionExplore(_ sender: Any) {
        let btn = sender as! UIButton
        btn.tintColor = UIColor(hexString: "CBFB5E")
    }
    
    @IBAction func actionRadio(_ sender: Any) {
        let btn = sender as! UIButton
        btn.tintColor = UIColor(hexString: "CBFB5E")
    }
    
    @IBAction func actionAccount(_ sender: Any) {
        let btn = sender as! UIButton
        btn.tintColor = UIColor(hexString: "CBFB5E")
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


