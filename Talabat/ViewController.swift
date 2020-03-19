//
//  ViewController.swift
//  Talabat
//
//  Created by 68lion on 3/17/20.
//  Copyright © 2020 68lion. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var phoneTxtView: UITextView!
    @IBOutlet weak var passwordTxtView: UITextView!
    
    let urlStr = "http://talabat.art4muslim.net/api/"
    
    let headers = [
        "Content-Type":"application/json"
    ]
    
    var loginOfOwner = UserLogin_Result(){
        didSet{
            
            if self.loginOfOwner.status! == 200{
                
                self.performSegue(withIdentifier: "getResturants", sender: nil)
            }
            else{
                
                self.show_Error(errorMessageText: self.loginOfOwner.message!)
            }
        }}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func loginAction() {
        
        loginService(userName: phoneTxtView.text ?? "", password: passwordTxtView.text ?? "")
    }
    
    
    func show_Error(errorMessageText: String) {
        let alert = UIAlertController(
            title: "Whoops...",
            message:
            "There was an error \n \(errorMessageText). \n Please try again.",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func loginService(userName: String, password: String) {
       
           let loginUrlString = urlStr+"login"
            
           let newTodo : [String:Any] = ["mobile": userName,
                                         "password": password,
            "access_key":"Gdka52DASWE3DSasWE742Wq",
            "access_password":"yH52dDDF85sddEWqPNV7D12sW5e"
        ]
        
           let url = URL.init(string: loginUrlString)

        Alamofire.request(url!,
                             method: .post,
                             parameters: newTodo,
                             encoding: URLEncoding.default,
                             headers: headers)
               
               .responseJSON { (response:DataResponse) in
                   switch(response.result) {
                   case .success:
                       
                       print("\(response.value!)")
                       
                        
                       let temp = response.response?.statusCode ?? 400
                
                       if temp >= 300 {
                           
                           self.loginOfOwner = try! JSONDecoder().decode(UserLogin_Result.self, from: response.data!)
                           print(url!)
                           print("******************************** \(response.value!) **********************")
                           //  print("\()")
                           print(response.error?.localizedDescription)
                           print("errorrrrelse")
                           // print("")
                           
                       }else{
                           
                           self.loginOfOwner = try! JSONDecoder().decode(UserLogin_Result.self, from: response.data!)
                           UserDefaults.standard.set(response.data!, forKey:"UserLoginResult")
                           
                           
                           print("\(response.value)")
                           }
                   case .failure(_):
                       print("error")
                       
                       break
                   }
           }
           //moveToMyDetails()
           
           
           }
}

