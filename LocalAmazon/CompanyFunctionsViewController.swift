//
//  CompanyFunctionsViewController.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 6/14/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import CoreLocation



class CompanyFunctionsViewController: UIViewController, CLLocationManagerDelegate {
    
    var ref: FIRDatabaseReference?

    var rawsellerinfo = [String:String]()
    var locationManager = CLLocationManager()

    @IBAction func tapUpdateProductSellers(_ sender: Any) {
        
        queryforproductids {
            
            self.queryforuploadedids {
         
            
            self.queryforuploadedidds {
                
                self.queryforcatalogtitles {
                    
                    self.queryforuploadedtitles {
                        
                        self.getsellerinfo {
                            
                            self.queryformatchingtitlesandupdateprices()
                            
                        }
                        
                    }
                    
                        
                    }
                }
            }
        }
        
        
    }

    @IBAction func tapAddGeo(_ sender: Any) {
       
        queryforuploadedids { () -> () in
            
            self.getaddresses { () -> () in
                
                self.getlatsandlongs()
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ref = FIRDatabase.database().reference()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        queryforproductids {
            
            self.queryforuploadedids {
                
                
                self.queryforuploadedidds {
                    
                    self.queryforcatalogtitles {
                        
                        self.queryforuploadedtitles {
                            
                            self.getsellerinfo {
                                
                                
                            }
                            
                        }
                        
                        
                    }
                }
            }
        }
        
       
        
    }
    
    @IBAction func tapAddAllSellersToAllProducts(_ sender: Any) {
        
        var addsellercounters = 0
        
        
            for (idd, pricee) in uploadedprices {
                
                for iddd in dict {
                    
                    self.ref?.child("Catalog").child("\(idd)").child("AllSellers").child(iddd).updateChildValues(["Latitude" : lats[iddd], "Longitude" : longs[iddd], "Price" : self.uploadedprices[idd], "StoreAddress" : addressess[iddd], "StoreName" : names[iddd]])
                    
                    addsellercounters += 1
                }
                
        }
        
        
    }
    var addressess = ["":""]
    
    var names: [String:String] = [:]
    var lats: [String:Double] = [:]
    var longs: [String:String] = [:]
    
    var dict = [String]()
    
    func getsellerinfo(completed: @escaping ( () -> () ))  {
        
        addressess.removeAll()
        names.removeAll()
        lats.removeAll()
        longs.removeAll()
        
        var functioncounter = 0
        
        for each in dict {
        
        self.ref?.child("Sellers").child("\(each)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if var add = value?["StoreAddress"] as? String {
                
                self.addressess[each] = add
            }
            
            if var name = value?["StoreName"] as? String {
                
                self.names[each] = name
            }
            
            if var lat = value?["Latitude"] as? Double {
                
                self.lats[each] = lat
            }
            
            
            if var long = value?["Longitude"] as? String {
                
                self.longs[each] = long

                
            }
            
            functioncounter += 1
            
            if functioncounter == self.dict.count {
                
                completed()
            }
            
            })
            
        }
    }
    
    
    func queryforproductids(completed: @escaping ( () -> () )) {
        
        sellerviewallproductids.removeAll()
        
        sellerviewrelevantproductids.removeAll()
        
        var functioncounter = 0
        
        self.ref?.child("Catalog").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapDict = snapshot.value as? [String:AnyObject] {
                
                for each in snapDict {
                    
                    let ids = each.key
                    
                    sellerviewallproductids.append(ids)
                    
                    functioncounter += 1
                    
                    if functioncounter == snapDict.count {
                        
                        sellerviewallproductids = Array(Set(sellerviewallproductids))
                        
                        completed()
                        
                    }
                    
                }
                
            }
            
            
        })
        
        
    }
    
    var catalogtitles = [String:String]()

    func queryforcatalogtitles(completed: @escaping ( () -> () )) {
        
        var functioncounter = 0
        
        catalogtitles.removeAll()
        
        for each in sellerviewallproductids {
            
            self.ref?.child("Catalog").child("\(each)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary
                
                if var lowestprice = value?["LowestPrice"] as? String {
                    
                    self.catalogtitles[each] = lowestprice
                    
                }
                
                functioncounter += 1
                
                if functioncounter == sellerviewallproductids.count {
                    
                    completed()
                    
                }
                
            })
            
            
            
        }
        
    }
    
    var uploadedtitles: [String:String] = [:]
    
    var uploadedids = [String]()
    
    func queryforuploadedidds(completed: @escaping ( () -> () ))  {
        
        uploadedids.removeAll()
        
        var functioncounter = 0
        
        self.ref?.child("Users").child("Uploads").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapDict = snapshot.value as? [String:AnyObject] {
                
                for each in snapDict {
                    
                    let ids = each.key
                    
                    self.uploadedids.append(ids)
                    
                    functioncounter += 1
                    
                    if functioncounter == snapDict.count {
                        
                        
                        completed()
                        
                    }
                    
                }
                
            }
            
            
        })
        
    }

    
    var uploadedprices = [String:String]()
    
    func queryforuploadedtitles(completed: @escaping ( () -> () )) {
        
        var functioncounter = 0
        
        uploadedtitles.removeAll()
        uploadedprices.removeAll()
        
        for each in uploadedids {
            
            self.ref?.child("Users").child("Uploads").child("\(each)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if var value = snapshot.value as? NSDictionary {
                    
                    if var price = value["Price"] as? String {
                        
                        self.uploadedprices[each] = price
                        
                    }
                }
                
                functioncounter += 1
                
                if functioncounter == self.uploadedids.count {
                    
                    completed()
                    
                }
                
            })
            
            
            
            
        }
        
    }
    
    var latitude = Int()
    var longitude = ""
    var storeaddress = ""
    var storename = ""
    
    func queryformatchingtitlesandupdateprices() {
        
        var counter = 0
        
        let user = FIRAuth.auth()?.currentUser
        
        let uid = user!.uid
        
        for (id, lowestprice) in catalogtitles {
            
            for (idd, pricee) in uploadedprices {
                
                if id == idd {
                    
                    for iddd in dict {
                        
                    var passed = false

                    self.ref?.child("Catalog").child("\(id)").child("AllSellers").child(iddd).updateChildValues(["Latitude" : lats[iddd], "Longitude" : longs[iddd], "Price" : self.uploadedprices[idd], "StoreAddress" : addressess[iddd], "StoreName" : names[iddd]])
                            
                            passed = true
                            
                    }
                    
              
                
//                        if passed {
//                            
//                            let trimmedlowestprice = lowestprice.trimmingCharacters(in: .whitespaces)
//                            let trimmedpricee = pricee.trimmingCharacters(in: .whitespaces)
//                            
//                            
//                            if var intlowestprice = Double(trimmedlowestprice)  {
//                                
//                                if var intpricee = Double(trimmedpricee) {
//                                    
//                                    if intpricee < intlowestprice {
//                                        
//                                        self.ref?.child("Products").child("\(id)").updateChildValues(["CheapestLatitude" : self.latitude, "CheapestLongitude" : self.longitude, "LowestPrice" : self.uploadedprices[idd],  "Brand" : self.storename])
//                                        
//                                    } else {
//                                        
//                                        
//                                    }
//                                    
//                                } else {
//                                    
//                                    self.ref?.child("Products").child("\(id)").updateChildValues(["CheapestLatitude" : self.latitude, "CheapestLongitude" : self.longitude, "LowestPrice" : self.catalogtitles[id],  "Brand" : self.storename])
//                                }
//                                
//                                
//                            } else {
//                                
//                                self.ref?.child("Products").child("\(id)").updateChildValues(["CheapestLatitude" : self.latitude, "CheapestLongitude" : self.longitude, "LowestPrice" : self.uploadedprices[idd],  "Brand" : self.storename])
//                            }
//                            
//
//                        }
                        
        
                    
            
                    
                    
            }
        }
            
        }
    }


    
    func queryforuploadedids(completed: @escaping ( () -> () )) {
        
        rawsellerinfo.removeAll()
        dict.removeAll()
        
        var functioncounter = 0
        
        self.ref?.child("Sellers").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapDict = snapshot.value as? [String:AnyObject] {
                
                for each in snapDict {
                    
                    let ids = each.key
                    
                    self.rawsellerinfo[ids] = " "
                    self.dict.append(ids)
                    
                    functioncounter += 1
                    
                    if functioncounter == snapDict.count {
                        
                        
                        completed()
                        
                    }
                    
                }
                
            }
            
            
        })
        
    }

    func getaddresses(completed: @escaping ( () -> () )) {
        
        var functioncounter = 0
        
        for (each, value) in rawsellerinfo {
            
            self.ref?.child("Sellers").child("\(each)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary
                
                if var productitle = value?["StoreAddress"] as? String {
                    
                    self.rawsellerinfo[each] = productitle
                    
                    
                    
                }
                
                functioncounter += 1
                
                if functioncounter == self.rawsellerinfo.count {
                    
                    
                    completed()
                    
                }
                
                
            })
            
            
        }
        
    }
    
    func getlatsandlongs() {
        
        for (each, value) in rawsellerinfo {
            
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(value) { (placemarks, error) in
                
                if let placemarks = placemarks {
                    
                    if placemarks.count != 0 {
                        
                        let coordinates = placemarks.first!.location
                        
                        let longitude = coordinates!.coordinate.longitude
                        
                        let latitude = coordinates!.coordinate.latitude
                        
                        let stringlatitude = String(latitude)
                        
                        let longitudestring = String(longitude)
                        
//                        self.ref?.child("Sellers").child(each).updateChildValues(["Longitude" : "\(longitudestring)", "Latitude" : "\(stringlatitude)"])
                        
                        self.ref?.child("Sellers").child(each).updateChildValues(["Longitude" : longitudestring, "Latitude" : stringlatitude])

                        
                        
                    }
                    
                }
                
            }
        }
        
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
