//
//  ViewController.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 5/30/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import CoreLocation
import MapKit

var searchString = String()


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate, UIScrollViewDelegate {
    @IBOutlet weak var errorlabel: UILabel!
    
    var locationManager = CLLocationManager()
    
    var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var ref: FIRDatabaseReference?
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentlocation: UILabel!
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let user = FIRAuth.auth()?.currentUser
        
        if let uid = user?.uid {
            
            if let location = manager.location?.coordinate  {
                
                ref?.child("Users").child(uid).child("Location").setValue(["Latitude" : "\(location.latitude)", "Longitude" : "\(location.longitude)"])
                
            }
            
        }
        
    }
    
    func updatedistances() {
        
        var counter = 0
        
        for bizlatitude in bizlatitudes {
            
            let manager = CLLocationManager()
            
            if let location = manager.location?.coordinate {
                
                if counter < bizlatitudes.count {
                    
                    var bizLocation = CLLocation(latitude: (Double(bizlatitudes[counter])!) , longitude: Double(bizlongitudes[counter])!)
                    
                    var cluserLocation = CLLocation(latitude: (location.latitude), longitude: (location.longitude))
                    
                    var distance = cluserLocation.distance(from: bizLocation) / 1000 * 0.621371
                    
                    print("\(cluserLocation) & \(bizLocation) & \(distance)")
                    
                    distances.append(String(format: "%.2f", distance))
                    
                    counter += 1
                    
                    self.tableView.reloadData()
                    
                }
                
            }
            
            
        }
        
        
    }
    
    
    
    func queryforproductids(completed: @escaping ( () -> () )) {
        
        allproductids.removeAll()
        relevantproductids.removeAll()
        
        var functioncounter = 0
        
        self.ref?.child("Products").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapDict = snapshot.value as? [String:AnyObject] {
                
                for each in snapDict {
                    
                    let ids = each.key
                    
                    allproductids.append(ids)
                    
                    functioncounter += 1
                    
                    if functioncounter == snapDict.count {
                        
                        completed()
                        
                    }
                    
                }
                
            }
            
            
        })
        
        
    }
    
    
    func queryforrelevantids(completed: @escaping () -> () ) {
        
        var functioncounter = 0
        
        for each in allproductids {
            
            self.ref?.child("Products").child("\(each)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary
                
                if var name = value?["Title"] as? String {
                    
                    if var brand = value?["Brand"] as? String {
                        
                        if searchString.contains(name) || searchString.contains(brand) {
                            
                            relevantproductids.append(each)
                            
                        }
                        
                    }
                    
                }
                
                functioncounter += 1
                
                if functioncounter == allproductids.count {
                    
                    completed()
                }
                
                
            })
            
        }
        
    }
    
    func queryforproductdata(completed: @escaping () -> () ){
        
        
        var functioncounter = 0
        
        productimages.removeAll()
        titles.removeAll()
        prices.removeAll()
        brands.removeAll()
        distances.removeAll()
        quantities.removeAll()
        bizlatitudes.removeAll()
        bizlongitudes.removeAll()
        storenames.removeAll()
        
        for each in relevantproductids {
            
            self.ref?.child("Products").child("\(each)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary
                
                if var productprice = value?["Price"] as? String {
                    
                    prices.append(productprice)
                    
                }
                
                if var productitle = value?["Title"] as? String {
                    
                    titles.append(productitle)
                    
                }
                
                if var reviewnumber = value?["Brand"] as? String {
                    
                    brands.append(reviewnumber)
                    
                }
                
                if var quantity = value?["Quantity"] as? String {
                    
                    quantities.append(quantity)
                    
                }
                
                if var reviewnumber = value?["ReviewNumber"] as? String {
                    
                    reviewss.append(reviewnumber)
                    
                }
                
                if var storename = value?["StoreName"] as? String {
                    
                    storenames.append(storename)
                    
                }
                
                if var productimagee = value?["RecipePic"] as? String {
                    
                    if productimagee.hasPrefix("https://") {
                        
                        let storage = FIRStorage.storage()
                        
                        storage.reference(forURL: "\(productimagee)").data(withMaxSize: 10*1024*1024, completion: { (data, error) in
                            
                            if data != nil {
                                
                                let productphoto = UIImage(data: (data)!)
                                
                                productimages.append(productphoto!)
                                
                            }
                            
                        })
                        
                    }
                    
                }

                
                if var businesslongitude = value?["Longitude"] as? String {
                    
                    bizlongitudes.append(businesslongitude)
                    
                }
                
                if var businesslatitude = value?["Latitude"] as? String {
                    
                    
                    bizlatitudes.append(businesslatitude)
                    
                }
                
                self.tableView.reloadData()
                
                functioncounter += 1
                
                if functioncounter == relevantproductids.count {
                    
                    completed()
                }
                
                
                
            })
            
            self.tableView.reloadData()
            
        }
        
        self.tableView.reloadData()
        
    }
    
    
    
    
    override func viewDidLoad() {
        
        ref = FIRDatabase.database().reference()
        
        super.viewDidLoad()
        
        queryforproductids { (() -> ()).self
            
            relevantproductids = allproductids
            
                self.queryforproductdata{ (() -> ()).self
                    
                    self.updatedistances()
                    
                    self.tableView.reloadData()
                    
                    self.tableView.alpha = 1
                    
                    self.errorlabel.alpha = 0
                    
                }
            }
        
        self.tableView.reloadData()
        
        errorlabel.alpha = 0

        
        }
    
    
    
        // Do any additional setup after loading the view.
    
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
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if titles.count > 0 {
            
            return titles.count
            
//            tableView.alpha = 1
            
            errorlabel.alpha = 0
            
        } else {
            
            errorlabel.alpha = 1
            
            errorlabel.text = "No available products. Please refine your search"
            
            return 0
        }
        
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetails", for: indexPath) as! ProductDetailsTableViewCell
        
        if prices.count > indexPath.row {
            
            cell.price.text = "$\(prices[indexPath.row])"
            
        }
        
        if quantities.count > indexPath.row {
            
            cell.servings.text = "by \(storenames[indexPath.row])"
            
        }
        
        if titles.count > indexPath.row {
            
            cell.productname.text = titles[indexPath.row]
            
        }
        
        if reviewss.count > indexPath.row {
            
            cell.reviews.text = "(\(reviewss[indexPath.row]))"
            
        }
        
        if productimages.count > indexPath.row {
            
            cell.productimage.image = productimages[indexPath.row]
            
        }
        
        if distances.count > indexPath.row {
            
            cell.distanceaway.text = "\(distances[indexPath.row]) mi"
        }
        
        return cell
        
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        
    {
        
        thisproduct = indexPath.row
        
        self.performSegue(withIdentifier: "NearbyToDetails", sender: self)
    }



}

