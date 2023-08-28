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
    
    @IBOutlet weak var mainView: UIView!
    
    
    @IBOutlet weak var btnStartContraintWidth: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
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
        
        clContent.register(UINib(nibName: "SplashScreenCellCollectionViewFirstCell", bundle: nil), forCellWithReuseIdentifier: "cell1")
        
        clContent.register(UINib(nibName: "SplashScreenCellCollectionViewSecondCell", bundle: nil), forCellWithReuseIdentifier: "cell2")
        
        clContent.register(UINib(nibName: "SplashScreenCellCollectionViewThirdCell", bundle: nil), forCellWithReuseIdentifier: "cell3")
        
        
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
        return CGSizeMake(UIScreen.main.bounds.width, 912)
    }
    
    func isPrime(_ n: Int) -> Bool {
        guard n >= 2     else { return false }
        guard n != 2     else { return true  }
        guard n % 2 != 0 else { return false }
        return !stride(from: 3, through: Int(sqrt(Double(n))), by: 2).contains { n % $0 == 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SplashScreenCellCollectionViewCell else {return UICollectionViewCell()}
            cell.imgCell.setImageWithAnimation(image: UIImage(named: listImage[indexPath.row]))
            return cell
        }
        
        
        if indexPath.row == 2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as? SplashScreenCellCollectionViewSecondCell else {return UICollectionViewCell()}
            cell.imgSplash.setImageWithAnimation(image: UIImage(named: listImage[indexPath.row]))
            cell.lblTitle.text = titles[indexPath.row]
            cell.lblDesc.text = contents[indexPath.row]
            return cell
        }
        
        if isPrime(indexPath.row) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as? SplashScreenCellCollectionViewFirstCell else {return UICollectionViewCell()}
            cell.imgSplash.setImageWithAnimation(image: UIImage(named: listImage[indexPath.row]))
            cell.lblTitle.text = titles[indexPath.row]
            cell.lblDesc.text = contents[indexPath.row]
            return cell
        }
        
        if indexPath.row % 2 == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SplashScreenCellCollectionViewCell else {return UICollectionViewCell()}
            cell.imgCell.setImageWithAnimation(image: UIImage(named: listImage[indexPath.row]))
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell3", for: indexPath) as? SplashScreenCellCollectionViewThirdCell
        else {return UICollectionViewCell()}
        cell.imgSplash.setImageWithAnimation(image: UIImage(named: listImage[indexPath.row]))
        cell.lblTitle.text = titles[indexPath.row]
        cell.lblDesc.text = contents[indexPath.row]
        return cell
    }
    
    // MARK: --scrollViewDidScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        if let indexPath = clContent.indexPathForItem(at: scrollView.contentOffset),
           let cell = clContent.cellForItem(at: indexPath) {
            
            
            
            
        }
    }
    
    
    
}
