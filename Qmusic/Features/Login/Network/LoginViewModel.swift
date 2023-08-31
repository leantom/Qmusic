//
//  LoginViewModel.swift
//  Qmusic
//
//  Created by QuangHo on 29/08/2023.
//

import Foundation
import RxSwift

enum LoginType: String {
    case Cyme = "Cyme"
    case FaceBook = "FaceBook"
    case Google = "Google"
    case Twitter = "Twitter"
}
enum LoginEror {
    case login(String)
    case checkEMail(String)
}

extension Request {
    struct SignIn: Codable {
        /*
         {
         {
             "email": "ngocquy111197@gmail.com",
             "password": "test", // hash 256 if FaceBook, Google, Twitter use to Token
             "channel":"Cyme"  // Cyme,  FaceBook, Google, Twitter
         }
         }
         */
        let email: String
        let password: String // Hash256
        var channel: String = "Cyme"
    }
}
class LoginViewModel: BaseViewModel {
    struct Input {}
    
    struct Output {
        let error: PublishSubject<LoginEror>
        let signin:PublishSubject<Response.SignUp>
        let checkEMail:PublishSubject<Response.CheckEmail>
        
    }
    let input: Input
    let output: Output
    
    let errorObserver =  PublishSubject<LoginEror>()
    let signinObserver = PublishSubject<Response.SignUp>()
    let checkEMailObserver = PublishSubject<Response.CheckEmail>()
    let disposeBag = DisposeBag()
    
    init() {
        self.input = Input()
        self.output = Output(error: errorObserver,
                             signin: signinObserver,
                             checkEMail: checkEMailObserver)
        
    }
    
    func signIn(req: Request.SignIn) {
        let apiClient = NetworkManager.sharedInstance
        
        apiClient.signin(req: req).subscribe(
            onNext: { result in
                guard let code = result.result?.code else {
                    self.output.error.onNext(.login("Đã có lỗi dưới BE"))
                    return
                }
                if code == 0 {
                    self.output.signin.onNext(result)
                } else {
                    self.output.error.onNext(.login(result.result?.message ?? ""))
                }
                
            }).disposed(by: disposeBag)
           
    }
    
    func checkEMail(email:String) {
        let apiClient = NetworkManager.sharedInstance
        
        apiClient.checkEmailToResetPassword(email: email).subscribe(
            onNext: { result in
                guard let code = result.result?.code else {
                    self.output.error.onNext(.checkEMail("Đã có lỗi dưới BE"))
                    return
                }
                if code == 0 {
                    self.output.checkEMail.onNext(result)
                } else {
                    self.output.error.onNext(.checkEMail(result.result?.message ?? ""))
                }
                
            }).disposed(by: disposeBag)
           
    }
    
    
    
    
}
