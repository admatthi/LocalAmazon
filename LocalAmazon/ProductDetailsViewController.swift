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
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import Firebase

class ProductDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var openhours: UILabel!
    @IBOutlet weak var citystateziplabel: UILabel!
    @IBOutlet weak var featureslabel: UILabel!
    @IBOutlet weak var featurestext: UILabel!
    @IBOutlet weak var price: UILabel!

    @IBOutlet weak var about: UILabel!
    
    @IBOutlet weak var aboutthebrand: UILabel!
    
    
    @IBOutlet weak var descriptiontitle: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var reviewstwo: UILabel!
    
    @IBOutlet weak var reviewimagetwo: UIImageView!
    
    @IBOutlet weak var storeaddress: UILabel!
    @IBOutlet weak var storename: UILabel!
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
        
        storename.alpha = 0
        storeaddress.alpha = 0
        mapView.alpha = 0
        
    }
    
    func showlocation() {
        
        storename.alpha = 1
        storeaddress.alpha = 1
        mapView.alpha = 1
        
    }
    
    @IBOutlet weak var descriptionlabel: UILabel!
    func showdetails() {
        
        about.alpha = 1
        aboutthebrand.alpha = 1
        
        descriptiontitle.alpha = 1
        descriptionlabel.alpha = 1
        
    }
    
    func hidedetails() {
        
        about.alpha = 0
        aboutthebrand.alpha = 0
        
        descriptiontitle.alpha = 0
        descriptionlabel.alpha = 0
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hidedetails()
        hidelocation()
        showreviews()
        // Do any additional setup after loading the view.
        
        productname.text = titles[thisproduct]
        distanceaway.text = distances[thisproduct]


        if productimages.count > 0 {
            
            productimage.image = productimages[thisproduct]
            price.text = prices[thisproduct]
            brandname.text = brands[thisproduct]
            reviews.text = reviewss[thisproduct]
            productsize.text = quantities[thisproduct]
        }
      
        mapView.delegate = self

        var bizLocation = CLLocationCoordinate2DMake((Double(bizlatitudes[thisproduct])!) , Double(bizlongitudes[thisproduct])!)
        
        
        let region = MKCoordinateRegion(center: bizLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = bizLocation
        
        mapView.addAnnotation(annotation)
        
        mapView.setRegion(region, animated: true)
        
        ref = FIRDatabase.database().reference()

        
        queryforproductdata()
    }
    
    var ref: FIRDatabaseReference?

    
    func queryforproductdata() {
    
        var thisproductid = relevantproductids[thisproduct]
        
            self.ref?.child("Products").child("\(thisproductid)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary
                
                if var name = value?["StoreName"] as? String {
                    
                    self.storename.text = name
                    
                }
                
                if var address = value?["StoreAddress"] as? String {
                    
                    self.storeaddress.text = address
                   
                    
                }
                
                if var descriptionn = value?["Description"] as? String {
                    
                    self.descriptionlabel.text = descriptionn
                    
                }
                
                if var aboutbrand = value?["AboutBrand"] as? String {
                    
                    self.about.text = aboutbrand
                    
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
        
        return 1
        
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActualProductDetails", for: indexPath) as! ActualProductDetailsTableViewCell
        
        return cell
        
    }

}
