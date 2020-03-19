//
//  Entities.swift
//  Talabat
//
//  Created by 68lion on 3/18/20.
//  Copyright © 2020 68lion. All rights reserved.
//

import UIKit

extension UIView{
    
    func showSpinner(tag:Int){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    let spinner = UIActivityIndicatorView(
        style: .gray)
    spinner.center = CGPoint(x: self.bounds.midX + 0.5,
    y: self.bounds.midY + 0.5)
    spinner.tag = tag
    self.addSubview(spinner)
    spinner.startAnimating()
    }
    
    func hideSpinner(tag:Int){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.viewWithTag(tag)?.removeFromSuperview()
    }
    
}
struct UserLogin_Result: Decodable {

    var status:Int?
    var sub_message:String?
    var returnData:User_Data?
    var message:String?
}

struct User_Data : Decodable {
    
    var id:Int?
    var age:Int?
    var gender:String?
    var mobile:String?
    var password:String?
}

