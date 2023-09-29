//
//  LoginViewController.swift
//  Qmusic
//
//  Created by QuangHo on 13/08/2023.
//

import UIKit
import RxSwift

class SignUpViewController: UIViewController {

    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    var signupViewModel = SignupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfEmail.attributedPlaceholder = NSAttributedString(
                string: "E mail",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "9F9F9F")]
            )
        
        tfPassword.attributedPlaceholder = NSAttributedString(
                string: "Mật khẩu",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "9F9F9F")]
            )
        
        tfUsername.attributedPlaceholder = NSAttributedString(
                string: "Số điện thoại",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "9F9F9F")]
            )
        setupRx()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeLoading(on: self.view)
    }
    
    func setupRx() {
        signupViewModel.output.signup.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                //MARK: -- vô thẳng app
                
                let vc = HomeMasterViewController(nibName: "HomeMasterViewController", bundle: nil)
                self?.navigationController?.pushViewController(vc, animated: true)
                AppSetting.shared.setStatusLogin(status: true)
            })
            .disposed(by: signupViewModel.disposeBag)
        signupViewModel.output.error.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                switch value {
                    
                case ._403(let err):
                    self?.showError(title: "Error", desc: err)
                }
            })
            .disposed(by: signupViewModel.disposeBag)
    }
    
    @IBAction func actionSignup(_ sender: Any) {
        let phone = tfUsername.text ?? ""
        let email = tfEmail.text ?? ""
        let password = tfPassword.text ?? ""
        
        let req = Request.Signup(phone: phone, email: email, password: password.hash256())
        signupViewModel.signUp(req: req)
        showLoading(on: self.view)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    


}


func showLoading(on view: UIView) {
    let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
    loadingView.tag = 1000
    loadingView.shouldTapToDismiss = true
    loadingView.show(on: view)
    
}

func removeLoading(on view: UIView) {
    if let loadingView = view.viewWithTag(1000) as? RSLoadingView {
        loadingView.hide()
    }
}
