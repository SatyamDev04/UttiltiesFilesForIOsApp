//
//  BaseResponse.swift
//  LawCo
//
//  Created by YATIN  KALRA on 12/06/24.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    let success: Bool
    let message: String?
    let data: T?
    
}
