//
//  TurnOnLocationServicesViewController.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 6/2/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit
import CoreLocation

class TurnOnLocationServicesViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            
        case .notDetermined:
            
            print("Fsuc")
            
            
        case .authorizedAlways, .authorizedWhenInUse:
        
            DispatchQueue.main.async {
                
                self.performSegue(withIdentifier: "NotificationsToShop", sender: self)
            }
            
        default: break
            // Permission denied, do something else
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations
        
        locations: [CLLocation]) {
        
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
                
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self as! CLLocationManagerDelegate

        // For use in foreground
        
        if CLLocationManager.locationServicesEnabled() {
            
              DispatchQueue.main.async {
                
                self.performSegue(withIdentifier: "NotificationsToShop", sender: self)
        }
            locationManager.delegate = self as! CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            

        }
        
        
      
        // Do any additional setup after loading the view.
    }

    @IBAction func tapLocation(_ sender: Any) {
        
        self.locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
