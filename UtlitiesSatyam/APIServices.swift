//
//  AppDelegate.swift
//  RPG
//
//  Created by Satyam on 07/02/24.
//


import Alamofire
import Combine
import SwiftyJSON

enum ServiceError: Error {
    case url(URLError)
    case urlRequest
    case encode
    case decode
    case invalidResponse
}


struct EmptyModel: Decodable {}
typealias DefaultAPIService = APIServices<EmptyModel>
protocol APIServiceProtocol {
    associatedtype Model: Decodable
    
    func get(endpoint: AppURL.Endpoint, parameters: [String: Any],loader:Bool?) -> AnyPublisher<BaseResponse<Model>, Error>
    func post(endpoint: AppURL.Endpoint, parameters: [String: Any],loader:Bool?) -> AnyPublisher<BaseResponse<Model>, Error>
    func post(endpoint: AppURL.Endpoint, parameters: [String: Any], images: [String: Data]?, progressHandler: ((Double) -> Void)?,loader:Bool?) -> AnyPublisher<BaseResponse<Model>, Error>
}



final class APIServices<T: Decodable>: APIServiceProtocol {
    
    func get(endpoint: AppURL.Endpoint, parameters: [String: Any],loader:Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
        return Future<BaseResponse<T>, Error> { promise in
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }
            print("==========================URL=====================")
            
            print(endpoint.path)
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(UserDetail.shared.getTokenWith())"
            ]
            if loader ?? false {
                GameLoaderView.show(in: topViewController.view)
            }
            AF.request(endpoint.path, method: .get, parameters: parameters, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: BaseResponse<T>.self) { response in
                    GameLoaderView.hide(from: topViewController.view)
                    
                    print("\n==========================Parameters=====================\n")
                    print(parameters)
                    print("\n==========================Header=====================\n")
                    print(headers)
                    print("\n==========================Response=======================\n")
                    
                    if let data = response.data {
                        print(JSON(data))
                    }
                    
                    switch response.result {
                    case .success(let value):
                        promise(.success(value))
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 401 {
                                print("Unauthorized (401) detected. Logging out...")
                                self.handleUnauthorized()
                                return
                            }
                        }
                        print(error.localizedDescription)
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    
    func uploadMultiData(para: [String: Any], imageData: [UploadFileParameter],endpoint:AppURL.Endpoint,loader:Bool? = true) ->  AnyPublisher<BaseResponse<T>, Error> {
        
        
        return Future<BaseResponse<T>, Error>{ promise in
            
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(UserDetail.shared.getTokenWith())"
            ]
            
            if loader ?? false {
                GameLoaderView.show(in: topViewController.view)
            }
            
            print("==========================URL=====================")
            print(endpoint.path)
            print("\n==========================Parameters=====================\n")
            print(para)
            print("\n==========================Header=====================\n")
            print(headers)
            print("\n==========================Response=======================\n")
            AF.upload(multipartFormData: { multipartFormData in
                
                for (key, value) in para {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    } else if let temp = value as? Int {
                        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    } else if let temp = value as? NSArray {
                        temp.forEach { element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                            } else if let num = element as? Int {
                                let value = "\(num)"
                                multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        }
                    }
                }
                imageData.forEach { imageData in
                    multipartFormData.append(imageData.data ?? Data(), withName: imageData.key, fileName: imageData.fileName, mimeType: imageData.mimeType)
                }
                
                
            }, to: endpoint.path, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: BaseResponse<T>.self){ response in
                
                GameLoaderView.hide(from: topViewController.view)
                
                
                switch response.result {
                case .success(let value):
                    promise(.success(value))
                    
                    print(JSON(value))
                    
                case .failure(let error):
                    print("==========================failure=====================")
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            print("Unauthorized (401) detected. Logging out...")
                            self.handleUnauthorized()
                            return
                        }
                    }
                    print(error)
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func postModel< Parameter: Encodable>(
        endpoint: AppURL.Endpoint,
        parameters: Parameter,
        loader: Bool? = true
    ) -> AnyPublisher<BaseResponse<T>, Error> {
        return Future<BaseResponse<T>, Error> { promise in
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                .windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
                "Content-Type": "application/json"
            ]
            
            if loader ?? false {
                GameLoaderView.show(in: topViewController.view)
            }
            
            print("==========================URL=====================")
            print(endpoint.path)
            print("\n==========================Parameters=====================\n")
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            do {
                let jsonData = try encoder.encode(parameters)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                    
                }
            } catch {
                print("Error encoding intervals to JSON: \(error)")
                
            }
            
            print("\n==========================Header=====================\n")
            print(headers)
            AF.request(endpoint.path,
                       method: .post,
                       parameters: parameters,
                       encoder: JSONParameterEncoder.default,
                       headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BaseResponse<T>.self) { response in
                GameLoaderView.hide(from: topViewController.view)
                
                
                
                
                print("\n==========================Response=======================\n")
                
                if let data = response.data {
                    print(JSON(data))
                }
                
                switch response.result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    print("==========================failure=====================")
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            print("Unauthorized (401) detected. Logging out...")
                            self.handleUnauthorized()
                            return
                        }
                    }
                    print(error)
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    func post(endpoint: AppURL.Endpoint, parameters: [String: Any], loader: Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
        let maxRetries = 3
        let initialDelay: TimeInterval = 1

        return Future<BaseResponse<T>, Error> { promise in
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(UserDetail.shared.getTokenWith())"
            ]
            
            if loader ?? false {
                GameLoaderView.show(in: topViewController.view)
            }
            
            func makeRequest(attempt: Int) {
                AF.request(endpoint.path, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: BaseResponse<T>.self) { response in
                        GameLoaderView.hide(from: topViewController.view)
                        
                        
                        print("==========================URL=====================")
                        print(endpoint.path)
                        print("\n==========================Parameters=====================\n")
                        print(parameters)
                        print("\n==========================Header=====================\n")
                        print(headers)
                        print("\n==========================Response=======================\n")
                        if let data = response.data {
                            print(JSON(data))
                        }
                        switch response.result {
                        case .success(let value):
                            promise(.success(value))
                        case .failure(let error):
                            if let statusCode = response.response?.statusCode {
                                if statusCode == 401 {
                                    print("Unauthorized (401) detected. Logging out...")
                                    self.handleUnauthorized()
                                    return
                                }
                            }
                            print("Attempt \(attempt + 1) failed: \(error.localizedDescription)")
                            
                            if attempt < maxRetries, let afError = error.asAFError, afError.isSessionTaskError {
                                let retryDelay = initialDelay * pow(2, Double(attempt))
                                print("Retrying in \(retryDelay) seconds...")
                                DispatchQueue.global().asyncAfter(deadline: .now() + retryDelay) {
                                    makeRequest(attempt: attempt + 1)
                                }
                            } else {
                                promise(.failure(error))
                            }
                        }
                    }
            }
            
            makeRequest(attempt: 0)
        }
        .eraseToAnyPublisher()
    }
    
    func post(endpoint: AppURL.Endpoint, parameters: [String: Any], images: [String: Data]?, progressHandler: ((Double) -> Void)? = nil, loader: Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
        let maxRetries = 3
        let initialDelay: TimeInterval = 1

        return Future<BaseResponse<T>, Error> { promise in
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(UserDetail.shared.getTokenWith())"
            ]
            
            if loader ?? false {
                GameLoaderView.show(in: topViewController.view)
            }
            
            func makeRequest(attempt: Int) {
                AF.upload(multipartFormData: { multipartFormData in
                    // Add parameters
                    for (key, value) in parameters {
                        if let data = "\(value)".data(using: .utf8) {
                            multipartFormData.append(data, withName: key)
                        }
                    }
                    
                    // Add images
                    let name = Date.getCurrentDateForName()
                    var i = 0
                    if let images = images {
                        print("==========================ImageParameters=====================")
                        for (key, imageData) in images {
                            multipartFormData.append(imageData, withName: key, fileName: "\(name).jpeg", mimeType: "image/jpeg")
                            print("data ==>", imageData, "withName ==>", key, "fileName==>", "\(name)\(i).jpeg", "mimeType ==>", "image/jpeg")
                            i += 1
                        }
                    }
                }, to: endpoint.path, headers: headers)
                .uploadProgress { progress in
                    print("Upload Progress: \(progress.fractionCompleted)")
                    progressHandler?(progress.fractionCompleted)
                }
                .validate(statusCode: 200..<300)
                .responseDecodable(of: BaseResponse<T>.self) { response in
                    GameLoaderView.hide(from: topViewController.view)
                    
                    print("==========================URL=====================")
                    print(endpoint.path)
                    print("\n==========================Parameters=====================\n")
                    print(parameters)
                    print("\n==========================Header=====================\n")
                    print(headers)
                    print("\n==========================Response=======================\n")

                    if let data = response.data {
                        print(JSON(data))
                        let json = JSON(data)
                        if let dict = json.dictionaryObject, let status = dict["code"] as? Int, status == 206 || status == 401 {
                            topViewController.showOkAlertWithHandler(dict["message"] as? String ?? "") {
                                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                                topViewController.hidesBottomBarWhenPushed = true
                                topViewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                                UserDetail.shared.setUserId("")
                                UserDetail.shared.setSessntId("")
                                topViewController.navigationController?.pushViewController(newViewController, animated: true)
                            }
                        }
                    }

                    switch response.result {
                    case .success(let value):
                        promise(.success(value))
                    case .failure(let error):
                        print("==========================failure=====================")
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 401 {
                                print("Unauthorized (401) detected. Logging out...")
                                self.handleUnauthorized()
                                return
                            }
                        }
                        print("Attempt \(attempt + 1) failed: \(error.localizedDescription)")

                        if attempt < maxRetries, let afError = error.asAFError, afError.isSessionTaskError {
                            let retryDelay = initialDelay * pow(2, Double(attempt)) // 1s, 2s, 4s...
                            print("Retrying in \(retryDelay) seconds...")
                            DispatchQueue.global().asyncAfter(deadline: .now() + retryDelay) {
                                makeRequest(attempt: attempt + 1)
                            }
                        } else {
                            promise(.failure(error))
                        }
                    }
                }
            }
            
            makeRequest(attempt: 0)
        }
        .eraseToAnyPublisher()
    }
    func SendAnyThing(endpoint: AppURL.Endpoint, parameters: [String: Any],images: [String: Data]?,progressHandler: ((Double) -> Void)? = nil,loader:Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
        return Future<BaseResponse<T>, Error> { promise in
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(UserDetail.shared.getTokenWith())"
            ]
            
            if loader ?? false {
                GameLoaderView.show(in: topViewController.view)
            }
            
            AF.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let arrayValue = value as? [Any] {
                        arrayValue.forEach { value in
                            if let data = "\(value)".data(using: .utf8) {
                                multipartFormData.append(data, withName: key)
                            }
                        }
                    } else if let stringValue = "\(value)".data(using: .utf8) {
                        multipartFormData.append(stringValue, withName: key)
                    }
                }
                // Add images
                let name = Date.getCurrentDateForName()
                var i = 0
                if let images = images {
                    print("==========================ImageParameters=====================")
                    for (key, imageData) in images {
                        
                        multipartFormData.append(imageData, withName: key, fileName: "\(name).jpeg", mimeType: "image/jpeg")
                        
                        print("data ==>",imageData,"withName ==>",key,"fileName==>","\(name)\(i).jpeg","mimeType ==>" ,"image/jpeg")
                        i += 1
                    }
                }
            }, to: endpoint.path,headers: headers)
            .uploadProgress { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
                progressHandler?(progress.fractionCompleted)
            }
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BaseResponse<T>.self) { response in
                GameLoaderView.hide(from: topViewController.view)
                print("==========================URL=====================")
                print(endpoint.path)
                print("\n==========================Parameters=====================\n")
                for (key, value) in parameters {
                    print("\(key): \(value)")
                }
                
                print("\n==========================Header=====================\n")
                print(headers )
                print("\n==========================Response=======================\n")
                
                
                if let data = response.data {
                    print(JSON(data))
                }
                
                switch response.result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    print("==========================failure=====================")
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            print("Unauthorized (401) detected. Logging out...")
                            self.handleUnauthorized()
                            return
                        }
                    }
                    print(error)
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    func handleUnauthorized() {
        guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                return
        }

        let alert = UIAlertController(title: "Session Expired", message: "Your session has expired. Please log in again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in

            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
            let vc = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            QuickstartConversationsManager.shared.shutdown()
            UserDetail.shared.setUserId("")
            UserDetail.shared.setSessntId("")
            vc.hidesBottomBarWhenPushed = true
            topViewController.navigationController?.pushViewController(vc, animated: true)
        }))

        topViewController.present(alert, animated: true, completion: nil)
    }
}


extension UIViewController {
    func topmostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topmostViewController() // Recursively find presented view controller
        } else if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topmostViewController() ?? self
        } else if let tabController = self as? UITabBarController {
            return tabController.selectedViewController?.topmostViewController() ?? self
        }
        return self
    }
}



extension Result {
    func handle(success: @escaping (Success) -> Void) {
        switch self {
        case .success(let value):
            success(value)
        case .failure(let error):
            
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                _ = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                return
            }
            
            topViewController.AlertControllerOnr(title: "", message: "\(error.localizedDescription)")
            
        }
    }
}
