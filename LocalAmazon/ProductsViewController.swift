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
var storenames = [String]()
var addresses = [String]()
var sellerids = [String:Int]()
var searchstrings = [String]()

var ignored = false

var firstlaunch = true

var searched = false


var thisproduct = 0

class ProductsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    @IBAction func tapContinueAnyway(_ sender: Any) {
        
        continueanyway.alpha = 0
        notavailablelabel.alpha = 0
        ignored = true
        self.tableView.alpha = 1
        
    }
    @IBOutlet weak var continueanyway: UIButton!
    @IBOutlet weak var popularlabel: UILabel!
    var searchController: UISearchController!
    
    @IBOutlet weak var loadingbackground: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var locationManager = CLLocationManager()
    
    var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var ref: FIRDatabaseReference?

  
    @IBOutlet weak var currentlocation: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let user = FIRAuth.auth()?.currentUser
        
        if let uid = user?.uid {
            
            if let location = manager.location?.coordinate  {
                
                ref?.child("Users").child(uid).child("Location").setValue(["Latitude" : "\(location.latitude)", "Longitude" : "\(location.longitude)"])
                
            }
            
        }
        
    }
    
    func displayusersaddress() {
        
        let manager = CLLocationManager()
        
        if let location = manager.location?.coordinate {
        
        let geoCoder = CLGeocoder()
            
        var cluserLocation = CLLocation(latitude: (location.latitude), longitude: (location.longitude))

        geoCoder.reverseGeocodeLocation(cluserLocation, completionHandler: { (placemarks, error) in
            
            var placeMark: CLPlacemark!
            
            placeMark = placemarks?[0]
            
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                
                print(street)
            
            self.currentlocation.text = placeMark.addressDictionary?["Thoroughfare"] as? String
            
            }
            
        })

        }
    }
    
    let lightgreen = UIColor(red:0.23, green:0.77, blue:0.58, alpha:1.0)
    

    
    
    
    
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
                    
                        allproductids = Array(Set(allproductids))
                        
                        completed()
                        
                    }
                    
                }
                
            }
            
            
        })
        
        
    }

    


    
    func queryforrelevantids(completed: @escaping () -> () ) {
        
        searchstrings.removeAll()
        
        relevantproductids.removeAll()
        
        searchstrings = (searchString.components(separatedBy: " "))
        
        var functioncounter = 0
        
        for each in allproductids {
            
            self.ref?.child("Products").child("\(each)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary
                
                if var name = value?["Title"] as? String {
                    
                    if var brand = value?["Brand"] as? String {
                        
                        if var word = searchString as? String {
                            
//                        
//                        if name.caseInsensitiveCompare(word) == ComparisonResult.orderedSame || brand.caseInsensitiveCompare(word) == ComparisonResult.orderedSame || name.contains(word.capitalized) || word.contains(searchString)  || name.contains(word) || brand.contains(word.capitalized) || name.contains(word.lowercased()) || brand.contains(word.lowercased())
                        
                            if name.contains(word.capitalized) || word.contains(name.capitalized) || brand.contains(word.capitalized) || word.contains(brand.capitalized) || name.contains(word.lowercased()) || brand.contains(word.lowercased()) || word.contains(brand.lowercased()) || word.contains(name.lowercased()){
                                
                            
                            
                            relevantproductids.append(each)
                            
                            relevantproductids = Array(Set(relevantproductids))
                            
                        }
                        
                        }
                        }
                        
                    }
                
                functioncounter += 1
                
                if functioncounter == allproductids.count {
                    
                    completed()
                    
                    relevantproductids = Array(Set(relevantproductids))
                    
                    if relevantproductids.count == 0 {
                        
                        
//                                    self.loadingbackground.alpha = 0
//                                    self.activityIndicator.alpha = 0
//                                    self.activityIndicator.stopAnimating()
                    }
                }


            })
            
        }
        
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    func queryforproductdata(completed: @escaping () -> () ){
        
        
        var functioncounter = 0
        
        productimages.removeAll()
        titles.removeAll()
        prices.removeAll()
        brands.removeAll()
        distances.removeAll()
        quantities.removeAll()
        distances.removeAll()
        storenames.removeAll()
        addresses.removeAll()
        reviewss.removeAll()

        
        for each in relevantproductids {
            
            self.ref?.child("Products").child("\(each)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary
                
                
                if var productitle = value?["Title"] as? String {
                    
                    titles.append(productitle)
                    
                }
                
                if var reviewnumber = value?["Brand"] as? String {
                    
                    brands.append(reviewnumber)
                    
                }
                
                if var quantity = value?["Quantity"] as? String {
                    
                    quantities.append(quantity)
                    
                }
                
     
                
                if var address = value?["AddressOfLowestPrice"] as? String {
                    
                    addresses.append(address)
                    
                }
                
                if var reviewnumber = value?["ReviewNumber"] as? String {
                    
                    reviewss.append(reviewnumber)
                    
                } else {
                    
                    reviewss.append("0")
                    
                }
                
                
                if var lowprice = value?["LowestPrice"] as? String {
                    
                    prices.append(lowprice)
                    
                }
                
                if var productimagee = value?["Image"] as? String {
                    
                    if productimagee.hasPrefix("http://") || productimagee.hasPrefix("https://") {
                        
                        let dummy = UIImage()
                        
                        productimages.append(dummy)
                        
                        let insertionIndex = productimages.count - 1
                        
                        let url = URL(string: productimagee)
                        
                        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        
                            if data != nil {
                                
                                let productphoto = UIImage(data: (data)!)
                                
                                if productimages.count > insertionIndex {
                                
                                productimages[insertionIndex] = productphoto!
                                
                                self.tableView.reloadData()
                                    
                                }
         
                            }
                        
                        
                    } else {
                        
                        let test = UIImage()
                        
                        productimages.append(test)
                    }
                    
                }
                
                var long = value?["CheapestLongitude"] as? String
                
                var latitude = value?["CheapestLatitude"] as? String
                
                let manager = CLLocationManager()
                
                if let location = manager.location?.coordinate {
                    
                    if long != "" && latitude != "" {
                
                    var bizLocation = CLLocation(latitude: (Double(latitude!))! , longitude: Double(long!)!)
                    
                    var cluserLocation = CLLocation(latitude: (location.latitude), longitude: (location.longitude))
                    
                    var distance = cluserLocation.distance(from: bizLocation) / 1000 * 0.621371
                        
                        if ignored == false {
                        
                            if distance > 100 {
                            
                            self.notavailablelabel.alpha = 1
                            self.loadingbackground.alpha = 1
                            self.continueanyway.alpha = 1
                            self.tableView.alpha = 0
                        }
                            
                        } else {
                            
                            self.notavailablelabel.alpha = 0
                            self.loadingbackground.alpha = 0
                            self.continueanyway.alpha = 0
                            self.activityIndicator.alpha = 0
                            
                        }
                    
                    distances.append(String(format: "%.2f", distance))
                        
                    } else {
                        
                        distances.append("")
                    }
                }
                
                
                self.tableView.reloadData()
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
    
    
    @IBOutlet weak var tableViewTwo: UITableView!
    @IBOutlet weak var notavailablelabel: UILabel!
    var categories = [String]()
    
    
    override func viewDidLoad() {
        
                if allproductids.count == 0  {
        
                    queryforproductids { () -> () in
        
                    }
                }
        
        categories.removeAll()
        
        categories.append("Perfect Foods Peanut Butter Bar")
        categories.append("Organic Chicken Breast")
        categories.append("Bob's Red Mill Oats")
        categories.append("Alba Botanica Facial Cleanser")
        categories.append("Vegan Protein")
        
        
        
        ref = FIRDatabase.database().reference()
        
        super.viewDidLoad()
        
        
        errorlabel.alpha = 0
        
        activityIndicator.alpha = 0
        loadingbackground.alpha = 0
        
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
            
                DispatchQueue.main.async {
                    
                    self.performSegue(withIdentifier: "ShopToNotifications", sender: self)
                }

            case .authorizedAlways, .authorizedWhenInUse:
                
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                displayusersaddress()

                
            default: break

            }
        }
        
    
//        if searchString == "" {
        
        
        if searched == false {
            
            tableViewTwo.alpha = 1
            tableView.alpha = 0
            popularlabel.alpha = 1
            
        }
        
        
            
//        } else {
//            
//            tableViewTwo.alpha = 0
//            tableView.alpha = 1
//            popularlabel.alpha = 0
//        }
        
        
        self.tableViewTwo.reloadData()
        
        self.errorlabel.alpha = 0
    
                
        let lightbrown = UIColor(red:0.96, green:0.95, blue:0.93, alpha:1.0)
        
        searchBar.backgroundColor = lightgreen
        searchBar.barTintColor = lightgreen
        searchBar.searchBarStyle = .prominent
        
        tableView.reloadData()
        
        tableViewTwo.separatorStyle = .none
        
        if ignored == false {

        continueanyway.alpha = 0
        notavailablelabel.alpha = 0

        }
        

        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var errorlabel: UILabel!
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
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
            
        if titles.count > 0 {
            
            if ignored == false {
                
                self.tableView.alpha = 0
                
                notavailablelabel.alpha = 1
                loadingbackground.alpha = 1
                continueanyway.alpha = 1
                
            } else {
                
                tableView.alpha = 1
            }
//            errorlabel.alpha = 0
            
//            loadingbackground.alpha = 0
//            activityIndicator.alpha = 0
//            activityIndicator.stopAnimating()
            
            return titles.count
            
            
            
        } else {
            
 
            
            tableView.alpha = 0
            
            
            return 0
            
            }
            
        }
            
        if tableView.tag == 2 {
            
            return categories.count
            
        } else {
            
            return 0
        }
            
        
       

    }
  
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 1 {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetails", for: indexPath) as! ProductDetailsTableViewCell
        
        if prices.count > indexPath.row {
            
            if firstlaunch == false {
                
                if prices[indexPath.row] == "" {
                    
                    cell.price.text = ""
                    cell.price.textColor = .gray
                    
                } else {
            
                    cell.price.text = "$\(prices[indexPath.row])"
                    cell.price.textColor = lightgreen
                    
                }
                
            }

        } else {
            
            cell.price.text = ""
        }
        
        if brands.count > 0 {
            
            if prices[indexPath.row] == "" {
                
                cell.servings.text = "No locations available"
                cell.servings.textColor = .gray
                
            } else {
                
                cell.servings.text = "at \(brands[indexPath.row])"
                
            }
            
        }
        
        if reviewss.count > indexPath.row {
            
            if reviewss[indexPath.row] != "0" {
            
            cell.reviews.text = "(\(reviewss[indexPath.row]))"
                
            } else {
                
                cell.reviews.alpha = 0

            }
            
        }
        
        if titles.count > indexPath.row {
            
            cell.productname.text = titles[indexPath.row]

        } else {
            
            cell.productname.text = ""
        }
        
        if productimages.count > indexPath.row {
            
            cell.productimage.image = productimages[indexPath.row]

        } else {
            
            cell.productimage.image = nil
        }
        
        if distances.count > indexPath.row {
            
            if distances[indexPath.row] != "" {
            
            cell.distanceaway.text = "\(distances[indexPath.row]) mi"
                
            } else {
                
                cell.distanceaway.text = ""
            }
            
        } else {
            
            cell.distanceaway.text = ""
            
        }
  
        
        return cell
            
        }
        
        if tableView.tag == 2 {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "POPSEARCH", for: indexPath) as! PopularSearchesTableViewCell
            
            if categories.count > 0 {
                
                cell.category.text = categories[indexPath.row]
            }
            
            
            return cell
        }
        
        
        let cell = UITableViewCell()
        
        return cell
        
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        
    {
        
        if tableView.tag == 1 {
            
        
        
        thisproduct = indexPath.row
       
        self.performSegue(withIdentifier: "ProductsToDetails", sender: self)
            
        }
        
        if tableView.tag == 2 {
            
            searched = true
            
            activityIndicator.alpha = 1
            activityIndicator.startAnimating()
            
            loadingbackground.alpha = 1
            
            searchString = categories[indexPath.row]
            
            searchBar.text = categories[indexPath.row]
            
            tableViewTwo.alpha = 0
            popularlabel.alpha = 0
            
            self.tableView.alpha = 0
            notavailablelabel.alpha = 0
            continueanyway.alpha = 0
            
            firstlaunch == false
            
            if allproductids.count == 0 {
                
            self.queryforproductids { () -> () in
            
                self.queryforrelevantids { () -> () in
                    
                    if relevantproductids.count > 0 {
                        
                        self.queryforproductdata{ () -> () in
                            
                            self.tableView.alpha = 1
                            
                            self.tableViewTwo.alpha = 0
                            self.popularlabel.alpha = 0
                            
                            self.tableView.reloadData()
                            
                            self.errorlabel.alpha = 0
                            
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.alpha = 0
                            
                            self.loadingbackground.alpha = 0
                            
                            
                        }
                        
                    } else {
                        
                        self.errorlabel.alpha = 1
                        
                        self.errorlabel.text = "No available products. Please refine your search"
                        
                        self.loadingbackground.alpha = 0
                        self.activityIndicator.alpha = 0
                        self.activityIndicator.stopAnimating()
                    }
                    
                }
                
                }
                
                
            } else {
                
                self.queryforrelevantids { () -> () in
                    
                    if relevantproductids.count > 0 {
                    
                    self.queryforproductdata{ () -> () in
                        
                        self.tableView.alpha = 1
                        
                        self.tableViewTwo.alpha = 0
                        self.popularlabel.alpha = 0
                        
                        self.tableView.reloadData()
                        
                        self.errorlabel.alpha = 0
                        
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.alpha = 0
                        
                        self.loadingbackground.alpha = 0
                  
                        
                    }
                        
                    } else {
                        
                        self.errorlabel.alpha = 1
                        
                        self.errorlabel.text = "No available products. Please refine your search"
                        
                       self.loadingbackground.alpha = 0
                        self.activityIndicator.alpha = 0
                       self.activityIndicator.stopAnimating()
                    }
                    
                }
                
                self.tableView.reloadData()

                
                
            }
        
        
    }
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
        
        loadingbackground.alpha = 1
        
        searchString = searchBar.text!
        
        
        tableViewTwo.alpha = 0
        popularlabel.alpha = 0
        
        self.tableView.alpha = 0
        notavailablelabel.alpha = 0
        continueanyway.alpha = 0
        
        firstlaunch == false
        
        searched = true
        
        if allproductids.count == 0 {
            
            self.queryforproductids { () -> () in
                
                self.queryforrelevantids { () -> () in
                    
                    if relevantproductids.count > 0 {
                        
                        self.queryforproductdata{ () -> () in
                            
                            self.tableView.alpha = 1
                            
                            self.tableViewTwo.alpha = 0
                            self.popularlabel.alpha = 0
                            
                            self.tableView.reloadData()
                            
                            self.errorlabel.alpha = 0
                            
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.alpha = 0
                            
                            self.loadingbackground.alpha = 0
                            
                        
                            
                            
                        }
                        
                    } else {
                        
                        self.errorlabel.alpha = 1
                        
                        self.errorlabel.text = "No available products. Please refine your search"
                        
                        self.loadingbackground.alpha = 0
                        self.activityIndicator.alpha = 0
                        self.activityIndicator.stopAnimating()
                        
                        self.tableView.alpha = 0
                    }
                    
                }
                
            }
            
            
        } else {
            
            self.queryforrelevantids { () -> () in
                
                if relevantproductids.count > 0 {
                    
                    self.queryforproductdata{ () -> () in
                        
                        self.tableView.alpha = 1
                        
                        self.tableViewTwo.alpha = 0
                        self.popularlabel.alpha = 0
                        
                        self.tableView.reloadData()
                        
                        self.errorlabel.alpha = 0
                        
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.alpha = 0
                        
                        self.loadingbackground.alpha = 0
                        
                       
                        
                        
                    }
                    
                } else {
                    
                    self.errorlabel.alpha = 1
                    
                    self.errorlabel.text = "No available products. Please refine your search"
                    
                    self.loadingbackground.alpha = 0
                    self.activityIndicator.alpha = 0
                    self.activityIndicator.stopAnimating()
                    
                    self.tableView.alpha = 0

                }
                
            }
            
            self.tableView.reloadData()
            
            
            
        }
        
        searchBar.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    

}


