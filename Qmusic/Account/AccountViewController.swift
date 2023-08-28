//
//  AccountViewController.swift
//  Qmusic
//
//  Created by QuangHo on 17/08/2023.
//

import UIKit

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func actionMyPlaylist(_ sender: Any) {
    }
    
    @IBAction func actionLogout(_ sender: Any) {
        AppSetting.shared.setStatusLogin(status: false)
        if let vc = self.parent?.navigationController?.viewControllers.filter({ vc in
            return vc is SplashScreenViewController
        }).first {
            self.navigationController?.popToViewController(vc, animated: true)
        }
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
