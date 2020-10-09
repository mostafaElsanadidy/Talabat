//
//  MapHelper.swift
//  Talabat
//
//  Created by mostafa elsanadidy on 10/8/20.
//  Copyright © 2020 68lion. All rights reserved.
//

import CoreLocation
import Alamofire
import GoogleMaps
import GooglePlaces

class MapSupport{
    
    private var myMapView:GMSMapView?
       
       init(myMapView:GMSMapView) {
           
           self.myMapView = myMapView
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
                                    self.myMapView?.moveCamera(update)
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
              let urlString=String(format: "https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true&mode=driving&key=AIzaSyDvw1dLsamTVmAwlM3hRcncKrqDMRqCsT8", source.latitude, source.longitude, destination.latitude, destination.longitude )
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
