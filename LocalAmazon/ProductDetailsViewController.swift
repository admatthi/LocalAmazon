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
import FirebaseDatabase
import Firebase
import SwiftyJSON

class ProductDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var citystateziplabel: UILabel!
    @IBOutlet weak var featureslabel: UILabel!
    @IBOutlet weak var featurestext: UILabel!
    @IBOutlet weak var price: UILabel!

    @IBOutlet weak var reviewshighlight: UILabel!
    @IBOutlet weak var locationshighlight: UILabel!
    @IBOutlet weak var detailshighlight: UILabel!
    @IBOutlet weak var about: UILabel!
    
    @IBOutlet weak var aboutthebrand: UILabel!
    
    
    @IBOutlet weak var descriptiontitle: UILabel!
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reviewstwo: UILabel!
    
    @IBOutlet weak var reviewimagetwo: UIImageView!
    
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
        reviewshighlight.alpha = 1

    }
    
    func hidereviews() {
       
        reviewstwo.alpha = 0
        reviewimagetwo.alpha = 0
        tableView.alpha = 0
        reviewshighlight.alpha = 0
        
    }
    
    func hidelocation() {
  
        tableViewTwo.alpha = 0
        locationshighlight.alpha = 0
    }
    
    func showlocation() {
        
   
        tableViewTwo.alpha = 1
        locationshighlight.alpha = 1

        
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
        featuretwo.alpha = 1
        featurethree.alpha = 1
        detailshighlight.alpha = 1
        
        if featurestext.text == "" {
            
            self.featureslabel.alpha = 0
            
            
        }
        
        if descriptionlabel.text == "" {
            
            self.descriptiontitle.alpha = 0
        }
        
        if about.text == "" {
            
            aboutthebrand.alpha = 0
        }
        
    }
    
    @IBOutlet weak var currentlocation: UILabel!
    func hidedetails() {
        
        about.alpha = 0
        aboutthebrand.alpha = 0
        
        descriptiontitle.alpha = 0
        descriptionlabel.alpha = 0
        featurestext.alpha = 0
        featureslabel.alpha = 0
        featuretwo.alpha = 0
        featurethree.alpha = 0
        detailshighlight.alpha = 0
        
        
    }
    
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        hidedetails()
        
        showlocation()
        hidereviews()
        
        price.text = ""
        
        productname.text = thistitle[thisproduct]
        
        
        
        

        
        // Do any additional setup after loading the view.
        
        
        

        
        if titles[thistitle[thisproduct]] != nil {
        
                productimage.image = titles[thistitle[thisproduct]]
                
            }
        
      
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
        
        getnearestsellers()
        
            self.queryforproductdata()
                
                self.queryforreviewids {
                    
                    self.queryforreviews()
                    
                    if self.reviewIDs.count > 0 {
                        
                    self.reviews.text = "(\(self.reviewIDs.count))"
                    self.reviewstwo.text = "\(self.reviewIDs.count) reviews"
                        
                    }


                    
                    self.tableView.reloadData()
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
    var reviewIDs = [String]()
    var reviewnames = [String]()
    var reviewheadlines = [String]()
    var reviewtext = [String]()
    

    
    var thisproducttitle = thistitle[thisproduct]
    
    
    
    
    func queryforreviewids(completed: @escaping ( () -> () )) {
        
        var functioncounter = 0
        
        self.ref?.child("Products").child("\(thisproductid)").child("Reviews").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapDict = snapshot.value as? [String:AnyObject] {
                
                for each in snapDict {
                    
                    let ids = each.key
                    
                    self.reviewIDs.append(ids)
                    
                    functioncounter += 1
                    
                    if functioncounter == snapDict.count {
                        
                        completed()
                        
                    }
                    
                }
                
            } else {
                
                completed()
            }
            
        })
        
        
    }
    
    
    func queryforreviews() {
        
        var functioncounter = 0
        
        if reviewIDs.count > 0 {
            
            for each in reviewIDs {
                
                self.ref?.child("Products").child("\(thisproductid)").child("Reviews").child("\(each)").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    var value = snapshot.value as? NSDictionary
                    
                    
                    if var review = value?["ReviewerName"] as? String {
                        
                        self.reviewnames.append(review)
                    }
                    
                    if var date = value?["ReviewHeadline"] as? String {
                        
                        self.reviewheadlines.append(date)
                        
                    }
                    
                    if var userid = value?["ReviewText"] as? String {
                        
                        self.reviewtext.append(userid)
                    }
                    
                    
                    self.tableView.reloadData()

                })
                
                tableView.reloadData()
                
            }
            
        }
        
    }
    




    
  
    var thisproductid = thistitle[thisproduct]
    
    func queryforproductdata() {
        
            self.ref?.child("Catalog").child("\(thisproductid)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary

                
                if var descriptionn = value?["Description"] as? String {
                    
                    self.descriptionlabel.text = descriptionn
                    
                    if descriptionn == "" {
                        
                        self.descriptiontitle.alpha = 0
                    }
                    
                } else {
                    
                    self.descriptiontitle.alpha = 0
                    self.descriptionlabel.alpha = 0
                }
                
                if var aboutbrand = value?["AboutBrand"] as? String {
                    
                    self.about.text = aboutbrand
                    
                    if aboutbrand == "" {
                        
                        self.aboutthebrand.alpha = 0
                    }
                    
                } else {
                    
                    self.aboutthebrand.alpha = 0
                    self.about.alpha = 0
                }
                
                if var g = value?["Feature1"] as? String {
                    
                    self.featurestext.text = g
                    
                    if g == "" {
                        
                        self.featureslabel.alpha = 0
                    }
                    
                } else {
                    
                    self.featureslabel.alpha = 0
                    self.featurestext.alpha = 0
                }
                if var ss = value?["Feature3"] as? String {
                    
                    self.featurethree.text = ss
                    
                } else {
                    
                    self.featuretwo.alpha = 0
                }
                
                if var s = value?["Feature2"] as? String {
                    
                    self.featuretwo.text = s
                    
                } else {
                    
                    self.featurethree.alpha = 0

                }
                
//                if var hours = value?["HoursOpen"] as? String {
//                    
//                    self.openhours.text = hours
//                    
//                }
//      
                
                if value == nil {
                    
                    self.featureslabel.text = ""
                    self.featurestext.text = ""
                    self.featuretwo.text = ""
                    self.featurethree.text = ""
                    self.aboutthebrand.text = ""
                    self.about.text = ""
                    self.descriptiontitle.text = ""
                    self.descriptionlabel.text = ""


                }
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
            
            if selleraddresses.count > 7 {
                
                return 7
                
            } else {
                
                return selleraddresses.count
            }
        
            
            
        }
        
        if tableView.tag == 2 {
            
            return reviewIDs.count

        }
        
        
        else {
            
            return 1

        }
        
        
    }
    
  
    
    @IBOutlet weak var tableViewTwo: UITableView!
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 1 {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SellersTableViewCell
            
            cell.selectionStyle = .none
        
            if sellernames.count > indexPath.row {
                
                 cell.name.text = sellernames[indexPath.row]
                
            }
            
            if selleraddresses.count > indexPath.row {
                
                cell.address.text = selleraddresses[indexPath.row]
            }
            
            if sellerprices.count > indexPath.row {
                
                cell.price.text = "$\(sellerprices[indexPath.row])"
            }
            
            
            if sellerdistances.count > indexPath.row {
                
                cell.distanceaway.text = "\(sellerdistances[indexPath.row]) mi"
            }
            
            if availablitily.count > indexPath.row {
                
                cell.availability.text = "Available"
            }
       
            
        return cell

        }
        
        if tableView.tag == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActualProductDetails", for: indexPath) as! ActualProductDetailsTableViewCell
            
            if reviewtext.count > indexPath.row {
                
                cell.reviewdescription.text = reviewtext[indexPath.row]
            }
            
            if reviewnames.count > indexPath.row {
                
                cell.reviewername.text = "- \(reviewnames[indexPath.row])"
            }
            
            if reviewheadlines.count > indexPath.row {
                
                cell.reviewheadline.text = reviewheadlines[indexPath.row]
            }
            
          
            
            cell.selectionStyle = .none

            
            return cell
        }
        
        let cell = UITableViewCell()
        
        return cell

        
    }
    
    @IBOutlet weak var distanceawayy: UILabel!
    @IBOutlet weak var featurethree: UILabel!
    @IBOutlet weak var featuretwo: UILabel!
    internal func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {

            return nil
    }
    

    
    func getnearestsellers() {
        
        sellerprices.removeAll()
        selleraddresses.removeAll()
        sellernames.removeAll()
        sellerdistances.removeAll()
        
        let endpoint: String = "https://fb8505096e053937ef65abd75770d7ef.us-west-1.aws.found.io:9243/products/product/_search"
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let jsonObject: [String: Any] =  [ "size" : 50,
            "sort" : [
                       [ "store_price" : ["order" : "asc" ] ],
                       [ "_geo_distance" : [ "store_geoloc" : userlocation, "order" : "asc", "unit" : "mi"] ]
            ],
            "query": [
                "bool": [
                    "filter": [ [ "term": [ "product_name.raw": thisproducttitle] ] ,
                                [ "geo_distance": [ "distance": "15mi", "store_geoloc": userlocation] ]
                    ],
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
                        
                        //                                            print(index)
                        //                                            print(subJson["_source"]["product_name"].string!)
                        //                                            print(subJson["_source"]["product_img"].string!)
                        ////                                            print(subJson["_source"]["store_price"].string!)
                        //                                            print(subJson["_source"]["store_name"].string!)
                        //                                            print(subJson["_source"]["store_address"].string!)
        
                        
                        
                        var address = subJson["_source"]["store_address"].string

                        if self.selleraddresses.contains(address!) {
                            
                            
                        } else {
                            
                            self.selleraddresses.append(address!)

                            
                        if var storename = subJson["_source"]["store_name"].string{
                            
                            self.sellernames.append(storename)
                            
                        }
                            
                        
                        if var lowprice = subJson["_source"]["store_price"].float {
                            
                            var stringlowprice = String(format: "%.2f", lowprice)

                            self.sellerprices.append(stringlowprice)
                            
                            
                            
                            self.tableViewTwo.reloadData()
                            
                        }
                        
                    
                        if var distance = subJson["sort"][1].float {
                            
                            self.sellerdistances.append(String(format: "%.2f", distance))
                            
                        
                            
                            self.tableViewTwo.reloadData()
                            
                            
                        } else {
                            
                            if self.sellerdistances.count == 0 {
                            
                            self.distanceawayy.text = "No locations available"
                            self.distanceawayy.textColor = .gray
                                
                            }
                        }
                            
                        }
                        
                        self.tableView.reloadData()
                        self.tableViewTwo.reloadData()

                        
                            DispatchQueue.main.async {
                                
                                self.distanceawayy.text = "\(self.sellerdistances[0]) miles away"
                                self.price.text = "$\(self.sellerprices[0])"

                                self.tableView.reloadData()
                                self.tableViewTwo.reloadData()

                                
                            }
                        }
                        
                        self.tableView.reloadData()
                        self.tableViewTwo.reloadData()
                        
                        
                    }
                    
                    
                }
      
            catch {
                
                DispatchQueue.main.async {
                    
                    self.tableViewTwo.reloadData()
                    
                    
                }
            }
            
            
            
        }
        
        task.resume()
        
        
    }

    }


