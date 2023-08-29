//
//  WEExtensions+UIImageView.swift
//  facepay_v3
//
//  Created by LV on 11/2/20.
//

import Foundation
import UIKit
import Lottie

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
            contentMode = mode
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() { [weak self] in
                    self?.image = image
                }
            }.resume()
        }
        func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
            guard let url = URL(string: link) else { return }
            downloaded(from: url, contentMode: mode)
        }
    
    
    func setImageWithAnimation(image: UIImage?) {
        
        UIView.transition(with: self, duration: 0.3, options: [.transitionCrossDissolve]) {
            self.image = image
        } completion: { finished in
            
        }

    }
    
}

func createViewLotties(frame: CGRect, name: String) -> LottieAnimationView {
    
    let animationView = LottieAnimationView(name: name)
    animationView.frame = frame
    animationView.loopMode = .loop
    animationView.contentMode = .scaleAspectFill
    animationView.isHidden = true
    return animationView
}

extension UIView {
    
    
    
    func addLoadingLotties(frame: CGRect, name: String) {
        
        let animationView = LottieAnimationView(name: name)
        animationView.frame = frame
        animationView.center.x = self.center.x
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFill
        animationView.play()
        self.addSubview(animationView)
    }
    
//    func addLottiesAnimation(frame: CGRect, name: String, completionHandler: LottieCompletionBlock?) {
//        let animationView = AnimationView(name: "")
//        animationView.frame = frame
//        animationView.center.x = self.center.x
//        animationView.contentMode = .scaleAspectFill
//        animationView.backgroundBehavior = .pauseAndRestore
//        animationView.play(completion: completionHandler)
//        self.addSubview(animationView)
//    }
    // MARK: backgroundBehavior is not run with 6s plus
    func addLottiesAnimation(frame: CGRect, name: String, completionHandler: LottieCompletionBlock?) {
        let animationView = LottieAnimationView(name: name)
        animationView.frame = self.frame
        animationView.center.x = self.center.x
        animationView.contentMode = .scaleAspectFill
        if UIDevice.current.type != .iPhone6S || UIDevice.current.type != .iPhone6SPlus  {
            animationView.backgroundBehavior = .pauseAndRestore
        }
        
        animationView.play(completion: completionHandler)
        self.addSubview(animationView)
    }
    
    func removeLotties() {
        let views = self.subviews.filter({$0 is LottieAnimationView})
        views.forEach({$0.removeFromSuperview()})
    }
    

}
