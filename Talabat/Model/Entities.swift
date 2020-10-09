//
//  Entities.swift
//  Talabat
//
//  Created by 68lion on 3/18/20.
//  Copyright © 2020 68lion. All rights reserved.
//
import Alamofire
import AlamofireImage
import CoreLocation

let urlStr = "http://talabat.art4muslim.net/api/"

struct Login: Encodable {
    let mobile: String
    let password: String
    let access_key: String
    let access_password: String
}


//struct GetRestaurants_Details: Decodable {
//
//    var status:Int?
//    var sub_message:String?
//    var `return`:[restaurant_Data]?
//    var message:String?
//}


