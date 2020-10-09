//
//  ApiClient.swift
//  MadeInKuwait
//
//  Created by Amir on 1/29/20.
//  Copyright © 2020 Amir. All rights reserved.
//

import Alamofire
import SwiftyJSON

class APIClient {
    
    @discardableResult
    private static func performSwiftyRequest(route:APIRouter,_ completion:@escaping (JSON)->Void,_ failure:@escaping (Error?)->Void) -> DataRequest {
        return Alamofire.request(route)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success :
                    guard let _ = response.result.value else {
                        failure(response.result.error)
                        return
                    }
                    print(response.result , route.urlRequest as Any)
                    let json = JSON(response.result.value as Any)
                    print(json)
                    //                    if !(response.response?.statusCode == 200) {
                    //                        failure(response.result.error)
                    //                        return
                    //                    }
                    completion(json)
                    //
                    //                    if let status_code = json["status"].string {
                    //                        print(status_code)
                    //                        if status_code == "402"   { // TOKEN EXPIRE
                    //                            //API.REFRESH reSaveToken
                    //                            performSwiftyRequest(route: route, completion, failure)
                    //                        }else {
                    //                            completion(json)
                    //                        }
                    //                    }else {
                    //                        failure(response.result.error)
                    //                        completion(json)
                    //                    }
                //
                case .failure( _):
                    failure(response.result.error)
                }
            })
    }
    
    
    static func cancelAllRequests(completed : @escaping ()->() ) {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
            completed()
        }
    }
    
    static func login(username:String, password:String , completionHandler:@escaping (User_Data?)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
         performSwiftyRequest(route: .login(username: username, password: password), { (jsonData) in
            
            let sub_message = JSON(jsonData)["sub_message"].string
            guard sub_message == "success" else{
                return
            }
            let json_Data = try! JSON(jsonData)["return"].rawData()
            let user = try! JSONDecoder().decode(User_Data.self, from: json_Data)
             completionHandler(user)
         }) { (error) in
             completionFaliure(error)
         }
     }
    
    
    static func getRestaurants(langu:String, completionHandler:@escaping ([restaurant_Data]?)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .getResturants(langu: langu), { (jsonData) in
           
           let sub_message = JSON(jsonData)["sub_message"].string
           guard sub_message == "success" else{
            completionHandler(nil)
               return
           }
            let json_Data = try! JSON(jsonData)["return"].rawData()
           let restaurants_Data = try! JSONDecoder().decode(Array<restaurant_Data>.self, from: json_Data)
            completionHandler(restaurants_Data)
       }) { (error) in
            completionFaliure(error)
        }
    }
    

    static func getRestaurantOrders(restId:Int,langu:String, completionHandler:@escaping ([restaurantOrder_Data]?)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
           performSwiftyRequest(route: .getResturantOrders(restId: restId, langu: langu), { (jsonData) in
              
              let sub_message = JSON(jsonData)["sub_message"].string
              guard sub_message == "success" else{
               completionHandler(nil)
                  return
              }
              let json_Data = try! JSON(jsonData)["return"].rawData()
              let restaurant_Orders = try! JSONDecoder().decode(Array<restaurantOrder_Data>.self, from: json_Data)
              
               completionHandler(restaurant_Orders)
           }) { (error) in
               completionFaliure(error)
           }
       }
}
