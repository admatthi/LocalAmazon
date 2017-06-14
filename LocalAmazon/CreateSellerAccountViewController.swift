//
//  CreateSellerAccountViewController.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 6/8/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit

import Firebase
import FirebaseDatabase
import FirebaseAuth
import CoreLocation


class CreateSellerAccountViewController: UIViewController, CLLocationManagerDelegate {
    
    var signupMode = true
    
    var ref: FIRDatabaseReference?
    
    var locationManager = CLLocationManager()
    
    var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var storename: UITextField!
    var latitudes = [String]()
    var longitudes = [String]()
    var email = ""
    var password = ""
    
    @IBAction func tapChange(_ sender: Any) {
        
        if signupMode {
            
            signupMode = false
            
            tapsignuporlogi.setTitle("Log In", for: .normal)
            
            changesignuporlogin.setTitle("Don't have any account? Sign up here", for: [])
            
        } else {
            
            signupMode = true
            
            tapsignuporlogi.setTitle("Sign Up", for: .normal)
            
            changesignuporlogin.setTitle("Already have an account? Log in here", for: [])
            
        }
    }
    @IBOutlet weak var changesignuporlogin: UIButton!
    func displayAlert(title: String, message: String) {
        
        let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertcontroller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertcontroller, animated: true, completion: nil)
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


    @IBAction func tapSignUpOrLogin(_ sender: Any) {
        
        if storename.text == "" || address.text == "" {
            
            
        }  else {
            
            if signupMode {
                
                ref = FIRDatabase.database().reference()
                
                email = storename.text!
                password = address.text!
                

                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
                    
                    if error != nil {
                        
                            
                    } else {

                    let addresstext = self.inputtwo.text!
                        
                    let geocoder = CLGeocoder()
                    
                    let user = FIRAuth.auth()?.currentUser
                    
                    let uid = user!.uid
                        
                        geocoder.geocodeAddressString(addresstext) { (placemarks, error) in
                            
                            if let placemarks = placemarks {
                                
                                if placemarks.count != 0 {
                                    
                                    let coordinates = placemarks.first!.location
                                    
                                    let longitude = coordinates!.coordinate.longitude
                                    
                                    let latitude = coordinates!.coordinate.latitude
                                    
                                    let stringlatitude = String(latitude)
                                    
                                    let longitudestring = String(longitude)
                                    
                                    self.latitudes.append(stringlatitude)
                                    self.longitudes.append(longitudestring)
                                    
                                    self.ref?.child("Sellers").child(uid).setValue(["StoreName" : "\(self.inputone.text!)","Address" : "\(self.inputtwo.text!)", "Longitude" : "\(self.longitudes[0])", "Latitude" : "\(self.latitudes[0])", "Email" : self.email, "Password" : self.password])
                                    
                                    self.performSegue(withIdentifier: "LogInToAddProduct", sender: self)
                                    
                                }
                                
                            }
                            
                        }
                    }
                })

                
            } else {
                
                let user = FIRAuth.auth()?.currentUser
                
                let uid = user!.uid

                ref = FIRDatabase.database().reference()
                
                let email = storename.text
                
                let password = address.text
                
                FIRAuth.auth()?.signIn(withEmail: email!, password: password!) { (user, error) in
                    
                    if error != nil {
                        
                        var errorMessage = "Incorrect username or password"
                        
                        let error = error as? NSError
                        
                        if let firebaseError = error?.userInfo["error"] as? String {
                            
                            errorMessage = firebaseError
                        }
                        
                        
                    }
                    else {
                        
                        self.performSegue(withIdentifier: "LogInToAddProduct", sender: self)
                        
                      
                        }
                        
                    }
                }
            }
            
        }

                        
    
    
    @IBOutlet weak var tapsignuporlogi: UIButton!
    @IBOutlet weak var labeltwo: UILabel!
    @IBOutlet weak var labelone: UILabel!
    @IBOutlet weak var inputtwo: UITextField!
    @IBOutlet weak var inputone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        longitudes.removeAll()
        latitudes.removeAll()
        
        ref = FIRDatabase.database().reference()
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        // Do any additional setup after loading the view.
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
