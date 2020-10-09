//
//  CustomNavVC.swift
//  Talabat
//
//  Created by mostafa elsanadidy on 10/4/20.
//  Copyright © 2020 68lion. All rights reserved.
//

import UIKit

class CustomNavVC: UINavigationController{

    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
