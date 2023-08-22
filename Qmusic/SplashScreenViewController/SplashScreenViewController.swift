//
//  SplashScreenViewController.swift
//  Qmusic
//
//  Created by QuangHo on 13/08/2023.
//

import UIKit
import CHIPageControl
import Lottie

class SplashScreenViewController: UIViewController {
    
    let listImage = ["splash_1", "splash_2", "splash_3", "splash_4", "splash_5", "splash_6"]
    let titles = ["Your Melody, Your Mood",
                  "Your Groove, Your Rules",
                  "Drown in Sound, Elevate Your Soul",
                  "Every Note, Every Emotion",
                  "Harmonize Your Day with Cyme",
                  "Discover, Stream, Repeat"
    ]
    
    let contents = ["Cyme Delivers the Soundtrack to Your Life",
                    "Cyme Customizes Your Music Experience.",
                    "Cyme Takes You on a Musical Journey.",
                    "Cyme Connects You to the Power of Music.",
                    "Where Rhythm Meets Routine.",
                    "Cyme Unlocks a World of Musical Exploration."
]
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var clContent: UICollectionView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var pageControlLedingContraint: NSLayoutConstraint!
    @IBOutlet weak var btnStartContraintWidth: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        pageControl.numberOfPages = titles.count
        let chiControl = CHIPageControlAji(frame: pageControl.frame)
        self.mainView.insertSubview(chiControl, at: 0)
    }

    @IBAction func actionStart(_ sender: Any) {
        // MARK: -- start transform sender
        self.btnStartContraintWidth.constant = 50
        self.btnStart.titleLabel?.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.btnStart.alpha = 0
            self.mainView.layoutIfNeeded()
        }, completion: { finished in
            if finished {
                self.mainView.addLoadingLotties(frame: self.btnStart.frame, name: "loading")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

                    if AppSetting.shared.getStatusLogin() {
                        let vc = HomeMasterViewController(nibName: "HomeMasterViewController", bundle: nil)
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc = LoginViewController(nibName: "LoginViewController", bundle: nil)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                            

                }
            }
            
        })
 

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.mainView.removeLotties()
        btnStartContraintWidth.constant = ConstantsUI.widthScreen - 80
        self.btnStart.alpha = 1
        self.btnStart.titleLabel?.alpha = 1
    }
    
    func setupCollectionView() {
        btnStartContraintWidth.constant = ConstantsUI.widthScreen - 80
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        clContent.collectionViewLayout = layout
        clContent.contentOffset = CGPoint(x: 0, y: 0)
        
        clContent.register(UINib(nibName: "SplashScreenCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        clContent.delegate = self
        clContent.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension SplashScreenViewController: UICollectionViewDataSource,
                                        UICollectionViewDelegate,
                                        UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(UIScreen.main.bounds.width, self.clContent.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SplashScreenCellCollectionViewCell else {return UICollectionViewCell()}
        cell.imgCell.image = UIImage(named: listImage[indexPath.row])

        return cell
    }
    
    // MARK: --scrollViewDidScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        if let indexPath = clContent.indexPathForItem(at: scrollView.contentOffset),
           let cell = clContent.cellForItem(at: indexPath) {
            
            pageControl.currentPage = indexPath.row
            lblTitle.text = titles[indexPath.row]
            lblDesc.text = contents[indexPath.row]
            
            
        }
    }
    
    func animationMoveCenterTitleAndDesc() {
        self.pageControlLedingContraint.constant = 40
        
        UIView.transition(with: self.lblTitle, duration: 0.3) {
            self.lblTitle.textAlignment = .center
        }
        UIView.transition(with: self.lblDesc, duration: 0.3) {
            self.lblDesc.textAlignment = .center
        }
        
        
        UIView.animate(withDuration: 0.3) {
            self.pageControl.layoutIfNeeded()
        }
        
    }
    
    func animationMoveLeadingTitleAndDesc() {
        self.pageControlLedingContraint.constant = 0
        UIView.transition(with: self.lblTitle, duration: 0.3) {
            self.lblTitle.textAlignment = .left
        }
        UIView.transition(with: self.lblDesc, duration: 0.3) {
            self.lblDesc.textAlignment = .left
        }
        
        UIView.animate(withDuration: 0.3) {
            
            self.pageControl.layoutIfNeeded()
        }
        
    }
    
    
}
