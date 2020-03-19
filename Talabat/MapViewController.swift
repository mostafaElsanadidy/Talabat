//
//  MapViewController.swift
//  Talabat
//
//  Created by 68lion on 3/18/20.
//  Copyright © 2020 68lion. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class MapViewController: UIViewController {

    
    let locationManager = CLLocationManager()
    
    var location: CLLocation?
    var updatingLocation = false
    var addressStatus=""
    var lastLocationError: Error?
    
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: Error?
    var timer: Timer?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Home"
               self.view.backgroundColor = UIColor.white
               locationManager.delegate = self
               location=CLLocation(latitude: -33.86, longitude: 151.20)
               
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(myMapView)
      //  myMapView.isHidden = true
        
    }
    
    var myMapView: GMSMapView = {
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 9.9)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //mapView.translatesAutoresizingMaskIntoConstraints=false
        return mapView
    }()
    
}

extension MapViewController:CLLocationManagerDelegate{
    
    func btnMyLocationAction() {
        let authreq = CLLocationManager.authorizationStatus()
        if authreq == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        else
        {
            if authreq == .denied || authreq == .restricted {
                showLocationServiceDeniedAlert()
                return
            }
            
        }
        // 9
        if updatingLocation {
            stopLocationManager()
        } else {
            lastLocationError = nil
            lastGeocodingError = nil
            startLocationManager()
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
            
            if CLLocationManager.locationServicesEnabled() {
                timer=Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(didTimeOut), userInfo: nil, repeats: false)
                updatingLocation=true
                locationManager.delegate=self
                lastLocationError=nil
                locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
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

