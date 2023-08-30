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
    
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var clContent: UICollectionView!
    
    @IBOutlet weak var mainView: UIView!
    var cymeButton: CymeButton {
        let v = CymeButton.instantiate()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.delegate = self
        return v
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
       
    }

    @IBAction func actionStart(_ sender: Any) {
        // MARK: -- start transform sender
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.mainView.layoutIfNeeded()
        }, completion: { finished in
            if finished {
                
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
        
        viewButton.addSubViewFullConstraint(sub: cymeButton)
        viewButton.layoutIfNeeded()
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.mainView.removeLotties()
        
    }
    
    func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: -59, left: 0, bottom: -60, right: 0)
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
        return CGSizeMake(UIScreen.main.bounds.width, collectionView.frame.height + 59)
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
            cell.pageControl.numberOfPages = listImage.count
            return cell
        }
        
        
        if indexPath.row == 2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as? SplashScreenCellCollectionViewSecondCell else {return UICollectionViewCell()}
            cell.imgSplash.setImageWithAnimation(image: UIImage(named: listImage[indexPath.row]))
            cell.lblTitle.text = titles[indexPath.row]
            cell.lblDesc.text = contents[indexPath.row]
            cell.pageControl.numberOfPages = listImage.count
            return cell
        }
        
        if isPrime(indexPath.row) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as? SplashScreenCellCollectionViewFirstCell else {return UICollectionViewCell()}
            cell.imgSplash.setImageWithAnimation(image: UIImage(named: listImage[indexPath.row]))
            cell.lblTitle.text = titles[indexPath.row]
            cell.lblDesc.text = contents[indexPath.row]
            cell.pageControl.numberOfPages = listImage.count
            return cell
        }
        
        if indexPath.row % 2 == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SplashScreenCellCollectionViewCell else {return UICollectionViewCell()}
            cell.imgCell.setImageWithAnimation(image: UIImage(named: listImage[indexPath.row]))
            cell.pageControl.numberOfPages = listImage.count
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell3", for: indexPath) as? SplashScreenCellCollectionViewThirdCell
        else {return UICollectionViewCell()}
        cell.imgSplash.setImageWithAnimation(image: UIImage(named: listImage[indexPath.row]))
        cell.lblTitle.text = titles[indexPath.row]
        cell.lblDesc.text = contents[indexPath.row]
        cell.pageControl.numberOfPages = listImage.count
        return cell
    }
    
    // MARK: --scrollViewDidScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        if let indexPath = clContent.indexPathForItem(at: scrollView.contentOffset),
           let cell = clContent.cellForItem(at: indexPath) {
            
            if cell is SplashScreenCellCollectionViewCell {
                (cell as! SplashScreenCellCollectionViewCell).pageControl.currentPage = indexPath.row
            }
            
            if cell is SplashScreenCellCollectionViewThirdCell {
                (cell as! SplashScreenCellCollectionViewThirdCell).pageControl.currentPage = indexPath.row
            }
            
            if cell is SplashScreenCellCollectionViewFirstCell {
                (cell as! SplashScreenCellCollectionViewFirstCell).pageControl.currentPage = indexPath.row
            }
            
            if cell is SplashScreenCellCollectionViewSecondCell {
                (cell as! SplashScreenCellCollectionViewSecondCell).pageControl.currentPage = indexPath.row
            }
    
            
            
        }
    }
    
    
    
}
extension SplashScreenViewController: CymeButtonDelegate {
    func actionSelect(btn: UIButton) {
        if AppSetting.shared.getStatusLogin() {
            let vc = HomeMasterViewController.loadFromNib()
            self.navigationController?.push(destinVC: vc)
        } else {
            let vc = LoginViewController.loadFromNib()
            self.navigationController?.push(destinVC: vc)
        }
    }
    
    
}
