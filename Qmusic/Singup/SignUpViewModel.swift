//
//  SignUpViewModel.swift
//  Qmusic
//
//  Created by QuangHo on 28/08/2023.
//

import Foundation
import RxSwift
import UIKit

extension Request {
    struct Signup: Codable {
        /*
         {
             "phone": "0865873249",
             "email": "xuanquang@gmail.com",
             "password": "12345@",
             "deviceModel": "iphone7.1",
             "os": "ios16.1"
         }
         */
        let phone: String
        let email: String
        let password: String // Hash256
        var deviceModel: String = UIDevice.current.model
        var os: String = UIDevice.current.getOSInfo()
    }
}

struct Response {
    struct SignUp: Codable {
        /**
         {
             "reqID": "308d4907-6787-4e2f-92a4-7a31b7347b7f",
             "result": {
                 "code": 0,
                 "message": "",
                 "langCode": "",
                 "jwt": ""
             }
         }
         */
        let reqID: String?
        let result: Result?
        
        
        enum CodingKeys: String, CodingKey {

            case reqID = "reqID"
            case result = "result"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            reqID = try values.decodeIfPresent(String.self, forKey: .reqID)
            result = try values.decodeIfPresent(Response.SignUp.Result.self, forKey: .result)
            
        }
        
        
        struct Result: Codable {
            let code: Int?
            let message: String?
            let langCode: String?
            let jwt: String?
            
            enum CodingKeys: String, CodingKey {

                case code = "code"
                case message = "message"
                case langCode = "langCode"
                case jwt = "jwt"
            }

            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                code = try values.decodeIfPresent(Int.self, forKey: .code)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                langCode = try values.decodeIfPresent(String.self, forKey: .langCode)
                jwt = try values.decodeIfPresent(String.self, forKey: .jwt)
            }
            
        }
        
    }
    
}


class SignupViewModel: BaseViewModel {
    struct Input {}
    
    struct Output {
        let error: PublishSubject<FEHomeError>
        let signup:PublishSubject<Response.SignUp>
        
    }
    let input: Input
    let output: Output
    
    let errorObserver =  PublishSubject<FEHomeError>()
    let signupObserver = PublishSubject<Response.SignUp>()
    let disposeBag = DisposeBag()
    
    init() {
        self.input = Input()
        self.output = Output(error: errorObserver,
                             signup: signupObserver)
        
    }
    
    func signUp(req: Request.Signup) {
        let apiClient = NetworkManager.sharedInstance
        
        apiClient.signup(req: req).subscribe(
            onNext: { result in
                guard let code = result.result?.code else {
                    self.output.error.onNext(._403("Đã có lỗi dưới BE"))
                    return
                }
                if code == 0 {
                    self.output.signup.onNext(result)
                } else {
                    self.output.error.onNext(._403(result.result?.message ?? ""))
                }
                
            }).disposed(by: disposeBag)
           
    }
    
}
