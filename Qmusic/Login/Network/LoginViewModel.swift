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
        let error: PublishSubject<FEHomeError>
        let signin:PublishSubject<Response.SignUp>
        
    }
    let input: Input
    let output: Output
    
    let errorObserver =  PublishSubject<FEHomeError>()
    let signinObserver = PublishSubject<Response.SignUp>()
    let disposeBag = DisposeBag()
    
    init() {
        self.input = Input()
        self.output = Output(error: errorObserver,
                             signin: signinObserver)
        
    }
    
    func signIn(req: Request.SignIn) {
        let apiClient = NetworkManager.sharedInstance
        
        apiClient.signin(req: req).subscribe(
            onNext: { result in
                guard let code = result.result?.code else {
                    self.output.error.onNext(._403("Đã có lỗi dưới BE"))
                    return
                }
                if code == 0 {
                    self.output.signin.onNext(result)
                } else {
                    self.output.error.onNext(._403(result.result?.message ?? ""))
                }
                
            }).disposed(by: disposeBag)
           
    }
    
    
}
