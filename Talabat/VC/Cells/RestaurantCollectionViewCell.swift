//
//  RestaurantCollectionViewCell.swift
//  Talabat
//
//  Created by mostafa elsanadidy on 10/4/20.
//  Copyright © 2020 68lion. All rights reserved.
//

import UIKit
import CoreLocation

class RestaurantCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var rest_Imag: UIImageView!
    @IBOutlet weak var rest_name: UILabel!
    @IBOutlet weak var rest_location: UILabel!
    @IBOutlet weak var rest_type: UILabel!
    
    var updateSelectedCell_ID : ((_ selected_ID:Int) -> ())!
    
    func configure(with restaurant: restaurant_Data){
        
        print(restaurant)
        rest_name.text = restaurant.rest_name!
        rest_location.text = getcurrentAddress(with: restaurant.rest_location!)
        changeCellImage(with: restaurant.rest_img!)
        rest_type.text = restaurant.rest_type!
    }


        func changeCellImage( with itemImageStr: String) {

           let url = URL.init(string: itemImageStr)
           self.rest_Imag.af_setImage(withURL: url!, placeholderImage: UIImage.init(named: ""), filter: nil,  imageTransition:UIImageView.ImageTransition.crossDissolve(0.5) , runImageTransitionIfCached: true, completion: nil)
       }
    


    func getcurrentAddress(with location:String) -> String{
        
        let locations = location.split{$0 == ","}.map(String.init)
       // let longitude = locations[1].replacingOccurrences(of: " ", with: "")
        var addressStr = location
        
       if let longitude = CLLocationDegrees(locations[1])
        ,let latitude = CLLocationDegrees(locations[0])
       {
        let currentLocation = CLLocation.init(latitude: latitude, longitude: longitude)
        
            let geocoder = CLGeocoder()
                
            // Look up the location and pass it to the completion handler
        print(currentLocation)
            geocoder.reverseGeocodeLocation(currentLocation,
                        completionHandler: { (placemarks, error) in
                            print(placemarks ?? "")
            if error==nil , let p=placemarks , !p.isEmpty{
                
                let lastLocation = p.last!
                addressStr = self.string(from: lastLocation)
                }
            })
    }
        print(addressStr)
        return addressStr
  }
        
     func string(from placemark: CLPlacemark) -> String {
           var line = ""
           line.add(text: placemark.subThoroughfare)
           line.add(text: placemark.thoroughfare, separatedBy: " ")
           line.add(text: placemark.locality, separatedBy: ", ")
           line.add(text: placemark.administrativeArea, separatedBy: ", ")
//           line.add(text: placemark.postalCode, separatedBy: " ")
//           line.add(text: placemark.country, separatedBy: ", ")
           print("((((((((((((((( \(line) ))))))))))))")
           return line }

}
