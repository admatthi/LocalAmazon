//
//  ProductDetailsViewController.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 5/30/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseStorage
import FirebaseDatabase
import Firebase

class ProductDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var citystateziplabel: UILabel!
    @IBOutlet weak var featureslabel: UILabel!
    @IBOutlet weak var featurestext: UILabel!
    @IBOutlet weak var price: UILabel!

    @IBOutlet weak var about: UILabel!
    
    @IBOutlet weak var aboutthebrand: UILabel!
    
    
    @IBOutlet weak var descriptiontitle: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var reviewstwo: UILabel!
    
    @IBOutlet weak var reviewimagetwo: UIImageView!
    
    @IBOutlet weak var distanceaway: UILabel!
    @IBOutlet weak var productsize: UILabel!
    @IBOutlet weak var productimage: UIImageView!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var reviewimage: UIImageView!
    @IBOutlet weak var productname: UILabel!
    @IBOutlet weak var brandname: UILabel!
    @IBOutlet weak var tapaddtocart: UIButton!
    @IBAction func tapAddToCart(_ sender: Any) {
    }
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func tapReviews(_ sender: Any) {
        
        showreviews()
        hidelocation()
        hidedetails()
    }
    @IBOutlet weak var taplocation: UIButton!
    @IBAction func tapLocation(_ sender: Any) {
        
        showlocation()
        hidedetails()
        hidereviews()
    }
    
    @IBOutlet weak var tapreviews: UIButton!
    @IBAction func tapDetails(_ sender: Any) {
        
        showdetails()
        hidereviews()
        hidelocation()
    }
    @IBOutlet weak var tapdetails: UIButton!
    
    func showreviews() {
        
        reviewstwo.alpha = 1
        reviewimagetwo.alpha = 1
        tableView.alpha = 1
        
    }
    
    func hidereviews() {
       
        reviewstwo.alpha = 0
        reviewimagetwo.alpha = 0
        tableView.alpha = 0
        
    }
    
    func hidelocation() {
  
        tableViewTwo.alpha = 0
    }
    
    func showlocation() {
        
   
        tableViewTwo.alpha = 1
        
//        getsellerids { () -> () in
//            
//            self.queryforsellerdata { () -> () in
//                
//                self.updatedistances()
//                
//                self.tableViewTwo.reloadData()
//                
//                }
//            
//            }

    }
    
  
    @IBOutlet weak var descriptionlabel: UILabel!
    func showdetails() {
        
        about.alpha = 1
        aboutthebrand.alpha = 1
        
        descriptiontitle.alpha = 1
        descriptionlabel.alpha = 1
        featurestext.alpha = 1
        featureslabel.alpha = 1
        
    }
    
    @IBOutlet weak var currentlocation: UILabel!
    func hidedetails() {
        
        about.alpha = 0
        aboutthebrand.alpha = 0
        
        descriptiontitle.alpha = 0
        descriptionlabel.alpha = 0
        featurestext.alpha = 0
        featureslabel.alpha = 0
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hidedetails()
        hidelocation()
        showreviews()

        
        currentlocation.text = searchString
        
        // Do any additional setup after loading the view.
        
        productname.text = titles[thisproduct]
        
        distanceaway.text = "\(distances[thisproduct]) miles away"
        
        
        price.text = "$\(prices[thisproduct])"
        brandname.text = brands[thisproduct]
        reviews.text = "(\(reviewss[thisproduct]))"
        reviewstwo.text = "\(reviewss[thisproduct]) reviews"
        productsize.text = quantities[thisproduct]
      
//        mapView.delegate = self
//        
//        var bizLocation = CLLocationCoordinate2DMake((Double(bizlatitudes[thisproduct])!) , Double(bizlongitudes[thisproduct])!)
//        
//        let region = MKCoordinateRegion(center: bizLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = bizLocation
//        
//        mapView.addAnnotation(annotation)
//        
//        mapView.setRegion(region, animated: true)
        
        ref = FIRDatabase.database().reference()

        
        queryforproductdata()
        
        getsellerids { () -> () in
         
            self.queryforsellerdata { () -> () in
                
                self.updatedistances()
                
            }
        }
        
    }
    
    var ref: FIRDatabaseReference?
    
    var sellernames = [String]()
    var selleraddresses = [String]()
    var sellerprices = [String]()
    var sellerdistances = [String]()
    var availablitily = [String]()
    var sellerlats = [String]()
    var sellerlongs = [String]()

    
    var thisproductid = relevantproductids[thisproduct]
    
    func updatedistances() {
        
        sellerdistances.removeAll()
        
        var counter = 0
        
        for bizlatitude in sellerlats {
            
            let manager = CLLocationManager()
            
            if let location = manager.location?.coordinate {
                
                if counter < sellerlats.count {
                    
                    var bizLocation = CLLocation(latitude: (Double(sellerlats[counter])!) , longitude: Double(sellerlongs[counter])!)
                    
                    var cluserLocation = CLLocation(latitude: (location.latitude), longitude: (location.longitude))
                    
                    var distance = cluserLocation.distance(from: bizLocation) / 1000 * 0.621371
                    
                    print("\(cluserLocation) & \(bizLocation) & \(distance)")
                    
                    sellerdistances.append(String(format: "%.2f", distance))
                    
                    counter += 1
                    
                    self.tableViewTwo.reloadData()
                    
                }
                
            }
            
            
        }
        
        
    }

    
    func getsellerids(completed: @escaping ( () -> () )) {
    
            sellerids.removeAll()
    
            var functioncounter = 0
    
                self.ref?.child("Products").child("\(thisproductid)").child("Sellers").observeSingleEvent(of: .value, with: { (snapshot) in
    
                        if let snapDict = snapshot.value as? [String:AnyObject] {
    
                            for each in snapDict {
    
                                let ids = each.key
    
                                sellerids.append(ids)
    
                                functioncounter += 1
    
                                if functioncounter == snapDict.count {
    
                                    sellerids = Array(Set(sellerids))
                                    
                                    completed()
    
                                }
    
                            }
    
                        }
                        
                        
                    })
    
                
            }


    func queryforsellerdata(completed: @escaping ( () -> () )) {
        
       sellernames.removeAll()
        selleraddresses.removeAll()
        sellerprices.removeAll()
        sellerlats.removeAll()
        sellerlongs.removeAll()
        availablitily.removeAll()
        
        var functioncounter = 0
        
        for each in sellerids {
            
            self.ref?.child("Products").child("\(thisproductid)").child("Sellers").child("\(each)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary
                
                
                if var name = value?["StoreName"] as? String {
                    
                    self.sellernames.append(name)
                    
                }
                
                if var address = value?["StoreAddress"] as? String {
                    
                    self.selleraddresses.append(address)
                    
                }
                
                if var price = value?["Price"] as? String {
                    
                   self.sellerprices.append(price)
                    
                }
                
                if var long = value?["Longitude"] as? String {
                    
                    self.sellerlongs.append(long)
                    
                }
                
                if var latitude = value?["Latitude"] as? String {
                    
                    self.sellerlats.append(latitude)
                    
                }
                
                self.tableViewTwo.reloadData()
            
                functioncounter += 1
                
                if functioncounter == sellerids.count {
                    
                    completed()
                    
                }
                
            })
            
           
            
            
        }
        
        self.tableViewTwo.reloadData()
        
    }

    
    func queryforproductdata() {
    
        var thisproductid = relevantproductids[thisproduct]
        
            self.ref?.child("Products").child("\(thisproductid)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary
                
//                if var name = value?["StoreName"] as? String {
//                    
//                    self.storename.text = name
//                    
//                }
//                
//                if var address = value?["StoreAddress"] as? String {
//                    
//                    self.storeaddress.text = address
//                   
//                    
//                }
                
                if var descriptionn = value?["Description"] as? String {
                    
                    self.descriptionlabel.text = descriptionn
                    
                }
                
                if var aboutbrand = value?["AboutBrand"] as? String {
                    
                    self.about.text = aboutbrand
                    
                }
                
//                if var hours = value?["HoursOpen"] as? String {
//                    
//                    self.openhours.text = hours
//                    
//                }
//    
            })
        
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
        
        if tableView.tag == 1 {
            
            return sellernames.count
            
            
        } else {
            
            return 1

        }
        
        
    }
    
    @IBOutlet weak var tableViewTwo: UITableView!
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 1 {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SellersTableViewCell
        
            if sellernames.count > indexPath.row {
                
                 cell.name.text = sellernames[indexPath.row]
            }
            
            if selleraddresses.count > indexPath.row {
                
                cell.address.text = selleraddresses[indexPath.row]
            }
            
            if sellerprices.count > indexPath.row {
                
                cell.price.text = sellerprices[indexPath.row]
            }
            
            if sellerdistances.count > indexPath.row {
                
                cell.distanceaway.text = sellerdistances[indexPath.row]
            }
            
            if availablitily.count > indexPath.row {
                
                cell.availability.text = "Available"
            }
       
            
        return cell

        }
        
        if tableView.tag == 0 {
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "ActualProductDetails", for: indexPath) as! ActualProductDetailsTableViewCell
            
                return cell
        }
        
        let cell = UITableViewCell()
        
        return cell

        
    }

}
