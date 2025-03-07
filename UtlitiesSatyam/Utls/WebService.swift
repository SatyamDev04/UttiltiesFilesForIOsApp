 

import Foundation
import Alamofire
import SwiftyJSON
import MBProgressHUD
import UIKit
import Reachability
import Network


class WebService {
 
    
    static let shared = WebService()
     
    private init() {
        
    }
     
    
    // Completion Handler
    typealias webServiceResponse = (JSON, Int) -> Void
    
    func postServiceURLEncoding(_ request: String, VC: UIViewController , andParameter parameters: [String:Any]?, headers: HTTPHeaders, withCompletion completionHandler: @escaping webServiceResponse) {
        
        let reuestUrl =  request
        
        var encodingFormat: ParameterEncoding = URLEncoding()
        if request == "" {
            
//            encodingFormat = URLEncoding()
           encodingFormat = JSONEncoding()
        }
        
        
  
        guard VC.isConnectedToNetwork() == true else{
            VC.hideIndicator()
            AlertController.alert(title: "Message", message: "Could not connect to the server, Please check your internet connection.")
            return
        }
//        let headers: HTTPHeaders = [
////            "Accept": "application/json",
////            "Authorization":""
//        ]
        
        //AF.request(reuestUrl, method: .post, parameters: parameters, encoding: encodingFormat, headers: headers).responseJSON{ (responseData) in
        AF.request(reuestUrl, method: .post, parameters: parameters , encoding: URLEncoding.default, headers: headers).responseJSON { (responseData) in
            
            if let data = responseData.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                do{
                    let statusCode = responseData.response?.statusCode
                    
                    
                    // Get json data
                    let json = try JSON(data: data)
                    print(json)
                   // success(json, statusCode!)
                    if responseData.result != nil {
                        let swiftyJsonData = responseData.result as? [String : Any]
                        completionHandler(json , statusCode!)
                    } else {
                       // hideHud()
                        VC.hideIndicator()
                        print(responseData.result)
                        completionHandler([:], statusCode!)
                    }
                }catch{
                    print("Unexpected error: \(error).")
                   // // hideHud()
                    
                    VC.hideIndicator()
                    AlertController.alert(title: "Message", message: "  Could not connect to the server.")
                   // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                     
                }
            }else{
              //  // hideHud()
             //   alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                VC.hideIndicator()
                AlertController.alert(title: "Message", message: "  Could not connect to the server.")
            }
            
        }
    }
    
    
    func postService(_ request: String, VC: UIViewController  , andParameter parameters: [String:Any]?, headers: HTTPHeaders, withCompletion completionHandler: @escaping webServiceResponse) {
        
        let reuestUrl =  request
        
        var encodingFormat: ParameterEncoding = JSONEncoding()
        if request == "" {
            
//            encodingFormat = URLEncoding()
           encodingFormat = JSONEncoding()
        }
        
//        let headers: HTTPHeaders = [
////            "Accept": "application/json",
////            "Authorization":""
//        ]
        
        AF.request(reuestUrl, method: .post, parameters: parameters, encoding: encodingFormat, headers: headers).responseJSON{ (responseData) in
            
            if let data = responseData.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                do{
                    let statusCode = responseData.response?.statusCode
                    // Get json data
                    let json = try JSON(data: data)
                    print(json)
                   // success(json, statusCode!)
                    if((responseData.result) != nil) {
                        let swiftyJsonData = responseData.result as? [String : Any]
                        completionHandler(json , statusCode!)
                    } else {
                       // // hideHud()
                        VC.hideIndicator()
                        print(responseData.result)
                        completionHandler([:], statusCode!)
                    }
                }catch{
                    print("Unexpected error: \(error).")
                   // // hideHud()
                   // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                    VC.hideIndicator()
                    AlertController.alert(title: "Message", message: "  Could not connect to the server.")
                }
            }else{
              //  // hideHud()
               // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                VC.hideIndicator()
                AlertController.alert(title: "Message", message: "  Could not connect to the server.")
            }
            
        }
    }
    func getServiceURLEncoding(_ request: String, VC: UIViewController  , andParameter parameters: [String:Any]?, headers: HTTPHeaders,withCompletion completionHandler: @escaping webServiceResponse) {
        
        let reuestUrl =  request
        
        var encodingFormat : ParameterEncoding = URLEncoding()
        if request == "" {
            
//            encodingFormat = JSONEncoding()

            encodingFormat = URLEncoding()
        }
//
//        let headers: HTTPHeaders = [
//            //"Content-Type": "application/json"
//           "Content-Type": "application/x-www-form-urlencoded"
//        ]
        AF.request(reuestUrl,
        method: .get,
        encoding: encodingFormat,
        headers: headers).responseJSON{ (responseData) in
            
            if let data = responseData.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                do{
                    let statusCode = responseData.response?.statusCode
                    // Get json data
                    let json = try JSON(data: data)
                    print(json)
                   // success(json, statusCode!)
                    if((responseData.result) != nil) {
                        let swiftyJsonData = responseData.result as? [String : Any]
                        completionHandler(json, statusCode!)
                    } else {
                        // hideHud()
                        VC.hideIndicator()
                        print(responseData.result)
                        completionHandler([:], statusCode!)
                    }
                }catch{
                    // hideHud()
                    VC.hideIndicator()
                    print("Unexpected error: \(error).")
                   // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                    AlertController.alert(title: "Message", message: "  Could not connect to the server.")
                }
            }else{
                // hideHud()
               // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                VC.hideIndicator()
                AlertController.alert(title: "Message", message: "  Could not connect to the server.")
            }
            
            /*
            if responseData.result.isSuccess {
                if((responseData.result.value) != nil) {
                    let swiftyJsonData = responseData.result.value as? [String : Any]
                    completionHandler(swiftyJsonData! , nil)
                } else {
                    print(responseData.result)
                }
            } else {
                completionHandler([:], responseData.error)
            }
            */
        }
    }
    
    func getServiceURLEncodingwithParams(_ request: String, VC: UIViewController  , andParameter parameters: [String:Any]?, headers: HTTPHeaders,withCompletion completionHandler: @escaping webServiceResponse) {
        
        let reuestUrl =  request
        
        var encodingFormat : ParameterEncoding = URLEncoding()
        if request == "" {
            
//            encodingFormat = JSONEncoding()

            encodingFormat = URLEncoding()
        }
//
//        let headers: HTTPHeaders = [
//            //"Content-Type": "application/json"
//           "Content-Type": "application/x-www-form-urlencoded"
//        ]
        AF.request(reuestUrl,
        method: .get,
        parameters: parameters,
        encoding: encodingFormat,
        headers: headers).responseJSON{ (responseData) in
            
            if let data = responseData.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                do{
                    let statusCode = responseData.response?.statusCode
                    // Get json data
                    let json = try JSON(data: data)
                    print(json)
                   // success(json, statusCode!)
                    if((responseData.result) != nil) {
                        let swiftyJsonData = responseData.result as? [String : Any]
                        completionHandler(json, statusCode!)
                    } else {
                        // hideHud()
                        VC.hideIndicator()
                        print(responseData.result)
                        completionHandler([:], statusCode!)
                    }
                }catch{
                    // hideHud()
                    VC.hideIndicator()
                    print("Unexpected error: \(error).")
                   // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                    AlertController.alert(title: "Message", message: "  Could not connect to the server.")
                }
            }else{
                // hideHud()
               // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                VC.hideIndicator()
                AlertController.alert(title: "Message", message: "  Could not connect to the server.")
            }
            
            /*
            if responseData.result.isSuccess {
                if((responseData.result.value) != nil) {
                    let swiftyJsonData = responseData.result.value as? [String : Any]
                    completionHandler(swiftyJsonData! , nil)
                } else {
                    print(responseData.result)
                }
            } else {
                completionHandler([:], responseData.error)
            }
            */
        }
    }
    
    
    
    func getService(_ request: String, VC: UIViewController  , andParameter parameters: [String:Any]?, headers: HTTPHeaders, withCompletion completionHandler: @escaping webServiceResponse) {
        
        let reuestUrl =  request
        
        var encodingFormat : ParameterEncoding = URLEncoding.default
        if request == "" {
            encodingFormat = URLEncoding()
        }
//
//        let headers: HTTPHeaders = [
//            //"Content-Type": "application/json"
//            "Content-Type": "application/x-www-form-urlencoded"
//        ]
        
        //AF.request(...).responseDecodable(of: YourType.self,
   // emptyResponseCodes: [200, 204, 205]) { response in
        
        AF.request(reuestUrl,
        method: .get,
                   encoding: encodingFormat,
                   headers: [:]).validate()
            .responseData(emptyResponseCodes: [200, 204, 205,404]) { responseData in
                
//        AF.request(reuestUrl,
//        method: .get,
//        encoding: URLEncoding.default,
//        headers: [:]).responseJSON{ (responseData) in
            
            if let data = responseData.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                do{
                    let statusCode = responseData.response?.statusCode
                    // Get json data
                    let json = try JSON(data: data)
                    print(json)
                   // success(json, statusCode!)
                    if((responseData.result) != nil) {
                        let swiftyJsonData = responseData.result as? [String : Any]
                        completionHandler(json, statusCode!)
                    } else {
                        // hideHud()
                        VC.hideIndicator()
                        print(responseData.result)
                        completionHandler([:], statusCode!)
                    }
                }catch{
                    // hideHud()
                    VC.hideIndicator()
                    print("Unexpected error: \(error).")
                   // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                    AlertController.alert(title: "Message", message: "  Could not connect to the server.")
                }
            }else{
                // hideHud()
               // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                VC.hideIndicator()
                AlertController.alert(title: "Message", message: "  Could not connect to the server.")
            }
            
            /*
            if responseData.result.isSuccess {
                if((responseData.result.value) != nil) {
                    let swiftyJsonData = responseData.result.value as? [String : Any]
                    completionHandler(swiftyJsonData! , nil)
                } else {
                    print(responseData.result)
                }
            } else {
                completionHandler([:], responseData.error)
            }
            */
        }
    }
  
  
                func uploadImageWithParameter( request: String, image:Data?, VC: UIViewController  , parameters: [String:Any]?,headers: HTTPHeaders,imageName:String, withCompletion completionHandler: @escaping webServiceResponse) {
                            
                            let reuestUrl = request
//                            let headers: HTTPHeaders = [
//                                "Authorization":"Basic bml0aW50eWFnaTpwYXNzd29yZEAxMjM="
//                            ]
                        
                   
                            AF.upload(multipartFormData: { multiPart in
//                                if let allParams = parameters as? [String:String] {
//                                    for (key, value) in allParams {
//                                        multiPart.append(value.data(using: .utf8)!, withName: key)
//                                    }
//                                }
                                let allParams = parameters as? [String:String]
                                for (key, value) in allParams ?? [:]{
                                    multiPart.append(value.data(using: .utf8)!, withName: key)
                                }
                 
                            if let imgExist = image {
                                let name = NSUUID().uuidString.lowercased()
                                multiPart.append(imgExist, withName: imageName, fileName: "\(name).jpeg", mimeType: "image/jpeg")
                            }
                                
//
                           
                            
                        }, to: request, method: .post, headers: headers).uploadProgress(queue: .main, closure: { progress in
                            //Current upload progress of file
                            print("Upload Progress: \(progress.fractionCompleted)")
                        
                        })
                        .responseJSON(completionHandler: { responseData in
                        //Do what ever you want to do with response
                        print(responseData)
                        if let data = responseData.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)") // original server data as UTF8 string
                            do{
                                let statusCode = responseData.response?.statusCode
                                // Get json data
                                let json = try JSON(data: data)
                                print(json)
                               // success(json, statusCode!)
                                if((responseData.result) != nil) {
                                    let swiftyJsonData = responseData.result as? [String : Any]
                                    completionHandler(json , statusCode!)
                                } else {
                                     //hideHud()
                                    VC.hideIndicator()
                                    print(responseData.result)
                                    completionHandler([:]
        , statusCode!)
                                }
                            }catch{
                                // hideHud()
                                print("Unexpected error: \(error).")
                               // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                                VC.hideIndicator()
                                AlertController.alert(title: "Message", message: "  Could not connect to the server.")
                            }
                        }else{
                            // hideHud()
                           // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                            VC.hideIndicator()
                            AlertController.alert(title: "Message", message: "  Could not connect to the server.")
                        }
                    })
                    }
       
    // array image with parameters.
    
        func uploadImageWithParameterAB( request: String, image:[Data]?, VC: UIViewController  , parameters: [String:Any]?,headers: HTTPHeaders,imageName:String, withCompletion completionHandler: @escaping webServiceResponse) {
                    
                    let reuestUrl = request
//                    let headers: HTTPHeaders = [
//                        //"Authorization":"Basic bml0aW50eWFnaTpwYXNzd29yZEAxMjM="
//                    ]
                
                AF.upload(multipartFormData: { multiPart in
                    let allParams = parameters as? [String:String]
                    for (key, value) in allParams ?? [:]{
                        multiPart.append(value.data(using: .utf8)!, withName: key)
                    }
         
                    for i in 0..<image!.count{

                                    let name = NSUUID().uuidString.lowercased()
                                    multiPart.append(image![i], withName: imageName, fileName: "\(name).png", mimeType: "image/png")
            
                                }
                   
                    
                }, to: request, method: .post, headers: headers).uploadProgress(queue: .main, closure: { progress in
                            //Current upload progress of file
                            print("Upload Progress: \(progress.fractionCompleted)")
                        
                        })
                        .responseJSON(completionHandler: { responseData in
                        //Do what ever you want to do with response
                        print(responseData)
                        if let data = responseData.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)") // original server data as UTF8 string
                            do{
                                let statusCode = responseData.response?.statusCode
                                // Get json data
                                let json = try JSON(data: data)
                                print(json)
                               // success(json, statusCode!)
                                if((responseData.result) != nil) {
                                    let swiftyJsonData = responseData.result as? [String : Any]
                                    completionHandler(json , statusCode!)
                                } else {
                                     //hideHud()
                                    VC.hideIndicator()
                                    print(responseData.result)
                                    completionHandler([:]
        , statusCode!)
                                }
                            }catch{
                                // hideHud()
                                print("Unexpected error: \(error).")
                               // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                                VC.hideIndicator()
                                AlertController.alert(title: "Message", message: "  Could not connect to the server.")
                            }
                        }else{
                            // hideHud()
                           // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                            VC.hideIndicator()
                            AlertController.alert(title: "Message", message: "  Could not connect to the server.")
                        }
                    })
            }
    
    
    
    
    // Attachment with Image and aparameters.
   // let FileType = FileTypeClass()
  
        func uploadImageWithParameterImg_Attch( request: String, parameters: [String:Any]?,image:Data?,Attachment: [Data]?, SingleAttachment: Data?, SingleAttachment1: Data?,SingleAttachment2: Data?, VC: UIViewController,headers: HTTPHeaders,imageName:String,AttachmentName:String,SingleAttachmentName1:String, SingleAttachmentName2:String, SingleAttachmentName3:String, FileType:String, AddresProffFileName: String,IDProffFileName: String,LicenseFileNames: [String]?,ProffOf_Insurence_FileName: String, withCompletion completionHandler: @escaping webServiceResponse) {
        
                let reuestUrl = request
//                            let headers: HTTPHeaders = [
//                                "Authorization":"Basic bml0aW50eWFnaTpwYXNzd29yZEAxMjM="
//                            ]
            
            AF.upload(multipartFormData: { multiPart in
//                if let allParams = parameters as? [String:String] {
//                    for (key, value) in allParams {
//                        multiPart.append(value.data(using: .utf8)!, withName: key)
//                    }
//                }
                
                let allParams = parameters
                for (key, value) in allParams ?? [:]{
                    if let value = value as? String{
                        multiPart.append(value.data(using: .utf8)!, withName: key)
                    }else if let value = value as? NSArray{
                        for val in value{
                            let valu = val as? String ?? ""
                            multiPart.append(valu.data(using: .utf8)!, withName: key)
                        }
                    }
                  //  print(multiPart, "multipart")
                }
                
                
              
     
                if let AttchmentExist0 = SingleAttachment {
                    let FileType1 = FileType
                    let name = AddresProffFileName//NSUUID().uuidString.lowercased()
                    let fileArray = name.components(separatedBy: ".")
                    let firstName = fileArray.first ?? ""
                    let Nme = NSUUID().uuidString.lowercased()
                    if name == ""{
                        multiPart.append(AttchmentExist0, withName: SingleAttachmentName1, fileName: "\(Nme).jpg", mimeType: "image/jpeg")
                    }else if name.contains(s: ".jpg"){
                        multiPart.append(AttchmentExist0, withName: SingleAttachmentName1, fileName: "\(name).jpg", mimeType: "image/jpeg")
                    }else{
                        multiPart.append(AttchmentExist0, withName: SingleAttachmentName1, fileName: "\(name)." + FileType1, mimeType: "application/msword")
                    }
                }
                
                
                if let AttchmentExist1 = SingleAttachment1 {
                    let FileType1 = FileType
                    let name = IDProffFileName//NSUUID().uuidString.lowercased()
                    let fileArray = name.components(separatedBy: ".")
                    let firstName = fileArray.first ?? ""
                    let Nme = NSUUID().uuidString.lowercased()
                    if name == ""{
                        multiPart.append(AttchmentExist1, withName: SingleAttachmentName2, fileName: "\(Nme).jpg", mimeType: "image/jpeg")
                    }else if name.contains(s: ".jpg"){
                        multiPart.append(AttchmentExist1, withName: SingleAttachmentName2, fileName: "\(name).jpg", mimeType: "image/jpeg")
                    }else{
                        multiPart.append(AttchmentExist1, withName: SingleAttachmentName2, fileName: "\(name)." + FileType1, mimeType: "application/msword")
                    }
                }
                
                if let AttchmentExist2 = SingleAttachment2 {
                    let FileType1 = FileType
                    let name = ProffOf_Insurence_FileName//NSUUID().uuidString.lowercased()
                    let fileArray = name.components(separatedBy: ".")
                    let firstName = fileArray.first ?? ""
                    let Nme = NSUUID().uuidString.lowercased()
                    if name == ""{
                        multiPart.append(AttchmentExist2, withName: SingleAttachmentName3, fileName: "\(Nme).jpg", mimeType: "image/jpeg")
                        
                    }else if name.contains(s: ".jpg"){
                        multiPart.append(AttchmentExist2, withName: SingleAttachmentName3, fileName: "\(name).jpg", mimeType: "image/jpeg")
                    }else{
                        multiPart.append(AttchmentExist2, withName: SingleAttachmentName3, fileName: "\(name)." + FileType1, mimeType: "application/msword")
                    }
                }
                //
                
                for i in 0..<Attachment!.count{
                    //let FileType1 = FileType
                    let name = LicenseFileNames![i]//NSUUID().uuidString.lowercased()
                    let Nme = NSUUID().uuidString.lowercased()
                    if name == ""{
                        multiPart.append(Attachment![i], withName: AttachmentName, fileName: "\(Nme).jpg", mimeType: "image/jpeg")
                        
                    }else if name.contains(s: ".jpg"){
                        multiPart.append(Attachment![i], withName: AttachmentName, fileName: "\(name).jpg", mimeType: "image/jpeg")
                    }else{
                        multiPart.append(Attachment![i], withName: AttachmentName, fileName: "\(name)", mimeType: "application/msword")
                    }
                }
                
                
                
                if let imgExist = image {
                    let name = NSUUID().uuidString.lowercased()
                    multiPart.append(imgExist, withName: imageName, fileName: "\(name).jpg", mimeType: "image/jpeg")
                }
               
                
            }, to: request, method: .post, headers: headers).uploadProgress(queue: .main, closure: { progress in
                        //Current upload progress of file
                        print("Upload Progress: \(progress.fractionCompleted)")
                    
                    })
                    .responseJSON(completionHandler: { responseData in
                    //Do what ever you want to do with response
                    print(responseData)
                    if let data = responseData.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)") // original server data as UTF8 string
                        do{
                            let statusCode = responseData.response?.statusCode
                            // Get json data
                            let json = try JSON(data: data)
                            print(json)
                           // success(json, statusCode!)
                            if((responseData.result) != nil) {
                                let swiftyJsonData = responseData.result as? [String : Any]
                                completionHandler(json , statusCode!)
                            } else {
                                 //hideHud()
                                VC.hideIndicator()
                                print(responseData.result)
                                completionHandler([:]
    , statusCode!)
                            }
                        }catch{
                            // hideHud()
                            completionHandler([:], 4005)
                            VC.hideIndicator()
                            print("Unexpected error: \(error).")
                           // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                            AlertController.alert(title: "Message", message: "  Could not connect to the server.")
                        }
                    }else{
                        // hideHud()
                       // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                        completionHandler([:], 4005)
                        VC.hideIndicator()
                        AlertController.alert(title: "Message", message: "  Could not connect to the server.")
                    }
                })
        }
    
//    // Attachment with Image and aparameters.
//
//    let FileType1 = FileTypeClass1()
//
//    func uploadImageWithParameterImg_Attch1( request: String, image:Data?, Attachment: [Data]?, parameters: [String:Any]?,imageName:String,AttachmentName:String, withCompletion completionHandler: @escaping webServiceResponse) {
//
//        let reuestUrl = request
//        let headers: HTTPHeaders = [
//            "Authorization":"Basic bml0aW50eWFnaTpwYXNzd29yZEAxMjM="
//        ]
//
//    AF.upload(multipartFormData: { multiPart in
//        if let allParams = parameters as? [String:String] {
//            for (key, value) in allParams {
//                multiPart.append(value.data(using: .utf8)!, withName: key)
//            }
//        }
////                if let AttchmentExist = Attachment {
////                    let FileType1 = self.FileType.sharedInstance.FileType
////                    let name = NSUUID().uuidString.lowercased()
////                    multiPart.append(AttchmentExist, withName: AttachmentName, fileName: "\(name)." + FileType1, mimeType: "application/msword")
////                }
//
//
//        for i in 0..<Attachment!.count{
//            let FileType1 = self.FileType1.sharedInstance.FileType
//                        let name = NSUUID().uuidString.lowercased()
//                        multiPart.append(Attachment![i], withName: AttachmentName, fileName: "\(name)." + FileType1, mimeType: "application/msword")
//
//                    }
//
//
//
//                if let imgExist = image {
//                    let name = NSUUID().uuidString.lowercased()
//                    multiPart.append(imgExist, withName: imageName, fileName: "\(name).jpeg", mimeType: "image/jpeg")
//                }
//
//    }, to: request, method: .post, headers: headers).uploadProgress(queue: .main, closure: { progress in
//                //Current upload progress of file
//                print("Upload Progress: \(progress.fractionCompleted)")
//
//            })
//            .responseJSON(completionHandler: { responseData in
//            //Do what ever you want to do with response
//            print(responseData)
//            if let data = responseData.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//                do{
//                    let statusCode = responseData.response?.statusCode
//                    // Get json data
//                    let json = try JSON(data: data)
//                    print(json)
//                   // success(json, statusCode!)
//                    if((responseData.result) != nil) {
//                        let swiftyJsonData = responseData.result as? [String : Any]
//                        completionHandler(json , statusCode!)
//                    } else {
//                         //hideHud()
//                        print(responseData.result)
//                        completionHandler([:]
//, statusCode!)
//                    }
//                }catch{
//                    // hideHud()
//                    print("Unexpected error: \(error).")
//                   // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
//                }
//            }else{
//                // hideHud()
//               // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
//            }
//        })
//}
//
//    // Attachment with Image and aparameters.
//
//    let FileType2 = FileTypeClass2()
//
//    func uploadImageWithParameterImg_Attch2( request: String, image:Data?, Attachment: Data?, parameters: [String:Any]?,imageName:String,AttachmentName:String, withCompletion completionHandler: @escaping webServiceResponse) {
//
//        let reuestUrl = request
//        let headers: HTTPHeaders = [
//            "Authorization":"Basic bml0aW50eWFnaTpwYXNzd29yZEAxMjM="
//        ]
//
//    AF.upload(multipartFormData: { multiPart in
//        if let allParams = parameters as? [String:String] {
//            for (key, value) in allParams {
//                multiPart.append(value.data(using: .utf8)!, withName: key)
//            }
//        }
//                if let AttchmentExist = Attachment {
//                    let FileType = self.FileType2.sharedInstance1.FileType
//                    let name = NSUUID().uuidString.lowercased()
//                    multiPart.append(AttchmentExist, withName: AttachmentName, fileName: "\(name)." + FileType, mimeType: "application/msword")
//                }
//
//
////        for i in 0..<Attachment!.count{
////            let FileType1 = self.FileType1.sharedInstance.FileType
////                        let name = NSUUID().uuidString.lowercased()
////                        multiPart.append(Attachment![i], withName: AttachmentName, fileName: "\(name)." + FileType1, mimeType: "application/msword")
////
////                    }
//
//
//
//                if let imgExist = image {
//                    let name = NSUUID().uuidString.lowercased()
//                    multiPart.append(imgExist, withName: imageName, fileName: "\(name).jpeg", mimeType: "image/jpeg")
//                }
//
//    }, to: request, method: .post, headers: headers).uploadProgress(queue: .main, closure: { progress in
//                //Current upload progress of file
//                print("Upload Progress: \(progress.fractionCompleted)")
//
//            })
//            .responseJSON(completionHandler: { responseData in
//            //Do what ever you want to do with response
//            print(responseData)
//            if let data = responseData.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//                do{
//                    let statusCode = responseData.response?.statusCode
//                    // Get json data
//                    let json = try JSON(data: data)
//                    print(json)
//                   // success(json, statusCode!)
//                    if((responseData.result) != nil) {
//                        let swiftyJsonData = responseData.result as? [String : Any]
//                        completionHandler(json , statusCode!)
//                    } else {
//                         //hideHud()
//                        print(responseData.result)
//                        completionHandler([:]
//, statusCode!)
//                    }
//                }catch{
//                    // hideHud()
//                    print("Unexpected error: \(error).")
//                   // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
//                }
//            }else{
//                // hideHud()
//               // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
//            }
//        })
//}
    
    //bank_proof
    func uploadLicenseImageWithParameter(_ request: String,_ imageFront:Data?,_ imageBack:Data?,_ bank_proofDoc:Data?,VC: UIViewController,_ parameters: [String:Any]?,headers: HTTPHeaders,imageFrontName:String,imageBackName:String, BanKProofDoc: String, FileType:String, withCompletion completionHandler: @escaping webServiceResponse) {
            
            let reuestUrl = request
//            let headers: HTTPHeaders = [
//                "Authorization":"Basic bml0aW50eWFnaTpwYXNzd29yZEAxMjM=",
//                "Content-Type":"multipart/form-data"
//            ]
        
        AF.upload(multipartFormData: { multiPart in
            let allParams = parameters as? [String:String]
            for (key, value) in allParams ?? [:]{
                multiPart.append(value.data(using: .utf8)!, withName: key)
            }
            
            if let imgExist = imageFront {
                let name = NSUUID().uuidString.lowercased()
                multiPart.append(imgExist, withName: imageFrontName, fileName: "\(name).jpeg", mimeType: "image/jpeg")
            }
            
            if let imgExist = imageBack {
                let name = NSUUID().uuidString.lowercased()
                multiPart.append(imgExist, withName: imageBackName, fileName: "\(name).jpeg", mimeType: "image/jpeg")
            }
            
            if let DocExist = bank_proofDoc {
                let name = NSUUID().uuidString.lowercased()
                multiPart.append(DocExist, withName: BanKProofDoc, fileName: "\(name)." + FileType, mimeType: "application/msword")
            }
            
            
        }, to: request, method: .post, headers: headers).uploadProgress(queue: .main, closure: { progress in
                    //Current upload progress of file
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                .responseJSON(completionHandler: { responseData in
                //Do what ever you want to do with response
                print(responseData)
                if let data = responseData.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                    do{
                        let statusCode = responseData.response?.statusCode
                        // Get json data
                        let json = try JSON(data: data)
                        print(json)
                       // success(json, statusCode!)
                        if((responseData.result) != nil) {
                            let swiftyJsonData = responseData.result as? [String : Any]
                            completionHandler(json , statusCode!)
                        } else {
                            // hideHud()
                            VC.hideIndicator()
                            print(responseData.result)
                            completionHandler([:], statusCode!)
                        }
                    }catch{
                        // hideHud()
                        VC.hideIndicator()
                        print("Unexpected error: \(error).")
                       // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                        AlertController.alert(title: "Message", message: "  Could not connect to the server.")
                    }
                }else{
                    // hideHud()
                    VC.hideIndicator()
                   // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                    AlertController.alert(title: "Message", message: "  Could not connect to the server.")
                }
            })
    }
    
 
    func uploadAttachmentImageWithParameter(_ request: String,_ originalImage:Data?,_ thumbnailImage:Data?,headers: HTTPHeaders,VC: UIViewController,_ parameters: [String:Any]?, withCompletion completionHandler: @escaping webServiceResponse) {
            
            let reuestUrl = request
//            let headers: HTTPHeaders = [
////                "Authorization":"Basic bml0aW50eWFnaTpwYXNzd29yZEAxMjM="
//            ]
        
        AF.upload(multipartFormData: { multiPart in
            let allParams = parameters as? [String:String]
            for (key, value) in allParams ?? [:]{
                multiPart.append(value.data(using: .utf8)!, withName: key)
            }
            
            if let imgExist = originalImage {
                let name = NSUUID().uuidString.lowercased()
                multiPart.append(imgExist, withName: "orginalFile", fileName: "\(name).jpeg", mimeType: "image/jpeg")
            }
            
            if let imgExist = thumbnailImage {
                let name = NSUUID().uuidString.lowercased()
                multiPart.append(imgExist, withName: "thumbnails", fileName: "\(name).jpeg", mimeType: "image/jpeg")
            }
            
            
        }, to: request, method: .post, headers: headers).uploadProgress(queue: .main, closure: { progress in
                    //Current upload progress of file
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                .responseJSON(completionHandler: { responseData in
                //Do what ever you want to do with response
                print(responseData)
                if let data = responseData.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                    do{
                        let statusCode = responseData.response?.statusCode
                        // Get json data
                        let json = try JSON(data: data)
                        print(json)
                       // success(json, statusCode!)
                        if((responseData.result) != nil) {
                            let swiftyJsonData = responseData.result as? [String : Any]
                            completionHandler(json , statusCode!)
                        } else {
                            print(responseData.result)
                            completionHandler([:], statusCode!)
                        }
                    }catch{
                        print("Unexpected error: \(error).")
                       // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                        VC.hideIndicator()
                        AlertController.alert(title: "Message", message: "  Could not connect to the server.")
                    }
                }else{
                   // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                    VC.hideIndicator()
                    AlertController.alert(title: "Message", message: "  Could not connect to the server.")
                }
            })
        
       
    }
    
    
    func servicePostWithFoamDataParameter(_ request: String,VC: UIViewController, _ parameters: [String:Any]?, headers: HTTPHeaders,withCompletion completionHandler: @escaping webServiceResponse) {
            
            let reuestUrl = request
//            let headers: HTTPHeaders = [
//                //"Content-Type": "application/x-www-form-urlencoded"
//             // "Authorization":"Basic bml0aW50eWFnaTpwYXNzd29yZEAxMjM="
//            ]
        
        AF.upload(multipartFormData: { multiPart in
            if let allParams = parameters as? [String:String] {
                for (key, value) in allParams {
                    multiPart.append(value.data(using: .utf8)!, withName: key)
                }
            }
            
        }, to: request, method: .post, headers: headers).uploadProgress(queue: .main, closure: { progress in
                    //Current upload progress of file
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                .responseJSON(completionHandler: { responseData in
                //Do what ever you want to do with response
                print(responseData)
                    if let data = responseData.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                    do{
                        let statusCode = responseData.response?.statusCode
                        // Get json data
                        let json = try JSON(data: data)
                        print(json)
                       // success(json, statusCode!)
                        if((responseData.result) != nil) {
                            let swiftyJsonData = responseData.result as? [String : Any]
                            completionHandler(json , statusCode!)
                        } else {
                            print(responseData.result)
                            completionHandler([:], statusCode!)
                        }
                    }catch{
                        print("Unexpected error: \(error).")
                        VC.hideIndicator()
                       // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                        AlertController.alert(title: "Message", message: "  Could not connect to the server.")
                    }
                }else{
                   // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                    VC.hideIndicator()
                    AlertController.alert(title: "Message", message: "  Could not connect to the server.")
                }
            })
        
    }
    
    
//    static func getTokenTwilio1(complition: @escaping (String,String) -> Void)  {
//        guard let user_id = UserDefaults.standard.object(forKey: UserDetail.shared.getUserId()) as? String, user_id != "" else{
//            return
//        }
//        
////        http://anothercz.yilstaging.com/chat/get_access_token
//        
//   //     let para : JSONDictionary = ["user_id":"219"]
//        var para = [String: Any]()
//        let UserType = UserDetail.shared.getUserType()
//        if UserType == "User"{
//            para["user_id"] = UserDetail.shared.getUserId() + "member"
//        }else{
//            para["user_id"] = UserDetail.shared.getUserId() + "provider"
//        }
//       // let para : JSONDictionary = ["user_id":user_id]
//
//        let url = Roam_chat_url
//        
//        
//         let c  = UserDetail.shared.getTokenWith()
//                 
//                 let headers: HTTPHeaders = [
//                               // "Content-Type": "application/x-www-form-urlencoded"
//                              "Authorization": c
//                            ]
//           // let url = baseUrl_chat + WebServices.EndPoint.get_access_token.rawValue
//        
//        WebService.shared.postServiceURLEncoding(url, VC: UIViewController(), andParameter: para, headers: headers, withCompletion:  { (json, statusCode) in
//       
//      //  self.hideIndicator()
//         
//         guard let dictData = json.dictionaryObject else{
//             return
//         }
//          
//            if dictData["success"] as? Bool == true{
//                if let token = dictData["token"] as? String{
//                    UserDetail.shared.setTwilioToken(token)
//                   UserDefaults.standard.synchronize()
//                    
//                    let identity = dictData["identity"] as? String
//                    UserDetail.shared.setTwilioIdentity(identity ?? "")
//                       UserDefaults.standard.synchronize()
//                    
//                    print(token,"userDefaultKey.twilioToken",identity ?? "")
//                    complition(token,identity ?? "")
//                }
//               }else{
//                   
////                   let responseMessage = dictData["message"] as! String
////                   self.showAlert(for: responseMessage)
//               }
//        })
//
//        }

    // ServicefoamDatawithImage
    
    func servicePostWithFoamDataParameterWithImage( request: String,VC: UIViewController, originalImage:Data?,_ parameters: [String:Any]?, headers: HTTPHeaders, withCompletion completionHandler: @escaping webServiceResponse) {
        
        let reuestUrl = request
//        let headers: HTTPHeaders = [
//            "Content-Type": "multipart/form-data" //"application/x-www-form-urlencoded"
//            // "Authorization":"Basic bml0aW50eWFnaTpwYXNzd29yZEAxMjM="
//        ]
        
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
                print("Failed to serialize JSON data")
                return
            }
        
        AF.upload(multipartFormData: { multipartFormData in
           
            multipartFormData.append(jsonData, withName: "data", mimeType: "application/json")
            
            if let imgExist = originalImage {
                let name = NSUUID().uuidString.lowercased()
                multipartFormData.append(imgExist, withName: "profile_image", fileName: "\(name).jpeg", mimeType: "image/jpeg")
            }
            
        }, to: request, method: .post, headers: headers).uploadProgress(queue: .main, closure: { progress in
            //Current upload progress of file
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseJSON(completionHandler: { responseData in
            //Do what ever you want to do with response
            print(responseData)
            if let data = responseData.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                do{
                    let statusCode = responseData.response?.statusCode
                    // Get json data
                    let json = try JSON(data: data)
                    print(json)
                    // success(json, statusCode!)
                    if((responseData.result) != nil) {
                        let swiftyJsonData = responseData.result as? [String : Any]
                        completionHandler(json , statusCode!)
                    } else {
                        print(responseData.result)
                        completionHandler([:], statusCode!)
                    }
                }catch{
                    VC.hideIndicator()
                    completionHandler([:], 411)
                    print("Unexpected error: \(error).")
                    // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
                }
            }else{
                VC.hideIndicator()
                completionHandler([:], 411)
                print("Unexpected error")
                
                // self.showToast("Something went wrong")
                
                //   AppDelegate.shared.toastView(messsage: "Something went wrong", view:  )
                // alertUser(strTitle: "Message", strMessage: "  Could not connect to the server.")
            }
        })
        
    }
    
    /*
    func getAppleMusicPlaylist(_ request: String, token : String, developerToken :String, andParameter parameters: [String:Any]?, withCompletion completionHandler: @escaping webServiceResponse) {
        
        let reuestUrl =  "https://api.music.apple.com/v1/me/library/playlists"
        
        var encodingFormat: ParameterEncoding = JSONEncoding()
        if request == "" {
            encodingFormat = URLEncoding()
        }
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type":"application/json",
            "Authorization":"Bearer \(token)","Music-User-Token":developerToken
        ]
        AF.request(reuestUrl, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).responseJSON{ (responseData) in
            
            if responseData.result.isSuccess {
                if((responseData.result.value) != nil) {
                    let swiftyJsonData = responseData.result.value as? [String : Any]
                    completionHandler(swiftyJsonData! , nil)
                } else {
                    print(responseData.result)
                }
            } else {
                completionHandler([:], responseData.error)
            }
        }
    }
    
    func getAppleMusicSongDetails(_ request: String, token : String, developerToken :String,storeFrontId:String, songId:String ,andParameter parameters: [String:Any]?, withCompletion completionHandler: @escaping webServiceResponse) {
        
        let reuestUrl =  "https://api.music.apple.com/v1/catalog/\(storeFrontId)/songs/\(songId)"
        
        var encodingFormat: ParameterEncoding = JSONEncoding()
        if request == "" {
            encodingFormat = URLEncoding()
        }
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type":"application/json",
            "Authorization":"Bearer \(token)","Music-User-Token":developerToken
        ]
        Alamofire.request(reuestUrl, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).responseJSON{ (responseData) in
            
            if responseData.result.isSuccess {
                if((responseData.result.value) != nil) {
                    let swiftyJsonData = responseData.result.value as? [String : Any]
                    completionHandler(swiftyJsonData! , nil)
                } else {
                    print(responseData.result)
                }
            } else {
                completionHandler([:], responseData.error)
            }
        }
    }
    
    func getSpotifyService(_ request: String, token : String, andParameter parameters: [String:Any]?, withCompletion completionHandler: @escaping webServiceResponse) {
        
        let reuestUrl =  request
        
        var encodingFormat: ParameterEncoding = JSONEncoding()
        if request == "" {
            encodingFormat = URLEncoding()
        }
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type":"application/json",
            "Authorization":"Bearer \(token)"
        ]
        Alamofire.request(reuestUrl, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).responseJSON{ (responseData) in
            
            if responseData.result.isSuccess {
                if((responseData.result.value) != nil) {
                    let swiftyJsonData = responseData.result.value as? [String : Any]
                    completionHandler(swiftyJsonData! , nil)
                } else {
                    print(responseData.result)
                }
            } else {
                completionHandler([:], responseData.error)
            }
        }
    }
    
    func postSpotifyService(_ request: String, token : String, andParameter parameters: [String:Any]?, withCompletion completionHandler: @escaping webServiceResponse) {
        
        let reuestUrl =  request
        
        var encodingFormat: ParameterEncoding = JSONEncoding()
        if request == "" {
            encodingFormat = JSONEncoding() //URLEncoding()
        }
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(token)"
        ]
        Alamofire.request(reuestUrl, method: .post, parameters: parameters!, encoding: encodingFormat, headers: headers).responseJSON{ (responseData) in
            
            if responseData.result.isSuccess {
                if((responseData.result.value) != nil) {
                    let swiftyJsonData = responseData.result.value as? [String : Any]
                    completionHandler(swiftyJsonData! , nil)
                } else {
                    print(responseData.result)
                }
            } else {
                completionHandler([:], responseData.error)
            }
        }
    }
    
    func putSpotifyService(_ request: String, token : String, andParameter parameters: [String:Any], withCompletion completionHandler: @escaping webServiceResponse) {
        
        let reuestUrl =  request
        /*
        let headers = [
            "Content-Type":"image/jpeg",
            "Authorization":"Bearer \(token)",
            "Cache-Control": "no-cache"
        ]
        
        let postData = parameters.data(using: String.Encoding.utf8) // NSData(data: parameters.data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: request)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            //            if response.result.isSuccess {
            //                if((response.result.value) != nil) {
            //                    let swiftyJsonData = response.result.value as? [String : Any]
            //                    completionHandler(swiftyJsonData! , nil)
            //                } else {
            //                    print(response.result)
            //                }
            //            } else {
            //                completionHandler([:], response.error)
            //            }
            
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
        })
        
        dataTask.resume()
        
        */
        
                var encodingFormat: ParameterEncoding = URLEncoding()
                if request == "" {
                    encodingFormat = JSONEncoding() //URLEncoding()  ParameterEncoding()
                }
        
                let headers: HTTPHeaders = [
                    "Content-Type":"image/jpeg",
                    "Authorization":"Bearer \(token)",
                    "scope" : "playlist-modify-public"
                ]
        Alamofire.request(reuestUrl, method: .put, parameters: parameters, encoding:encodingFormat , headers: headers).responseJSON{ (responseData) in
        
                    if responseData.result.isSuccess {
                        if((responseData.result.value) != nil) {
                            let swiftyJsonData = responseData.result.value as? [String : Any]
                            completionHandler(swiftyJsonData! , nil)
                        } else {
                            print(responseData.result)
                        }
                    } else {
                        completionHandler([:], responseData.error)
                    }
                }
    }
    
    func callGetService(urlString:String, withCompletion completionHandler: @escaping webServiceResponse)  {
        
        let url = URL(string: urlString)
        
        Alamofire.request(url!).validate()
            .responseJSON { (responseData) in
                
                if responseData.result.isSuccess {
                    if((responseData.result.value) != nil) {
                        let swiftyJsonData = responseData.result.value as? [String : Any]
                        completionHandler(swiftyJsonData!, nil)
                    } else {
                        print(responseData.result)
                    }
                } else {
                    completionHandler([:], responseData.error)
                }
        }
    }
    
    
    func uploadImageWithParameter(_ request: String,_ image:Data?,_ parameters: [String:Any]?, withCompletion getResponse: @escaping webServiceResponse) {
        
        let reuestUrl = request
//        let headers: HTTPHeaders = [
//            /* "Authorization": "your_access_token",  in case you need authorization header */
//            "Content-type": "multipart/form-data"
//        ]
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imgExist = image {
                let name = NSUUID().uuidString.lowercased()
                multipartFormData.append(imgExist, withName: "avatar", fileName: "\(name).jpeg", mimeType: "image/jpeg")
            }
            
            if let allParams = parameters as? [String:String] {
                for (key, value) in allParams {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
            }}, to: reuestUrl, method: .post, headers:nil,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        
                        upload.responseJSON { response in
                            guard response.result.error == nil else {
                                print("error response")
                                print(response.result.error ?? "error response")
                                getResponse([:],response.result.error)
                                
                                return
                            }
                            if let value = response.result.value {
                                print(value)
                                getResponse(value as! [String : Any],nil)
                            }
                        }
                    case .failure(let encodingError):
                        print("error:\(encodingError)")
                        getResponse([:], encodingError)
                    }
        })
    }
    
    func uploadVoiceRecording_ImageWithParameter(_ request: String,_ image:Data?, _ recordingUrl : URL?,_ imageName : String,_ parameters: [String:Any]?, withCompletion getResponse: @escaping webServiceResponse) {
        
        let reuestUrl = request
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"
        ]
        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            
            if let allParams = parameters as? [String:String] {
                for (key, value) in allParams {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
            }
            if recordingUrl != nil{
                multipartFormData.append(recordingUrl!, withName: "voiceRecording")
            }
            
            if let imgExist = image {
                let name = NSUUID().uuidString.lowercased()
                if imageName == "profileImg"{
                    multipartFormData.append(imgExist, withName: "profileImg", fileName: "\(name).jpeg", mimeType: "image/jpeg")
                }else{
                    multipartFormData.append(imgExist, withName: "artworkImage", fileName: "\(name).jpeg", mimeType: "image/jpeg")
                }
            }
            
        }, to: reuestUrl, method: .post, headers:nil,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        
                        upload.responseJSON { response in
                            guard response.result.error == nil else {
                                print("error response")
                                print(response.result.error ?? "error response")
                                getResponse([:],response.result.error)
                                
                                return
                            }
                            if let value = response.result.value {
                                print(value)
                                getResponse(value as! [String : Any],nil)
                            }
                        }
                    case .failure(let encodingError):
                        print("error:\(encodingError)")
                        getResponse([:], encodingError)
                    }
        })
    }
    */
    
}
