//
//  LoginViewController.swift
//  Qmusic
//
//  Created by QuangHo on 13/08/2023.
//

import UIKit
import FacebookLogin

class LoginViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var btnFacebook: UIButton!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    var loginManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        tfEmail.attributedPlaceholder = NSAttributedString(
                string: "E mail",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "9F9F9F")]
            )
        
        tfPassword.attributedPlaceholder = NSAttributedString(
                string: "Password",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "9F9F9F")]
            )
        
        // Do any additional setup after loading the view.
    }

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSignUp(_ sender: Any) {
        let vc = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func actionLoginWithFacebook(_ sender: Any) {
        if let _ = AccessToken.current {
            //MARK: -- vô thẳng app
            
                                let vc = HomeMasterViewController(nibName: "HomeMasterViewController", bundle: nil)
                                self.navigationController?.pushViewController(vc, animated: true)
        } else {
            
            loginManager.logIn(permissions: [], from: self) { result, err in
                
                if err == nil {
                    
                }
                
                // 5
                // Check for cancel
                guard let result = result, !result.isCancelled else {
                    print("User cancelled login")
                    return
                }
                
                //MARK: -- vô thẳng app
                
                let vc = HomeMasterViewController(nibName: "HomeMasterViewController", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }
        }
        
        
    }
    
    @IBAction func actionLoginWithGoogle(_ sender: Any) {
    }
    
    @IBAction func actionLoginWithApple(_ sender: Any) {
    }
}

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?, error: Error?) {
        print(error?.localizedDescription)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        
    }
    
    
}
