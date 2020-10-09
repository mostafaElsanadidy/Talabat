//
//  MapVC.swift
//  Talabat
//
//  Created by mostafa elsanadidy on 10/4/20.
//  Copyright © 2020 68lion. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import GooglePlaces
import CoreLocation

class MapVC: UIViewController,GMSMapViewDelegate{

    
    let locationManager = CLLocationManager()
    
    var restLocation:CLLocation?
    var ordrLocation:CLLocation?
    var location: CLLocation?
    var marker:GMSMarker?
    var updatingLocation = false
    var addressStatus=""
    var lastLocationError: Error?
    
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: Error?
    var timer: Timer?
    
    var mapSupport:MapSupport?
    var updateSelectedCMarker : ((_ orderProducts:[orderProducts_Details]) -> ())!
    
    var restaurant_Details : restaurant_Data!
    
    var selectedOrderProducts:[orderProducts_Details]?
    
     var restaurantOrders_Details = [restaurantOrder_Data](){
        didSet{
            
                for ordr in self.restaurantOrders_Details{
                    

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
        }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        print("ftftrftrtrfrtfrtfrtfrt")
        
        self.title = "Home"
        locationManager.delegate = self
        
        mapSupport = MapSupport(myMapView: myMapView)
         //   print("\(seletedRestaurantIndex) ****************")
            
            let resLocation = restaurant_Details.rest_location!
            let locations = resLocation.split{$0 == ","}.map(String.init)
            
            if let longitude = CLLocationDegrees(locations[1])
                ,let latitude = CLLocationDegrees(locations[0]){
                
                restLocation=CLLocation(latitude: latitude, longitude: longitude)
               // let str = getcurrentAddress(with: resLocation)
            }
        
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: restLocation!.coordinate.latitude, longitude: restLocation!.coordinate.longitude)
        
        marker.map = myMapView
        myMapView.animate(toLocation: (restLocation!.coordinate))
        myMapView.delegate = self
       // self.startLocationManager()
        view = myMapView
        
        
        displayRstaurantOrdrs()
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
                                     handler: {
                                        _ in
                                        self.marker!.map = nil
    })
    alertController.addAction(cancelAction)
    let takePhotoAction = UIAlertAction(title: "show order details",
                                        style: .default, handler: {
                                            _ in self.performSegue(withIdentifier: "getOrderDetails", sender: nil)
                                            self.updateSelectedCMarker(self.selectedOrderProducts ?? []
                                            )
    })
    alertController.addAction(takePhotoAction)
   
        
    let chooseFromLibraryAction = UIAlertAction(title:
        "show direction", style: .default, handler: {
            _ in
            
           // let location = CLLocation.init(latitude: 32.023906, longitude: 32.368344)
            guard let mapSupport = self.mapSupport else{
                return
            }
            mapSupport.getPolylineRoute(from: self.ordrLocation!.coordinate, to: self.restLocation!.coordinate)
          //  self.drawPath(startLocation: self.ordrLocation!, endLocation: location)
          //  self.restLocation!)
    })
    alertController.addAction(chooseFromLibraryAction)
    present(alertController, animated: true, completion: nil)
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        if let OrderDetailsVC = segue.destination as? OrderDetailsVC{
                
                print(")))))))))))))))))))))))^^^^^^^^^^^^^")
              self.updateSelectedCMarker =
                {ordrProducts in
    //                mapVieControllr.seletedRestaurantIndex = selected_ID
                    OrderDetailsVC.orderProducts
                        = ordrProducts
            }
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
      
        self.marker = marker
        let position = marker.position
        let positionStr = "\(position.latitude), \(position.longitude)"
        let ordrsDetails = restaurantOrders_Details
        ordrLocation = CLLocation.init(latitude: position.latitude, longitude: position.longitude)
        
        let order_details = ordrsDetails.enumerated().filter{$0.element.user_location == positionStr}.map{$0.element.order_details}[0]
        
        guard let ordrProducts = order_details else{
              geocoder.reverseGeocodeLocation(ordrLocation!, completionHandler: {
                                
                        placemarks,error in
                        if error==nil , let p=placemarks , !p.isEmpty{
                            
                            self.placemark=p.last!
                            
                        }
                        else{
                            self.placemark=nil
                        }
                        
    //                    self.lastGeocodingError=error
    //                    self.performingReverseGeocoding=false
                    })
                    if let placemark=placemark{
                                           marker.title = placemark.locality
                                           marker.snippet = placemark.country}
                        
                    return false
        }
        selectedOrderProducts = ordrProducts
       // UserDefaults.standard.set( order_ID, forKey: "Order_ID")
        showPhotoMenu()
        return false
              
    }
    
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        
        self.startLocationManager()
        return false
    }
}

extension MapVC:CLLocationManagerDelegate{
    
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



extension MapVC{
    
    func displayRstaurantOrdrs(){
        APIClient.getRestaurantOrders(restId: Int( restaurant_Details.rest_id!) ?? 0, langu: "ar", completionHandler: { [weak self]
                restaurantOrders_Data in
                guard let strongSelf = self else{
                    return
                }
                
             guard let restaurantOrders_Data = restaurantOrders_Data else{
              strongSelf.killLoading()
                 return
             }
             DispatchQueue.main.async{
                 
                 print(restaurantOrders_Data)
                strongSelf.restaurantOrders_Details = restaurantOrders_Data
        
                     }
            }, completionFaliure: {
                error in
                print(error!.localizedDescription)
                self.showAlert(title: "ERROR!", message:
                NSLocalizedString(error!.localizedDescription, comment: "this is my mssag"))
            })
    }
        
}


