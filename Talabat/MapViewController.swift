//
//  MapViewController.swift
//  Talabat
//
//  Created by 68lion on 3/18/20.
//  Copyright © 2020 68lion. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import GooglePlaces
import CoreLocation


class MapViewController: UIViewController ,GMSMapViewDelegate{

    
    let locationManager = CLLocationManager()
    
    var restLocation:CLLocation?
    var ordrLocation:CLLocation?
    var location: CLLocation?
    var updatingLocation = false
    var addressStatus=""
    var lastLocationError: Error?
    
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: Error?
    var timer: Timer?
    var seletedRestaurantIndex : Int?
    
    
    var restaurants_Details : GetRestaurants_Details!
    
     var restaurantOrders_Details = GetRestaurantOrders_Details(){
        didSet{
            
            if self.restaurantOrders_Details.status! == 200{
                           
                for ordr in self.restaurantOrders_Details.return!{
                    

                    let usrLocation = ordr.user_location!
                    let locations = usrLocation.split{$0 == ","}.map(String.init)
                    let longitude = locations[1].replacingOccurrences(of: " ", with: "")
                    
                    let marker=GMSMarker()
                    let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), image: UIImage(named: "Delivery")!, borderColor: UIColor.darkGray, tag: Int(ordr.order_id!)!)
                            marker.iconView=customMarker
                        
                    if let longitude = CLLocationDegrees(longitude)
                    ,let latitude = CLLocationDegrees(locations[0]){
                            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        marker.map = self.myMapView}
                    //self.myMapView.animate(toLocation: marker.position)
                }
    
                       }
//                       else{
//
//                         self.show_Error(errorMessageText: self.restaurants_Details.message!)
//                       }
            
//            collectionView.hideSpinner(tag: 1000)
        }
    }
    
    @IBOutlet weak var barImage: UIImageView!
    @IBOutlet weak var map_View: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        print("ftftrftrtrfrtfrtfrtfrt")
        
        self.title = "Home"
        
        
     //   self.view.backgroundColor = UIColor.white
//        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.4352941176, green: 0.6549019608, blue: 0.2509803922, alpha: 1)
        locationManager.delegate = self
        
        let data = UserDefaults.standard.data(forKey: "restaurants_Details")
        self.restaurants_Details = try! JSONDecoder().decode(GetRestaurants_Details.self, from: data!)
        
        if let indx = seletedRestaurantIndex{
            
            seletedRestaurantIndex = Int( restaurants_Details.return![indx].rest_id!)
            print("\(indx) ****************")
            
            let resLocation = restaurants_Details.return![indx].rest_location!
            let locations = resLocation.split{$0 == ","}.map(String.init)
            
            if let longitude = CLLocationDegrees(locations[1])
                ,let latitude = CLLocationDegrees(locations[0]){
                
                restLocation=CLLocation(latitude: latitude, longitude: longitude)
            }
        }
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: restLocation!.coordinate.latitude, longitude: restLocation!.coordinate.longitude)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = myMapView
        myMapView.animate(toLocation: (restLocation!.coordinate))
        myMapView.delegate = self
        self.startLocationManager()
        view = myMapView
        view.
        
        displayRstaurantOrdr()
        // Add the map to the view, hide it until we've got a location update.
    }
    
    
    var myMapView: GMSMapView = {
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 5)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        // Creates a marker in the center of the map.
        mapView.settings.myLocationButton = true
       // mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.translatesAutoresizingMaskIntoConstraints=false
        return mapView
    }()
    
    func showPhotoMenu(){
    let alertController = UIAlertController(title: nil, message: nil,
    preferredStyle: .actionSheet)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel,
    handler: nil)
    alertController.addAction(cancelAction)
    let takePhotoAction = UIAlertAction(title: "Take Photo",
                                        style: .default, handler: {
                                            _ in self.performSegue(withIdentifier: "getOrderDetails", sender: nil)})
    alertController.addAction(takePhotoAction)
   
    let chooseFromLibraryAction = UIAlertAction(title:
        "Choose From Library", style: .default, handler: {
            _ in
            
            let location = CLLocation.init(latitude: 32.023906, longitude: 32.368344)
            
            self.getPolylineRoute(from: self.ordrLocation!.coordinate, to: location.coordinate)
          //  self.drawPath(startLocation: self.ordrLocation!, endLocation:location)
            //self.restLocation!)
    })
    alertController.addAction(chooseFromLibraryAction)
    present(alertController, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
      
        let position = marker.position
        let positionStr = "\(position.latitude), \(position.longitude)"
        let ordrsDetails = restaurantOrders_Details.return!
        for (indx , detail) in ordrsDetails.enumerated(){
            
            if detail.user_location! == positionStr{
                
                UserDefaults.standard.set( indx, forKey: "order_indx")
                break
            }
        }
        
        ordrLocation = CLLocation.init(latitude: 32.023906, longitude:  32.368344)
        showPhotoMenu()
        return false
    }
    
}

extension MapViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
          case .restricted:
            print("Location access was restricted.")
            showLocationServiceDeniedAlert()
                        return
                   
          case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            showLocationServiceDeniedAlert()
                        return
                   
          case .notDetermined:
            print("Location status not determined.")
            locationManager.requestWhenInUseAuthorization()
            return
            
          case .authorizedAlways: fallthrough
          case .authorizedWhenInUse:
            print("Location status is OK.")
          }
        }
//
//    @objc func btnMyLocationAction() {
//        let authreq = CLLocationManager.authorizationStatus()
//        if authreq == .notDetermined {
//            locationManager.requestWhenInUseAuthorization()
//            return
//        }
//        else
//        {
//            if authreq == .denied || authreq == .restricted {
//                showLocationServiceDeniedAlert()
//                return
//            }
//
//        }
//        // 9
//        if updatingLocation {
//            stopLocationManager()
//        } else {
//            lastLocationError = nil
//            lastGeocodingError = nil
//            startLocationManager()
//        }
//
//    }
    
      func showLocationServiceDeniedAlert(){
            
            let alert=UIAlertController(title: "Location Service Disables", message: "please enable location service for this app in settings", preferredStyle: .alert)
            let action=UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("didFailWithError: \(error)")
            //MARK: 6
            if (error as NSError).code==CLError.locationUnknown.rawValue{
                return
            }
            lastLocationError=error
            location=nil
            stopLocationManager()
            
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            
            let newLocation=locations.last!
            print("didUpdateLocations: \(newLocation)")
            
            if newLocation.timestamp.timeIntervalSinceNow < -5{
                return
            }
            if newLocation.horizontalAccuracy<0
            {return}
            
            var distance=CLLocationDistance(DBL_MAX)
            if let location=location{
                distance=newLocation.distance(from: location)
                if distance>5
                {self.location=nil}
            }
            
            if location==nil || newLocation.horizontalAccuracy < location!.horizontalAccuracy{
                
                location=newLocation
                lastLocationError=nil
                
                if let location = location{
                    print("************ \(location.coordinate.latitude) *********")
                    myMapView.animate(toLocation: (location.coordinate))
                    
                    // Creates a marker in the center of the map.
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    
                    if let placemark=placemark{
                        marker.title = placemark.locality
                        marker.snippet = placemark.country}
                    marker.map = myMapView
                }
                
                if newLocation.horizontalAccuracy<=locationManager.desiredAccuracy{
                    
                    print("*** we're done!")
                    stopLocationManager()
                    if(distance>0)
                    {
                        print("\(distance)")
                        performingReverseGeocoding=false }
                }
                
                if !performingReverseGeocoding{
                    
                    print(" yooo ")
                    performingReverseGeocoding=true
                    geocoder.reverseGeocodeLocation(newLocation, completionHandler: {
                        
                        placemarks,error in
                        if error==nil , let p=placemarks , !p.isEmpty{
                            
                            self.placemark=p.last!
                        }
                        else{
                            self.placemark=nil
                        }
                        
                        self.lastGeocodingError=error
                        self.performingReverseGeocoding=false
                    })
                }
            }
            else if distance<1
            {
                //when the previous condition is false ,then location variable won't change it will still have old value and when we measure time difference will be always big
                let time=newLocation.timestamp.timeIntervalSince((location!.timestamp))
                if time>10
                {
                    print("*** force done!  \(time)")
                    stopLocationManager()
                }
            }
        }
        
        @objc func didTimeOut(){
            
            if location==nil{
                stopLocationManager()
                lastLocationError=NSError(domain: "MyLocationsErrorDomain", code: 1, userInfo: nil)
            }
        }
        
        func startLocationManager(){
            //MAR:12
            //we write If's condition because if the user disabled Location Services completely on her device , it doesn't matter that rest of code execute
            //if the user disabled Location Services completely on her device that won't result error(denied)
            
                timer=Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(didTimeOut), userInfo: nil, repeats: false)
                updatingLocation=true
                locationManager.delegate=self
                lastLocationError=nil
                locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters
                locationManager.requestAlwaysAuthorization()
                locationManager.distanceFilter = 50
                locationManager.startUpdatingLocation()
             
        }
        //MARK:7
        func stopLocationManager(){
            if let timer=timer{
                
                timer.invalidate()
            }
            updatingLocation=false
            locationManager.delegate=nil
            locationManager.stopUpdatingLocation()
        }
        
    }



extension MapViewController{
    
   func displayRstaurantOrdr(){
        
        let rstaurantOrdrUrl = urlStr + "getOrder?restId=\(seletedRestaurantIndex!)&langu=ar"
    
        view.showSpinner(tag: 1000)
    
        Alamofire.request(URL.init(string: rstaurantOrdrUrl)!,
                             method: .post,
                             parameters: [:],
                             encoding: JSONEncoding.default)
               
               .responseJSON { (response:DataResponse) in
                   switch(response.result) {
                   case .success:
                       
                       print("\(response.value!)")
                       
                        
                       let temp = response.response?.statusCode ?? 400
                
                       if temp >= 300 {
                           
                           self.restaurantOrders_Details = try! JSONDecoder().decode(GetRestaurantOrders_Details.self, from: response.data!)
                           print("******************************** \(response.value!) **********************")
                        
                        
                           //  print("\()")

                        print(response.error?.localizedDescription)
                           print("errorrrrelse")
                           // print("")
                           
                       }else{
                           
                          UserDefaults.standard.set( response.data!, forKey: "restaurantOrdr_Details")
                           self.restaurantOrders_Details = try! JSONDecoder().decode(GetRestaurantOrders_Details.self, from: response.data!)
                        
                        print("\(self.restaurantOrders_Details) sdvsdvsdvsdv ")
                          // UserDefaults.standard.set(response.data!, forKey:"UserLoginResult")
                           
                           
                           print("\(response.value)")
                           }
                   case .failure(_):
                       print("error")
                       
                       break
                   }
           }
    
    self.view.hideSpinner(tag: 1000)
    }
    
    
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation)
    {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=\(apiKy)"

        print(url)
        Alamofire.request(url).responseJSON { response in
            
            print("******************************** \(response.value!) **********************")
//              print("\(response.data)")
            
//
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            
//            let json = JSON(data: response.data!)
//            let routes = json["routes"].arrayValue
            
            // print route using Polyline
//            for route in routes
//            {
//                let routeOverviewPolyline = route["overview_polyline"].dictionary
//                let points = routeOverviewPolyline?["points"]?.stringValue
//                let path = GMSPath.init(fromEncodedPath: points!)
//                let polyline = GMSPolyline.init(path: path)
//                polyline.strokeWidth = 4
//                polyline.strokeColor = UIColor.red
//                polyline.map = self.googleMaps
//            }
            
        }
    }
    
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
           
           let config = URLSessionConfiguration.default
           let session = URLSession(configuration: config)
           
           let url=routeURL(from: source, to: destination)
           
           let task = session.dataTask(with: url, completionHandler: {
               (data, response, error) in
               if error != nil {
                   print(error!.localizedDescription)
               }
               else {
                   do {
                       if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                           
                           print(json)
                           guard let routes = json["routes"] as? NSArray else {
                               DispatchQueue.main.async {
                                   print("yoooooo*************")
//                                   self.showNetworkError()
                                print(error.debugDescription)
                               }
                               return
                           }
                           
                           if (routes.count > 0) {
                               let overview_polyline = routes[0] as? NSDictionary
                               let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
                               
                               let points = dictPolyline?.object(forKey: "points") as? String
                               
                              
                               
                               DispatchQueue.main.async {
                                   self.showPath(polyStr: points!)
                                   let bounds = GMSCoordinateBounds(coordinate: source, coordinate: destination)
                                let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 170, left: 30, bottom: 30, right: 30))
                                   self.myMapView.moveCamera(update)
                               }
                           }
                           else {
                               DispatchQueue.main.async {
                                   print("*****************")
                                print(error.debugDescription)
                               }
                           }
                       }
                   }
                   catch {
                       print("error in JSONSerialization")
                       DispatchQueue.main.async {
                           print(error.localizedDescription)
                       }
                   }
               }
           })
           task.resume()
       }
    
    func routeURL(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) -> URL{
          
          let apiKey2="AIzaSyCU9X9RzA1rgfhs0becy_5m6oYLSSI1sxQ"
          let urlString=String(format: "https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true&mode=driving&key=%@", source.latitude, source.longitude, destination.latitude, destination.longitude, apiKey2)
          print(urlString)
          let url = URL(string: urlString)
          
          return url!
      }
    
    
    func showPath(polyStr :String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.strokeColor = UIColor.red
        polyline.map = self.myMapView
    }
}

