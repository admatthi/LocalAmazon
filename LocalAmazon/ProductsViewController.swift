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
import SwiftyJSON

var allproductids = [String]()
var relevantproductids = [String]()
var productimages = [UIImage]()
var titles = [String:UIImage]()
var prices = [String]()
var brands = [String]()
var distances = [String:String]()
var quantities = [String]()
var bizlongitudes = [String]()
var bizlatitudes = [String]()
var reviewss = [String]()
var storenames = [String]()
var addresses = [String]()
var sellerids = [String:String]()
var searchstrings = [String]()
var thistitle = [String]()

var autocompletesearches = [String]()

var searchString = String()

var distanceaway = [String:String]()

var brandss = [String:String]()

var pricess = [String:String]()

var storenamess = [String:String]()

var productids = [String:String]()

var ignored = false

var firstlaunch = true

var searched = false

var userlong = Double()
var userlat = Double()
var userlocation = ""

var comingfromshop = Bool()

var thisproduct = 0

class ProductsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    @IBAction func tapContinueAnyway(_ sender: Any) {
        
        continueanyway.alpha = 0
        notavailablelabel.alpha = 0
        ignored = true
        
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
    

    
    let lightgreen = UIColor(red:0.23, green:0.77, blue:0.58, alpha:1.0)
    
    

    
    
    var minuserlat = Double()
    var minuserlong = Double()
    
    var relevantsellerids = [String]()
    
    func calculatemaxuserlongandlat() {
        
        let manager = CLLocationManager()
        
        if let location = manager.location?.coordinate {
            
                var cluserLocation = CLLocation(latitude: (location.latitude), longitude: (location.longitude))
            
                userlong = location.longitude
                userlat = location.latitude
            
                userlocation = "\(String(userlat)), \(String(userlong))"

            
        }
    }
    
    
    
    @IBOutlet weak var tableViewTwo: UITableView!
    @IBOutlet weak var notavailablelabel: UILabel!
    var categories = [String]()
    
    
    override func viewDidLoad() {
        
        self.tableViewThree.separatorStyle = .none
        
        if comingfromshop == true  {
            
            comingfromshop = false
            
            searchString = "Organic" 
            
            searchwithsearchstring()
            
            tableView.alpha = 1
            tableViewTwo.alpha = 0
            popularlabel.alpha = 0
            dividerline.alpha = 0

        }
        
        shoptodetails = false 

        tableViewThree.alpha = 0
        
        activityIndicator.alpha = 0

        loadingbackground.alpha = 0
        categories.removeAll()
        
        categories.append("Fruit Bar")
        categories.append("Organic Cheese")
        categories.append("Gluten Free")
        categories.append("Cleanser")
        categories.append("Healthy Protein")
        
        ref = FIRDatabase.database().reference()
        
        super.viewDidLoad()
        
        
        errorlabel.alpha = 0


        
      
    
////        if searchString == "" {
//        
//        
        if searched == false {
            
            tableViewTwo.alpha = 1
            tableView.alpha = 0
            popularlabel.alpha = 1
            dividerline.alpha = 1
            
            
        } else {
            
            tableView.alpha = 1
            tableViewTwo.alpha = 0
            popularlabel.alpha = 0
            dividerline.alpha = 0
        }
        
//
        
        self.tableViewTwo.reloadData()
        
        
        let healthybrown = UIColor(red:0.96, green:0.95, blue:0.93, alpha:1.0)
    
        
        let healthygrey = UIColor(red:0.59, green:0.58, blue:0.59, alpha:1.0)
        
        

        
        searchBar.backgroundColor = healthybrown
//        searchBar.barTintColor = lightgreen
        searchBar.delegate = self

        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        
        
        
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        
        
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        
        
        textFieldInsideSearchBar?.textColor = healthygrey
        textFieldInsideSearchBarLabel?.textColor = healthygrey
        
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = healthygrey

        
//        searchBar.searchBarStyle = .prominent
        
        tableView.reloadData()
        
        tableViewTwo.separatorStyle = .none
        
        if ignored == false {

        continueanyway.alpha = 0
        notavailablelabel.alpha = 0

        }
        
        calculatemaxuserlongandlat()

        
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
  
    @IBOutlet weak var dividerline: UILabel!
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
            
            self.popularlabel.alpha = 0
            dividerline.alpha = 0

            
            self.notavailablelabel.alpha = 0
            self.continueanyway.alpha = 0
            

            return titles.count
            
            
        } else {
            
            tableView.alpha = 0
            
            return 0
            
            }
            
        }
            
        if tableView.tag == 2 {
            
            return categories.count
            
        }
            
        if tableView.tag == 3 {
            
            return autocompletesearches.count
            
        }
        
        
        else {
            
            return 0
        }
            
        
       

    }
    
  
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 1 {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetails", for: indexPath) as! ProductDetailsTableViewCell
        
        if pricess.count - 1 > indexPath.row && thistitle.count - 1 > indexPath.row {
        
                cell.price.text = "$\(pricess[thistitle[indexPath.row]]!)"
                cell.price.textColor = lightgreen
                    
            
        } else {
            
            cell.price.text = ""
        }
        
        if storenamess.count - 1 > indexPath.row {
            
                cell.servings.text = "at \(storenamess[thistitle[indexPath.row]]! )"
                
        } else {
            
            cell.servings.text = "No locations available"

            }
 
        if reviewss.count  > indexPath.row {
            
            if reviewss[indexPath.row] != "0" {
            
            cell.reviews.text = "(\(reviewss[indexPath.row]))"
                
            } else {
                
                cell.reviews.alpha = 0

            }
            
        } else {
            
            cell.reviews.alpha = 0

            }
        
        if thistitle.count > indexPath.row {
            
            cell.productname.text = thistitle[indexPath.row]

        } else {
            
            cell.productname.text = ""
        }
        
        if titles.count > indexPath.row  && thistitle.count > indexPath.row {
            
            cell.productimage.image = titles[thistitle[indexPath.row]]

        } else {
            
            cell.productimage.image = UIImage(named: "LoadingImage")
        }
        
        if distanceaway.count + 1 > indexPath.row && thistitle.count  + 1 > indexPath.row {
            
            if distanceaway[thistitle[indexPath.row]] != "" {
            
            cell.distanceaway.text = "\(distanceaway[thistitle[indexPath.row]]!) mi"
                
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
        
        if tableView.tag == 3 {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AutoCompleteCell", for: indexPath) as! AutoCompleteTableViewCell
            
            if autocompletesearches.count > 0 {
                
                cell.textlabel.text = autocompletesearches[indexPath.row]
            }
            
            cell.selectionStyle = .gray
            
            
            return cell
        }
        
        
        let cell = UITableViewCell()
        
        return cell
        
    }
    
    @IBOutlet weak var tableViewThree: UITableView!
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        
    {
        
        if tableView.tag == 1 {
            
        thisproduct = indexPath.row
       
        self.performSegue(withIdentifier: "ProductsToDetails", sender: self)
            
        }
        
        if tableView.tag == 2 {
            
            searchString = categories[indexPath.row]
            
            searchBar.text = categories[indexPath.row]
            
            searchwithsearchstring()
        
        }
        
        if tableView.tag == 3 {
            
            
            if autocompletesearches.count > 0 {

                searchString = autocompletesearches[indexPath.row]
            
                searchBar.text = autocompletesearches[indexPath.row]
                
                searchwithsearchstring()
            
            
            }

            
        }
    }
 
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        
    }
    
   
    
    var timercounter = 0
    
    func noavailableproducts() {
        
        timercounter += 1
        
        if found == false {
        
        if timercounter > 5 {
            
            self.activityIndicator.alpha = 0
            self.activityIndicator.stopAnimating()
            self.loadingbackground.alpha = 0
            self.tableView.alpha = 0
            self.tableViewTwo.alpha = 0
            
            self.errorlabel.alpha = 1
            self.errorlabel.text = "This is our fault. We couldn't find any products that matched your search in your area."
            
            timer.invalidate()
        }
            
        }
        
    }
    
    
    var timer = Timer()
    
    var found = Bool()
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchString = searchBar.text!
        
        searchwithsearchstring()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            tableViewThree.alpha = 0
            tableView.alpha = 1
            tableViewTwo.alpha = 0
            
            
        } else {
            
            
            searchString = searchBar.text! + " "
            
            
            tableView.alpha = 0
            tableViewTwo.alpha = 0
            tableViewThree.alpha = 1
            autocompletesearchers()
            
            self.tableViewThree.reloadData()

        }
        
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
  
    }
    
    
    func searchwithsearchstring()  {
        
        
        
        FIRAnalytics.logEvent(withName: "searched", parameters: [
            

            "Term": searchString as NSObject
            
            ])
        
        timercounter = 0
        
        found = false
        
        searched = true
        
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
        loadingbackground.alpha = 1
        tableView.alpha = 0
        tableViewTwo.alpha = 0
        popularlabel.alpha = 0
        dividerline.alpha = 0
 
       
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ProductsViewController.noavailableproducts), userInfo: nil, repeats: true)
        
        titles.removeAll()
        prices.removeAll()
        brands.removeAll()
        addresses.removeAll()
        storenames.removeAll()
        productimages.removeAll()
        thistitle.removeAll()
        
        pricess.removeAll()
        brandss.removeAll()
        storenamess.removeAll()
        distanceaway.removeAll()
        productids.removeAll()
        quantities.removeAll()
        
        var functioncounter = 0
        
        popularlabel.alpha = 0
        dividerline.alpha = 0

        

        let endpoint: String = "https://fb8505096e053937ef65abd75770d7ef.us-west-1.aws.found.io:9243/products/product/_search"
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let jsonObject: [String: Any] =  [ "size" : 500,
            "sort" : [ "_score",
                       [ "store_price" : ["order" : "asc" ] ],
                       [ "_geo_distance" : [ "store_geoloc" : userlocation, "order" : "asc", "unit" : "mi"] ]
            ],
            "query": [
                "bool": [
                    "must": [ "match": [ "product_name": searchString], ],
                    "filter": [ "geo_distance": [ "distance": "25mi", "store_geoloc": userlocation] ],
                ],
            ],
            ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject)
        
        var urlRequest = URLRequest(url:url)
        urlRequest.httpBody = jsonData
        urlRequest.httpMethod = "POST"
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        
        var producttitle = String()
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
       
            
            do {
                
                let json = JSON(data: data!)
                
                let data = data
                
                DispatchQueue.global(qos: .utility).async {
                    
                    for (index,subJson):(String, JSON) in json["hits"]["hits"] {
                        
//                                        print(index)
//                                        print(subJson["_source"]["product_name"].string!)
//                                        print(subJson["_source"]["product_img"].string!)
//                                        print(subJson["_source"]["store_price"].string!)
//                                        print(subJson["_source"]["store_name"].string!)
//                                        print(subJson["_source"]["store_address"].string!)
//                                        print(subJson)
                        
                        
                        
                        
                        producttitle = (subJson["_source"]["product_name"].string)!
                        
                        if thistitle.contains(producttitle) {
                            
                            
                        } else {
                        
                            thistitle.append(producttitle)
                            
                            titles[producttitle] = UIImage()
                            
                            if var reviewnumber = subJson["_source"]["store_name"].string {
                                
                                
                                storenamess[producttitle] = reviewnumber
                                
                            }
                            
                                
                            
                            
                            if var lowprice = subJson["_source"]["store_price"].float {
                                
                                
                                var stringlowprice = String(format: "%.2f", lowprice)
                                
                                pricess[producttitle] = stringlowprice
                                
                                
                                
                            }
                            
                            if var distance = subJson["sort"][2].float {
                                
                                distanceaway[producttitle] = (String(format: "%.2f", distance))

                                
                            }
                            
                            
                            if var productimagee = subJson["_source"]["product_img"].string {
                                
                                if productimagee.hasPrefix("http://") || productimagee.hasPrefix("https://") {
                                    //
                                    //                                let dummy = UIImage()
                                    //
                                    //                                productimages.append(dummy)
                                    
                                    let insertionIndex = productimages.count - 1
                                    
                                    let url = URL(string: productimagee)
                                    
                                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                                    
                                    if data != nil {
                                        
                                        let productphoto = UIImage(data: (data)!)
                                        
                                        //                                    if productimages.count > insertionIndex {
                                        
                                        titles[producttitle] = productphoto!
                                        
                                        
                                        
                                        //                                    }
                                        
                                    }
                                    
                                    
                                } else {
                                    
                                    let test = UIImage(named: "LoadingImage")
                                    
                                    titles[producttitle] = test
                                }

                            


                        }
                        
                        
                    
                    if var productid = subJson["_source"]["product_id"].string {
                        
                        productids[producttitle] = productid
                        
                    }
                            
//                    if var quantity = subJson["_source"]["product_quantity"].string {
//                                
//                                quantities[producttitle] = quantity
//                                
//                    }
//                    
                    
                                                   //
                            
                            
                            DispatchQueue.main.async {
                                
                                self.tableView.reloadData()
                                
                                    self.activityIndicator.alpha = 0
                                    self.activityIndicator.stopAnimating()
                                    self.loadingbackground.alpha = 0
                                    self.tableView.alpha = 1
                                    self.tableViewTwo.alpha = 0
                                    self.tableViewThree.alpha = 0
                                
                                    self.found = true
                              
                           }
                        }


                                                
                      
                        
                        
                    }
                    
                    
            }

                    
                    
                    
            } catch {
                
                DispatchQueue.main.async {
                    
//                    self.tableView.reloadData()
                    
                    
                }
            
        
            }
                
        
    
        
        }

        task.resume()
        
        searchBar.resignFirstResponder()
    }
    

   
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
        
 
    
    
    
    func autocompletesearchers() {
        
        timercounter = 0
        

        tableView.alpha = 0
        tableViewTwo.alpha = 0
        tableViewThree.alpha = 1
        
        
        
        let endpoint: String = "https://fb8505096e053937ef65abd75770d7ef.us-west-1.aws.found.io:9243/products/product/_search"
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let jsonObject: [String: Any] =  [ "size" : 500,
                                           "sort" : [ "_score",
                                                      [ "store_price" : ["order" : "asc" ] ],
                                                      [ "_geo_distance" : [ "store_geoloc" : userlocation, "order" : "asc", "unit" : "mi"] ]
            ],
                                           "query": [
                                            "bool": [
                                                "must": [ "match": [ "product_name": searchString], ],
                                                "filter": [ "geo_distance": [ "distance": "25mi", "store_geoloc": userlocation] ],
                                            ],
            ],
                                           ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject)
        
        var urlRequest = URLRequest(url:url)
        urlRequest.httpBody = jsonData
        urlRequest.httpMethod = "POST"
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        
        var producttitle = String()
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            
            do {
                
                let json = JSON(data: data!)
                
                let data = data
                
                autocompletesearches.removeAll()
                
                DispatchQueue.global(qos: .utility).async {
                    
                    
                    for (index,subJson):(String, JSON) in json["hits"]["hits"] {
                        
                        //                                        print(index)
                        //                                        print(subJson["_source"]["product_name"].string!)
                        //                                        print(subJson["_source"]["product_img"].string!)
                        //                                        print(subJson["_source"]["store_price"].string!)
                        //                                        print(subJson["_source"]["store_name"].string!)
                        //                                        print(subJson["_source"]["store_address"].string!)
                        //                                        print(subJson)
                        
                        
                        
                        
                        var text = (subJson["_source"]["product_name"].string)!
                    
                        if autocompletesearches.contains(text) {
                            
                        } else {
                            
                            autocompletesearches.append(text)
                            
                            self.tableViewThree.reloadData()
                            
                            print("motherfucker \(autocompletesearches.count)")
                            
                            
                        }
                        
                        
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.tableViewThree.reloadData()
                    }
                    

                }
                
            } catch {
                
                
                DispatchQueue.main.async {
                    
                    
                    
                }

            }
            
            
            
            
        }
        
        task.resume()
    }
    
    

}





