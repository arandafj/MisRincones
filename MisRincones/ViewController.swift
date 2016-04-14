//
//  ViewController.swift
//  MisRincones
//
//  Created by CLAG on 31/3/16.
//  Copyright © 2016 Clag. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if activePlace == -1 {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        }
        else{
            let latitude = NSString(string: places[activePlace]["lat"]!).doubleValue
            let longitude = NSString(string: places[activePlace]["lon"]!).doubleValue
           
            let latDelta:CLLocationDegrees = 0.01 // definimos cuanto abrimos el zoom
            let lonDelta:CLLocationDegrees = 0.01
            let span = MKCoordinateSpanMake(latDelta, lonDelta)
            
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            
            let region = MKCoordinateRegionMake(coordinate, span)
            
            self.map.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = places[activePlace]["name"]
            self.map.addAnnotation(annotation)
        }
        
        let lpgr = UILongPressGestureRecognizer(target: self, action:#selector(longPressDetected(_:)))
        lpgr.minimumPressDuration = 2
        
        self.map.addGestureRecognizer(lpgr)
    
    }

    func longPressDetected(gestureRecognizaer:UIGestureRecognizer){
        if gestureRecognizaer.state == UIGestureRecognizerState.Recognized {
            let touchPoint = gestureRecognizaer.locationInView(self.map)
            let newCoordinate = self.map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                var title = ""
                
                if let p = placemarks?.first{
                    if p.thoroughfare != nil{
                        title += "\(p.thoroughfare!)"
                    }
                    
                    if p.subThoroughfare != nil{
                        title += "\(p.subThoroughfare!)"
                    }
                }
                
                if title == "" {title = "Punto añadido el \(NSDate())"}
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = newCoordinate
                annotation.title = title
                self.map.addAnnotation(annotation)
                
                places.append(["name": title, "lat": "\(newCoordinate.latitude)", "lon": "\(newCoordinate.longitude)"])
                
                NSUserDefaults.standardUserDefaults().setObject(places, forKey: "places")
            })
            
        }
        
    }
   
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Inform of positions
        if let userlocation = locations.first{
            let latitude = userlocation.coordinate.latitude
            let longitude = userlocation.coordinate.longitude
            
            let latDelta:CLLocationDegrees = 0.01 // definimos cuanto abrimos el zoom
            let lonDelta:CLLocationDegrees = 0.01
            let span = MKCoordinateSpanMake(latDelta, lonDelta)
            
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            
            let region = MKCoordinateRegionMake(coordinate, span)
            
            self.map.setRegion(region, animated: true)
            
        }
        
        
        
        
        
    }

}

