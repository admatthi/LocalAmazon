//
//  ProductDetailsViewController.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 5/30/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit
import MapKit

class ProductDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
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
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        return 3
        
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActualProductDetails", for: indexPath) as! ActualProductDetailsTableViewCell
        
        return cell
        
    }

}
