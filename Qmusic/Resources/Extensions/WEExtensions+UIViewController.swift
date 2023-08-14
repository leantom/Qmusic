//
//  WEExtensions+UIViewController.swift
//  facepay_v3
//
//  Created by LV on 10/19/20.
//

import Foundation
import UIKit

extension UIViewController {
//    func push(destinVC: UIViewController) {
//        let transition:CATransition = CATransition()
//        transition.duration = 0.3
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.fade
//        transition.subtype = CATransitionSubtype.fromTop
//        self.navigationController?.view.layer.add(transition, forKey: nil)
//        self.navigationController?.pushViewController(destinVC, animated: false)
//    }
    
//    func push(vc: UIViewController) {
//        let transition:CATransition = CATransition()
//        transition.duration = 0.3
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.fade
//        transition.subtype = CATransitionSubtype.fromTop
//        self.navigationController?.view.layer.add(transition, forKey: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func pop() {
//        let transition:CATransition = CATransition()
//        transition.duration = 0.3
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.fade
//        transition.subtype = CATransitionSubtype.fromRight
//        self.view.layer.add(transition, forKey: nil)
//        self.navigationController?.popViewController(animated: true)
//    }
    
    @objc func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
          
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        
        return instantiateFromNib()
    }
    
    func topMostViewController() -> UIViewController {
          
          if let presented = self.presentedViewController {
              return presented.topMostViewController()
          }
          
          if let navigation = self as? UINavigationController {
              return navigation.visibleViewController?.topMostViewController() ?? navigation
          }
          
          if let tab = self as? UITabBarController {
              return tab.selectedViewController?.topMostViewController() ?? tab
          }
          
          return self
      }
    
    func popToViewControllerWithCompletion(vc: UIViewController, completion: (() -> Void)?) {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        if self.responds(to: #selector(getter: self.navigationController?.interactivePopGestureRecognizer)) {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popToViewController(vc, animated: false)
        CATransaction.commit()
    }
}
