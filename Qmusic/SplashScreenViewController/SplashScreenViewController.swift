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
    
    @IBOutlet weak var btnStartContraintWidth: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        pageControl.numberOfPages = titles.count
        let chiControl = CHIPageControlAji(frame: pageControl.frame)
        self.mainView.insertSubview(chiControl, at: 0)
    }

    @IBAction func actionStart(_ sender: Any) {
//        let vc = LoginViewController(nibName: "LoginViewController", bundle: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
//
  // transform sender
        self.btnStartContraintWidth.constant = 50
        self.btnStart.titleLabel?.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.btnStart.alpha = 0
            self.mainView.layoutIfNeeded()
        }, completion: { finished in
            if finished {
                self.mainView.addLoadingLotties(frame: self.btnStart.frame, name: "loading")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let vc = HomeMasterViewController(nibName: "HomeMasterViewController", bundle: nil)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        })
 

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
//        if let image = cell.imgCell.image {
//            let primaryColor = image.getPrimaryColor()
//            cell.primaryColor = primaryColor
//            collectionView.backgroundColor = primaryColor
//
//        }
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
    
    
}
