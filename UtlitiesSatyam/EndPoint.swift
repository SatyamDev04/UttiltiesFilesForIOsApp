//
//  EndPoints.swift
//  RPG
//
//  Created by YATIN  KALRA on 12/02/24.
//

import Foundation

extension Notification.Name {
    static let locationDidUpdate = Notification.Name("locationDidUpdate")
}

struct AppKeys {
    static let  googleAPi = "AIzaSyC9NuN_f-wESHh3kihTvpbvdrmKlTQurxw"
    static let googleMapAPI = "AIzaSyBh1m5LWl-qV1nVkT1WZeWAzng5eP42RNk"
}
struct AppLocation {
    static var  lat = ""
    static var  long = ""
    static var  Address = ""
    static var  city = ""
    static var  state = ""
    static var  zip = ""
}
struct AppURL {
    
    static let baseURL = ""
    static let imageURL = ""
    static let imageURLAbousUs = ""
}

extension AppURL {
    
    enum Endpoint: String {
        
        case login                    =   "Login"
        case socialLogin              =   "social_login"
        
        
        var path: String {
            let url = AppURL.baseURL
            return url + self.rawValue
        }
        
    }
 
}
