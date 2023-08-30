//
//  LoginViewController.swift
//  Qmusic
//
//  Created by QuangHo on 13/08/2023.
//

import UIKit
import FacebookLogin
import GoogleSignIn
import RxSwift

enum LoginInWithMethod {
    case Facebook
    case Google
    case Apple
    case Normal
}

class LoginViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var btnFacebook: UIButton!
    
    @IBOutlet weak var viewButton: UIView!
    let cymeButton = CymeButton.instantiate()
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    var loginManager = LoginManager()
    var signInViewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cymeButton.delegate = self
        self.viewButton.addSubViewFullConstraint(sub: self.cymeButton)
        
        tfEmail.attributedPlaceholder = NSAttributedString(
                string: "E mail",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "9F9F9F")]
            )
        
        tfPassword.attributedPlaceholder = NSAttributedString(
                string: "Password",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "9F9F9F")]
            )
        setupRx()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSignUp(_ sender: Any) {
        let vc = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        self.navigationController?.push(destinVC: vc)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func setupRx() {
        signInViewModel.output.signin.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                //MARK: -- vô thẳng app
                
                let vc = HomeMasterViewController(nibName: "HomeMasterViewController", bundle: nil)
                self?.navigationController?.pushViewController(vc, animated: true)
                AppSetting.shared.setStatusLogin(status: true)
            })
            .disposed(by: signInViewModel.disposeBag)
        
        signInViewModel.output.error.observe(on: MainScheduler.instance)
            .subscribe(onNext: { value in
                switch value {
                    
                case ._403(let err):
                    self.showError(title: "Error", desc: err)
                    self.cymeButton.resetUI()
                }
            })
            .disposed(by: signInViewModel.disposeBag)
    }
    
    
    @IBAction func actionLoginWithFacebook(_ sender: Any) {
        if let _ = AccessToken.current {
            //MARK: -- vô thẳng app
            
            let vc = HomeMasterViewController(nibName: "HomeMasterViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            AppSetting.shared.setStatusLogin(status: true)
        } else {
            
            loginManager.logIn(permissions: ["public_profile"], from: self) { result, err in
                
                if err == nil {
                    
                }
                
                
                // Check for cancel
                guard let result = result, !result.isCancelled else {
                    print("User cancelled login")
                    return
                }
                
                //MARK: -- vô thẳng app
                
                let vc = HomeMasterViewController(nibName: "HomeMasterViewController", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                AppSetting.shared.setStatusLogin(status: true)
                
            }
        }
        
        
    }
    
    @IBAction func actionLoginWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) {result, error in
            guard let result = result else {
                // Inspect error
                return
            }
            AppSetting.shared.setStatusLogin(status: true)
            // go main content view
            let vc = HomeMasterViewController(nibName: "HomeMasterViewController", bundle: nil)
            self.navigationController?.push(destinVC: vc)
        }
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
extension LoginViewController: CymeButtonDelegate {
    func actionSelect(btn: UIButton) {
        let email = tfEmail.text ?? ""
        let password = tfPassword.text ?? ""
        
        let req = Request.SignIn(email: email, password: password.hash256())
        signInViewModel.signIn(req: req)
    }
    
    
}
