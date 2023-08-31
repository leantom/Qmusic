//
//  ResetPasswordViewController.swift
//  Qmusic
//
//  Created by QuangHo on 31/08/2023.
//

import UIKit
import RxSwift

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var tfResetPassword: UITextField!
    
    let cymeButton = CymeButton.instantiate()
    var loginViewModel: LoginViewModel?
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var viewButton: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupRx()
    }
    
    func setupRx() {
        
    }
    
    func setupUI(){
        
        cymeButton.delegate = self
        self.viewButton.addSubViewFullConstraint(sub: self.cymeButton)
        tfPassword.attributedPlaceholder = NSAttributedString(
                string: "Password",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "9F9F9F")]
            )
        
        tfResetPassword.attributedPlaceholder = NSAttributedString(
                string: "Confirm Password",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "9F9F9F")]
            )
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.pop()
    }
}

extension ResetPasswordViewController: CymeButtonDelegate {
    func actionSelect(btn: UIButton) {
        //loginViewModel?.checkEMail(email: tfEmail.text ?? "")
    }
    
    
}
