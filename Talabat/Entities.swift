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

struct GetRestaurants_Details: Decodable {

    var status:Int?
    var sub_message:String?
    var `return`:[restaurant_Data]?
    var message:String?
}

struct restaurant_Data: Decodable {

    var rest_id:String?
    var rest_name:String?
    var rest_img:String?
    var rest_location:String?
    var rest_type:String?
}

struct GetRestaurantOrders_Details: Decodable {

    var status:Int?
    var sub_message:String?
    var `return`:[restaurantOrder_Data]?
    var message:String?
   }

struct restaurantOrder_Data: Decodable{

    var order_id: String?
    var order_user: String?
    var order_price: String?
    var user_location: String?
    var resturant_name: String?
    var order_details: [order_Details]?
  }

struct order_Details: Decodable {
                   
    var prod_name: String?
    var prod_quantity: Int?
    var prod_price: String?
    var prod_image:String?
}

struct JSONStringArrayEncoding: ParameterEncoding {
private let myString: String

init(string: String) {
    self.myString = string
}

func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
    var urlRequest = urlRequest.urlRequest

      let data = myString.data(using: .utf8)!

    if urlRequest?.value(forHTTPHeaderField: "Content-Type") == nil {
        urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    urlRequest?.httpBody = data

    return urlRequest!
}}





class restaurantCollectionViewCell: UICollectionViewCell{
    
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
        var addressStr = location
        
       if let longitude = CLLocationDegrees(locations[1])
        ,let latitude = CLLocationDegrees(locations[0])
       {
        let currentLocation = CLLocation.init(latitude: latitude, longitude: longitude)
        
            let geocoder = CLGeocoder()
                
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(currentLocation,
                        completionHandler: { (placemarks, error) in
            if error==nil , let p=placemarks , !p.isEmpty{
                
                let lastLocation = p.last!
                addressStr = self.string(from: lastLocation)
                }
            })
    }
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




class CustomMarkerView: UIView {
    var img: UIImage!
    var borderColor: UIColor!
    
    init(frame: CGRect, image: UIImage, borderColor: UIColor, tag: Int) {
        super.init(frame: frame)
        self.img=image
        self.borderColor=borderColor
        self.tag = tag
        setupViews()
    }
    
    func setupViews() {
        let imgView = UIImageView(image: img)
        imgView.backgroundColor = .white
        imgView.frame=CGRect(x: 0, y: 0, width: 50, height: 50)
        imgView.layer.cornerRadius = 25
        imgView.layer.borderColor=borderColor?.cgColor
        imgView.layer.borderWidth=4
        imgView.clipsToBounds=true
        let lbl=UILabel(frame: CGRect(x: 0, y: 45, width: 50, height: 10))
        lbl.text = "▾"
        lbl.font=UIFont.systemFont(ofSize: 24)
        lbl.textColor = borderColor
        lbl.textAlignment = .center
        
        self.addSubview(imgView)
        self.addSubview(lbl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
