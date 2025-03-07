//
//  APIManager.swift
//  Tradesman Tech
//  Created by YATIN  KALRA on 10/01/25.
//
// pull leta hu

import Combine
import Foundation
import Alamofire

class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    func login(email: String, password: String) -> AnyPublisher<BaseResponse<LoginModel>, Error> {
        let parameters: [String: Any] = [
            APIKeys.email: email,
            APIKeys.password: password
        ]
        
        return APIServices<LoginModel>()
            .post(endpoint: .login, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
//MARK: - Add more api here ----- and call it from viewmodel
}

