//
//  HomeMasterViewController.swift
//  Qmusic
//
//  Created by QuangHo on 14/08/2023.
//

import UIKit
enum TypeMenuBottomHome {
    case Home
    case Explore
    case Radio
    case Account
}

class HomeMasterViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    var homeVC : HomeViewController?
    var exploreVC: ExploreViewController?
    var currentType: TypeMenuBottomHome = .Home
    
    @IBOutlet weak var btnHome: UIButton!
    
    @IBOutlet weak var btnExplore: UIButton!
    
    @IBOutlet weak var btnRadio: UIButton!
    
    @IBOutlet weak var btnAccount: UIButton!
    var listBtnHome : [UIButton] = []
    
    @IBOutlet weak var heightContraintMusicBar: NSLayoutConstraint!
    @IBOutlet weak var musicBarContainView: UIView!
    var musicBar: MusicBarView = {
        let v = MusicBarView.instantiate()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        if let viewHome = homeVC?.view {
            viewHome.frame = contentView.bounds
            contentView.addSubview(viewHome)
        }
        listBtnHome.append(btnHome)
        listBtnHome.append(btnExplore)
        listBtnHome.append(btnRadio)
        listBtnHome.append(btnAccount)
        musicBarContainView.addSubview(musicBar)
        musicBar.layoutAttachAll()
    }

    @IBAction func actionHome(_ sender: Any) {
        listBtnHome.forEach { btn in
            btn.tintColor = UIColor(hexString: "8D92A3")
        }
        if currentType == .Home {return}
        
        currentType = .Home
        let btn = sender as! UIButton
        
        btn.tintColor = UIColor(hexString: "CBFB5E")
        
        if let view = exploreVC?.view {
            view.removeFromSuperview()
        }
        
        homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        if let viewHome = homeVC?.view {
            viewHome.frame = contentView.bounds
            contentView.addSubview(viewHome)
        }
    }
    
    @IBAction func actionExplore(_ sender: Any) {
        
        if currentType == .Explore {return}
        currentType = .Explore
        listBtnHome.forEach { btn in
            btn.tintColor = UIColor(hexString: "8D92A3")
        }
        let btn = sender as! UIButton
        btn.tintColor = UIColor(hexString: "CBFB5E")
        if let view = homeVC?.view {
            view.removeFromSuperview()
        }
        
        exploreVC = ExploreViewController(nibName: "ExploreViewController", bundle: nil)
        if let viewHome = exploreVC?.view {
            viewHome.frame = contentView.bounds
            contentView.addSubview(viewHome)
        }
        
    }
    
    @IBAction func actionRadio(_ sender: Any) {
        if currentType == .Radio {return}
        listBtnHome.forEach { btn in
            btn.tintColor = UIColor(hexString: "8D92A3")
        }
        currentType = .Radio
        let btn = sender as! UIButton
        btn.tintColor = UIColor(hexString: "CBFB5E")
    }
    
    @IBAction func actionAccount(_ sender: Any) {
        if currentType == .Account {return}
        listBtnHome.forEach { btn in
            btn.tintColor = UIColor(hexString: "8D92A3")
        }
        currentType = .Account
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


