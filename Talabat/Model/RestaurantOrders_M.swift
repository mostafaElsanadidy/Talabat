//
//  RestaurantOrders_M.swift
//  Talabat
//
//  Created by mostafa elsanadidy on 10/9/20.
//  Copyright © 2020 68lion. All rights reserved.
//

import Foundation

struct restaurantOrder_Data: Decodable{

    var order_id: String?
    var order_user: String?
    var order_price: String?
    var user_location: String?
    var resturant_name: String?
    var order_details: [orderProducts_Details]?
  }

struct orderProducts_Details: Decodable {
                   
    var prod_name: String?
    var prod_quantity: Int?
    var prod_price: String?
    var prod_image:String?
}
