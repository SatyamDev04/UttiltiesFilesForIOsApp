//
//  joinedModelClass.swift
//  Melo
//
//  Created by YES IT Labs on 25/08/23.
//

import Foundation
  
class joinedModelClass: NSObject {
   
    var profileimage : String = ""
    var user_id : Int?
    var Name : String = ""
 
     class func getJoinedDetails(responseArray : [[String : Any]])-> [joinedModelClass]{
         
         var JoinedDetails = [joinedModelClass]()
         
         
         for tempDict in responseArray{
             
             let tempobj = joinedModelClass()
             
             tempobj.user_id = tempDict.validatedValue("user_id", expected: Int() as AnyObject) as? Int
             tempobj.profileimage = tempDict.validatedValue("profileimage", expected: "" as AnyObject) as? String ?? ""
             tempobj.Name = tempDict.validatedValue("name", expected: "" as AnyObject) as? String ?? ""
             
             JoinedDetails.append(tempobj)
             
         }
         
         return JoinedDetails
     }
}
