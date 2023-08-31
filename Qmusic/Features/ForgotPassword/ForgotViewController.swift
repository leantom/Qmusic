//
//  ForgotViewController.swift
//  Qmusic
//
//  Created by QuangHo on 31/08/2023.
//

import UIKit
import RxSwift

class ForgotViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var tfEmail: UITextField!
    let cymeButton = CymeButton.instantiate()
    var loginViewModel: LoginViewModel?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cymeButton.delegate = self
        self.viewButton.addSubViewFullConstraint(sub: self.cymeButton)
        setupUI()
        setupRx()
    }

    convenience init(loginViewModel: LoginViewModel) {
        self.init(nibName: "ForgotViewController", bundle: nil)
        self.loginViewModel = loginViewModel
    }

    @IBAction func actionHideKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    func setupRx() {
        if let loginViewModel = self.loginViewModel {
            loginViewModel.output.checkEMail.observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] value in
                    //MARK: -- vô thẳng app
                    
                    let vc = ResetPasswordViewController(nibName: "ResetPasswordViewController", bundle: nil)
                    self?.navigationController?.push(destinVC: vc)
                    
                })
                .disposed(by: loginViewModel.disposeBag)
            
            
            loginViewModel.output.error.observe(on: MainScheduler.instance)
                .subscribe(onNext: { value in
                    switch value {
                    case .checkEMail(let err):
                        self.showError(title: "Error", desc: err)
                        self.cymeButton.resetUI()
                    default:break
                    }
                })
                .disposed(by: loginViewModel.disposeBag)
        }
        
    }
    
    func setupUI() {
        tfEmail.attributedPlaceholder = NSAttributedString(
                string: "E mail",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "9F9F9F")]
            )
        tfEmail.rx.controlEvent([.editingChanged])
                .asObservable().subscribe({ [unowned self] _ in
                    print("My text : \(self.tfEmail.text ?? "")")
                }).disposed(by: disposeBag)
        tfEmail.rx.controlEvent([.editingDidEndOnExit]).subscribe { _ in
            print("text")
        }.disposed(by: disposeBag)
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.pop()
    }
    
}
extension ForgotViewController: CymeButtonDelegate {
    func actionSelect(btn: UIButton) {
        loginViewModel?.checkEMail(email: tfEmail.text ?? "")
    }
    
    
}
