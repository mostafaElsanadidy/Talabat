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

    @IBOutlet weak var phoneTxtView: UITextField!
    @IBOutlet weak var passwordTxtView: UITextField!
    @IBOutlet weak var phonView: UIView!
    @IBOutlet weak var loginBttn: UIButton!
    @IBOutlet weak var passwordView: UIView!
    
    
    
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
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
               backgroundImage.image = UIImage(named: "rsrvation")
               backgroundImage.contentMode = .scaleAspectFit
               self.view.insertSubview(backgroundImage, at: 0)
        
        phonView.layer.cornerRadius = 5
        phonView.layer.borderWidth = 0.7
        phonView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        passwordView.layer.cornerRadius = 5
        passwordView.layer.borderWidth = 0.7
        passwordView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        loginBttn.layer.cornerRadius = 5
        
       // phonView.layer.bor
    }

    
    @IBAction func loginAction() {
        
        loginService(userName: phoneTxtView.text!, password: passwordTxtView.text!)
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
       
           let loginUrlString = urlStr + "login"
            
        print("\(userName)  \(password)")
           
//        let login = Login(mobile: userName, password: password, access_key: "Gdka52DASWE3DSasWE742Wq", access_password: "yH52dDDF85sddEWqPNV7D12sW5e")
//
//        let params = ["mobile": "0123456789",
//                      "password": "123000",
//                      "access_key": "Gdka52DASWE3DSasWE742Wq",
//                      "access_password": "yH52dDDF85sddEWqPNV7D12sW5e"
//        ]
//
        
 //       print("\(login)")
           let url = URL.init(string: loginUrlString)

        
        Alamofire.request(url!,
                             method: .post,
                             parameters: [:],
                             encoding: JSONStringArrayEncoding.init(string: "{\n\"mobile\":\"\(userName)\",\n\"password\":\"\(password)\",\n\"access_key\":\"Gdka52DASWE3DSasWE742Wq\",\n\"access_password\":\"yH52dDDF85sddEWqPNV7D12sW5e\"\n}"
), headers: [:])
               
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

