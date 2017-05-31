//
//  ProductsViewController.swift
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

var allproductids = [String]()
var relevantproductids = [String]()
var productimages = [UIImage]()
var titles = [String]()
var prices = [String]()
var brands = [String]()
var distances = [String]()
var quantities = [String]()
var bizlongitudes = [String]()
var bizlatitudes = [String]()
var reviewss = [String]()

var thisproduct = 0

class ProductsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var ref: FIRDatabaseReference?

  
    @IBOutlet weak var currentlocation: UILabel!
    @IBOutlet weak var searchterm: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
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
                
                if var productimage = value?["Image"] as? String {
                    
                    let storage = FIRStorage.storage()
                    
                    let dummy = UIImage()
                    
                    productimages.append(dummy)
                    
                    let insertionIndex = productimages.count - 1
                    
                    storage.reference(forURL: "\(productimage)").data(withMaxSize: 10*1024*1024, completion: { (data, error) in
                        
                        if data != nil {
                            
                            let productphoto = UIImage(data: (data)!)
                            
                            productimages[insertionIndex] = productphoto!
                            
                            self.tableView.reloadData()
                            
                        }
                        
                        
                    })
                    
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
        
        if searchString != nil {
            
            searchterm.text = searchString
            
        }
        
        queryforproductids { (() -> ()).self
            
            self.queryforrelevantids { (() -> ()).self
                
                self.queryforproductdata{ (() -> ()).self
                
                    self.updatedistances()
                    
                }
            }
        }
        
        self.tableView.reloadData()
        
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
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titles.count

    }
  
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetails", for: indexPath) as! ProductDetailsTableViewCell
        
        if prices.count > indexPath.row {
            
            cell.price.text = prices[indexPath.row]

        }
        
        if quantities.count > indexPath.row {
            
            cell.servings.text = quantities[indexPath.row]

        }
        
        if titles.count > indexPath.row {
            
            cell.productname.text = titles[indexPath.row]

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
       
        self.performSegue(withIdentifier: "ProductsToDetails", sender: self)
    }


}
