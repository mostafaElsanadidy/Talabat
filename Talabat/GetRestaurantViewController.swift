//
//  GetRestaurantViewController.swift
//  Talabat
//
//  Created by mostafa elsanadidy on 3/22/20.
//  Copyright © 2020 68lion. All rights reserved.
//

import UIKit
import Alamofire

class GetRestaurantViewController: UIViewController {

    var isVertical = true
      var selectedIndex = 0
      @IBOutlet weak var collectionView: UICollectionView!
    
      let sectionInsets = UIEdgeInsets(top: 5.0,
                                       left: 20.0,
                                       bottom: 0.0,
                                       right: 20.0)
    
    var restaurantsUrl = ""
    
    
    var restaurants_Details = GetRestaurants_Details(){
    didSet{
        
        if self.restaurants_Details.status! == 200{
                       
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
//                       self.performSegue(withIdentifier: "getResturants", sender: nil)
                   }
                   else{
                       
                       self.show_Error(errorMessageText: self.restaurants_Details.message!)
                   }
            }
        }
    
    @IBAction func changeToGridForm() {
        
        isVertical = true
        collectionView.showSpinner(tag: 1000)
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        collectionView.hideSpinner(tag: 1000)
    
    }
    
    
    @IBAction func changeToListForm() {

        isVertical = false
        collectionView.showSpinner(tag: 1000)
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        collectionView.hideSpinner(tag: 1000)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
         restaurantsUrl = urlStr + "getResturants?langu=ar"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //title = "المطاعم"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        displayRstaurants()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let mapVieControllr = segue.destination as! MapViewController
        
        if let selectedCell = sender as? restaurantCollectionViewCell{
            
            print(")))))))))))))))))))))))^^^^^^^^^^^^^")
          selectedCell.updateSelectedCell_ID =
            {selected_ID in
                mapVieControllr.seletedRestaurantIndex = selected_ID
            }
        }
    }

}


extension GetRestaurantViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(restaurants_Details.return?.count ?? 0)
        return restaurants_Details.return?.count ?? 0
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "restaurantCell", for: indexPath) as! restaurantCollectionViewCell
        
        cell.configure(with: restaurants_Details.return![indexPath.row])
        
                print("\(cell.frame.height) mmo")
            
            return cell
        }
}



extension GetRestaurantViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        
        
        let paddingSpace = sectionInsets.left * 3
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / 2
        
        if !isVertical{
            return CGSize(width: widthPerItem, height: 210)}
        else{
            return CGSize(width: availableWidth+10, height: 210)
        }
        
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    //getRestaurantLocation
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? restaurantCollectionViewCell{
            performSegue(withIdentifier: "getRestaurantLocation", sender: cell)
       
            print("uuuuuoooooooyyyyy&&&")
            cell.updateSelectedCell_ID(indexPath.row)
        }
    }
    
    
}

extension GetRestaurantViewController{
    
    func displayRstaurants(){
    
        collectionView.showSpinner(tag: 1000)
        Alamofire.request(URL.init(string: restaurantsUrl)!,
                             method: .post,
                             parameters: [:],
                             encoding: JSONEncoding.default)
               
               .responseJSON { (response:DataResponse) in
                   switch(response.result) {
                   case .success:
                       
                       print("\(response.value!)")
                       
                        
                       let temp = response.response?.statusCode ?? 400
                
                       if temp >= 300 {
                           
                           self.restaurants_Details = try! JSONDecoder().decode(GetRestaurants_Details.self, from: response.data!)
                           
                       }else{
                           
                           self.restaurants_Details = try! JSONDecoder().decode(GetRestaurants_Details.self, from: response.data!)
                        UserDefaults.standard.set( response.data!, forKey: "restaurants_Details")
                           print("\(response.value)")
                           }
                   case .failure(_):
                       print("error")
                       
                       break
                   }
           }
        self.collectionView.hideSpinner(tag: 1000)
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
}
