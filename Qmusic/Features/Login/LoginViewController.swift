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
import AuthenticationServices

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
    
    @IBOutlet weak var btnApple: ASAuthorizationAppleIDButton!
    
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
        
        btnApple.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
    }
    
    // - Tag: perform_appleid_password_request
    /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    /// - Tag: perform_appleid_request
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
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
                self?.navigationController?.push(destinVC: vc)
                AppSetting.shared.setStatusLogin(status: true)
            })
            .disposed(by: signInViewModel.disposeBag)
        
        signInViewModel.output.error.observe(on: MainScheduler.instance)
            .subscribe(onNext: { value in
                switch value {
                case .login(let err):
                    self.showError(title: "Error", desc: err)
                    self.cymeButton.resetUI()
                default:break
                }
            })
            .disposed(by: signInViewModel.disposeBag)
    }
    
    
    @IBAction func actionLoginWithFacebook(_ sender: Any) {
        if let token = AccessToken.current {
            //MARK: -- vô thẳng app
            
            //MARK: -- vô thẳng app
            let email = token.userID
            let password = token.tokenString

            let req = Request.SignIn(email: email, password: password, channel: LoginType.FaceBook.rawValue)
            self.signInViewModel.signIn(req: req)
            
           
        } else {
            
            loginManager.logIn(permissions: ["public_profile"], from: self) { result, err in
                
                if err == nil {
                    
                }
                
                
                // Check for cancel
                guard let result = result, !result.isCancelled else {
                    print("User cancelled login")
                    return
                }
                
                guard let token = result.token else {return}
                
                
                
                //MARK: -- vô thẳng app
                let email = token.userID
                let password = token.tokenString

                let req = Request.SignIn(email: email, password: password, channel: LoginType.FaceBook.rawValue)
                self.signInViewModel.signIn(req: req)
                
                
               
                
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
        handleAuthorizationAppleIDButtonPress()
    }
    
    @IBAction func actionForgotPassword(_ sender: Any) {
        let vc = ForgotViewController(loginViewModel: signInViewModel)
        self.navigationController?.push(destinVC: vc)
    }
    
}

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?, error: Error?) {
        print(error?.localizedDescription as Any)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        
    }
    
    
}
extension LoginViewController: CymeButtonDelegate {
    func actionSelect(btn: UIButton) {
        
//        for _ in 1...100 {
//            NetworkManager.sharedInstance.randomUser()
//            do {
//                sleep(1)
//            }
//        }
        
        let email = tfEmail.text ?? ""
        let password = tfPassword.text ?? ""

        let req = Request.SignIn(email: email, password: password.hash256())
        signInViewModel.signIn(req: req)
    }
    
    
}
extension LoginViewController: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
            //self.saveUserInKeychain(userIdentifier)
            
            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
            self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
        
        case let passwordCredential as ASPasswordCredential:
        
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
    }
    
//    private func saveUserInKeychain(_ userIdentifier: String) {
//        do {
//            try KeychainItem(service: "com.example.apple-samplecode.juice", account: "userIdentifier").saveItem(userIdentifier)
//        } catch {
//            print("Unable to save userIdentifier to keychain.")
//        }
//    }
    
    private func showResultViewController(userIdentifier: String, fullName: PersonNameComponents?, email: String?) {
        
        
        //MARK: -- vô thẳng app
                
        let req = Request.SignIn(email: "apple\(NetworkManager.sharedInstance.random(digits: 4))@gmail.com", password: "123456".hash256(), channel: LoginType.Apple.rawValue)
        self.signInViewModel.signIn(req: req)
       
    }
    
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// - Tag: did_complete_error
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
