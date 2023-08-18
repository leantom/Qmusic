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
    var radioVC: RadioViewController?
    var accountVC: AccountViewController?
    
    var currentType: TypeMenuBottomHome = .Home
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnHome: UIButton!
    
    @IBOutlet weak var btnExplore: UIButton!
    
    @IBOutlet weak var btnRadio: UIButton!
    
    @IBOutlet weak var btnAccount: UIButton!
    var listBtnHome : [UIButton] = []
    
    @IBOutlet weak var bottomContraintContainView: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
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
        self.addChild(homeVC!)
        exploreVC = ExploreViewController(nibName: "ExploreViewController", bundle: nil)
        self.addChild(exploreVC!)
        radioVC = RadioViewController(nibName: "RadioViewController", bundle: nil)
        self.addChild(radioVC!)
        accountVC = AccountViewController(nibName: "AccountViewController", bundle: nil)
        self.addChild(accountVC!)
        
        homeVC?.delegate = self
        
        if let viewHome = accountVC?.view {
            viewHome.frame = contentView.bounds
            contentView.addSubview(viewHome)
            viewHome.layoutAttachAll()
        }
        
        if let viewHome = radioVC?.view {
            viewHome.frame = contentView.bounds
            contentView.addSubview(viewHome)
            viewHome.layoutAttachAll()
        }
        
        if let viewHome = exploreVC?.view {
            viewHome.frame = contentView.bounds
            contentView.addSubview(viewHome)
            viewHome.layoutAttachAll()
        }
        
        if let viewHome = homeVC?.view {
            viewHome.frame = contentView.bounds
            contentView.addSubview(viewHome)
            viewHome.layoutAttachAll()
        }
        
        
        
        listBtnHome.append(btnHome)
        listBtnHome.append(btnExplore)
        listBtnHome.append(btnRadio)
        listBtnHome.append(btnAccount)
        musicBarContainView.addSubview(musicBar)
        musicBar.layoutAttachAll()
        self.heightContraintMusicBar.constant = 0
    }

    @IBAction func actionHome(_ sender: Any) {
        if currentType == .Home {return}
        
        setupMenuBottom(type: .Home, btn: sender as! UIButton)
        lblTitle.text = "Cyme"
        if let viewHome = self.homeVC?.view {
            contentView.bringSubviewToFront(viewHome)
            viewHome.alpha = 0
        }
        UIView.animate(withDuration: 0.3) {
            if let viewHome = self.homeVC?.view {
                viewHome.alpha = 1
            }
        }
    }
    
    @IBAction func actionExplore(_ sender: Any) {
        if currentType == .Explore {return}
        setupMenuBottom(type: .Explore, btn: sender as! UIButton)
        lblTitle.text = "Explore"
        if let viewHome = exploreVC?.view {
            contentView.bringSubviewToFront(viewHome)
            viewHome.alpha = 0
        }
        
        UIView.animate(withDuration: 0.3) {
            if let viewHome = self.exploreVC?.view {
                viewHome.alpha = 1
            }
        }
        
    }
    
    @IBAction func actionRadio(_ sender: Any) {
        if currentType == .Radio {return}
        setupMenuBottom(type: .Radio, btn: sender as! UIButton)
        lblTitle.text = "PodCast"
        if let viewHome = radioVC?.view {
            contentView.bringSubviewToFront(viewHome)
            viewHome.alpha = 0
        }
        
        UIView.animate(withDuration: 0.3) {
            if let viewHome = self.radioVC?.view {
                viewHome.alpha = 1
            }
        }
        
    }
    
    @IBAction func actionAccount(_ sender: Any) {
        if currentType == .Account {return}
        setupMenuBottom(type: .Account, btn: sender as! UIButton)
        lblTitle.text = "Account"
        if let viewHome = accountVC?.view {
            contentView.bringSubviewToFront(viewHome)
            viewHome.alpha = 0
        }
        
        UIView.animate(withDuration: 0.3) {
            if let viewHome = self.accountVC?.view {
                viewHome.alpha = 1
            }
        }
        
        
    }
    
    func setupMenuBottom(type: TypeMenuBottomHome,
                         btn: UIButton) {
        if currentType == type {return}
        listBtnHome.forEach { btn in
            btn.tintColor = UIColor(hexString: "8D92A3")
        }
        currentType = type
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


extension HomeMasterViewController: HomeViewControllerDelegate {
    func didSelectRecentlySong(indexPath: IndexPath, item: Item) {
        musicBar.populate(item: item)
        self.heightContraintMusicBar.constant = 65
        bottomContraintContainView.constant = 65
        UIView.animate(withDuration: 0.3) {
            self.mainView.layoutIfNeeded()
        }
    }
}
