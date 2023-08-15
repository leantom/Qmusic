//
//  SplashScreenViewController.swift
//  Qmusic
//
//  Created by QuangHo on 13/08/2023.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    let listImage = ["splash_1", "splash_2", "splash_3"]
    
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var clContent: UICollectionView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var lblDesc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clContent.register(UINib(nibName: "SplashScreenCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        clContent.delegate = self
        clContent.dataSource = self
        
        
    }

    @IBAction func actionStart(_ sender: Any) {
//        let vc = LoginViewController(nibName: "LoginViewController", bundle: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
//
        
        let vc = HomeMasterViewController(nibName: "HomeMasterViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        clContent.collectionViewLayout = layout
        clContent.contentOffset = CGPoint(x: 0, y: 0)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension SplashScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SplashScreenCellCollectionViewCell else {return UICollectionViewCell()}
        cell.imgCell.image = UIImage(named: listImage[indexPath.row])
        return cell
    }
    
    
}
