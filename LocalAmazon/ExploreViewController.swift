//
//  ExploreViewController.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 6/21/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

var toporganicproducts = [String]()
var toporganicimages = [UIImage]()
var toporganicdistances = [String]()
var toporganicids = [String]() 

var tophealthproducts = [String]()
var tophealthimages = [UIImage]()
var tophealthdistances = [String]()
var tophealthids = [String]()

var toptoolsproducts = [String]()
var toptoolsimages = [UIImage]()
var toptoolsdistances = [String]()
var toptoolsid = [String]()

var productselected = String()
var imageselected = UIImage()
var idselected = String()

var shoptodetails = Bool()

class ExploreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    func calculatemaxuserlongandlat(completed: @escaping ( () -> () ))  {
        
        let manager = CLLocationManager()
        
        if let location = manager.location?.coordinate {
            
            var cluserLocation = CLLocation(latitude: (location.latitude), longitude: (location.longitude))
            
            userlong = location.longitude
            userlat = location.latitude
            
            userlocation = "\(String(userlat)), \(String(userlong))"
            
            completed()
        }
    }
    
    func toporganicquery() {
        
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
                                                "must": [ "match": [ "product_name": "Organic" ], ],
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
                        
                        if toporganicproducts.contains(producttitle) {
                            
                            
                        } else {
                            
                            toporganicproducts.append(producttitle)
                            
                 
                            
                            if var distance = subJson["sort"][2].float {
                                
                                toporganicdistances.append((String(format: "%.2f", distance)))
                                
                                
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
                                        
                                        toporganicimages.append(productphoto!)
                                        
//                                        self.collectionViewOne.reloadData()
                                        
                                        
                                        //                                    }
                                        
                                    }
                                    
                                    
                                } else {
                                    
                                    let test = UIImage(named: "LoadingImage")
                                    
                                    toporganicimages.append(test!)
                                }
                                
                                
                                
                                
                            }
                            
                            
                            
                            if var productid = subJson["_source"]["product_id"].string {
                                
                                toporganicids.append(productid)
                                
                            }
                            

                            
                            
                            DispatchQueue.main.async {
                                
                                self.collectionViewOne.reloadData()
                                
                             
                                
                            }
                        }
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                }
                
                
                
                
            } catch {
                
                DispatchQueue.main.async {
                    
//                    self.collectionViewOne.reloadData()
                    
                    
                }
                
                
            }
            
            
            
            
        }
        
        task.resume()

    }

    @IBOutlet weak var collectionViewOne: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoptodetails = false 

        // Do any additional setup after loading the view.
        calculatemaxuserlongandlat {
        
            self.toporganicquery()
            self.toptoolquery()
            self.tophealthquery()
            
//            self.collectionViewThree.reloadData()
//            self.collectionView.reloadData()
//            self.collectionViewTwo.reloadData()
//            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private struct Storyboard {
        
        static let CellIdentifier = "TopFoodCell"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBOutlet weak var collectionViewThree: UICollectionView!
    @IBOutlet weak var collectionViewTwo: UICollectionView!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1 {
            
            return toporganicproducts.count

        }
        
        if collectionView.tag == 2 {
            
            return tophealthproducts.count

        }
        
        
        if collectionView.tag == 3 {
            
            return toptoolsproducts.count

            
        } else {
            
            return 1

        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView.tag == 1 {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopFoodCell", for: indexPath) as! TopFoodCollectionViewCell

        
        if toporganicimages.count > indexPath.row {
            
            cell.productimage.image = toporganicimages[indexPath.row]

        }
        
        if toporganicproducts.count > indexPath.row {
            
            cell.productname.text = toporganicproducts[indexPath.row]

        }
        
        if toporganicdistances.count + 1 > indexPath.row {

            cell.productdistance.text = "\(toporganicdistances[indexPath.row]) mi"

        }
        
        
        return cell
            
        }
        
        if collectionView.tag == 2 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopHealthCell", for: indexPath) as! TopHealth_BeautyCollectionViewCell

            
            if tophealthimages.count > indexPath.row {
                
                cell.productimage.image = tophealthimages[indexPath.row]
                
            }
            
            if tophealthproducts.count > indexPath.row {
                
                cell.productname.text = tophealthproducts[indexPath.row]
                
            }
            
            if tophealthdistances.count > indexPath.row {
                
                cell.productdistance.text = "\(tophealthdistances[indexPath.row]) mi"
                
            }
            
            
            return cell
        }
        
        if collectionView.tag == 3 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopToolCell", for: indexPath) as! TopToolsCollectionViewCell

            
            if toptoolsimages.count > indexPath.row {
                
                cell.productimage.image = toptoolsimages[indexPath.row]
                
            }
            
            if toptoolsproducts.count > indexPath.row {
                
                cell.productname.text = toptoolsproducts[indexPath.row]
                
            }
            
            if toptoolsdistances.count > indexPath.row {
                
                cell.productdistance.text = "\(toptoolsdistances[indexPath.row]) mi"
                
            }
            
            
            return cell
            
        } else {
        
        let cell = UICollectionViewCell()
        
        return cell
            
        }
        
    }
    
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            if collectionView.tag == 1 {
                
                if let cell = collectionView.cellForItem(at: indexPath as IndexPath) {

                
                productselected = toporganicproducts[indexPath.row]
                imageselected = toporganicimages[indexPath.row]
                idselected = toporganicids[indexPath.row]
                    
                    shoptodetails = true
                    
                    self.performSegue(withIdentifier: "ExploreToDetails", sender: self)
                    
                }
                
            }
            
            if collectionView.tag == 2 {
                
                if let cell = collectionViewTwo.cellForItem(at: indexPath as IndexPath) {

                
                productselected = tophealthproducts[indexPath.row]
                imageselected = tophealthimages[indexPath.row]
                idselected = tophealthids[indexPath.row]
                    
                    shoptodetails = true
                    
                    self.performSegue(withIdentifier: "ExploreToDetails", sender: self)
                    
                }
                
            }
            
            if collectionView.tag == 3 {
                
                if let cell = collectionViewThree.cellForItem(at: indexPath as IndexPath) {

                
                productselected = toptoolsproducts[indexPath.row]
                imageselected = toptoolsimages[indexPath.row]
                idselected = toptoolsid[indexPath.row]
                    
                    shoptodetails = true
                    
                    self.performSegue(withIdentifier: "ExploreToDetails", sender: self)
                    
                }
                
            }
            
            
       
        }
        
    
    
    func tophealthquery() {
        
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
                                                "must": [ "match": [ "product_name": "Cleanser" ], ],
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
                        
                        if tophealthproducts.contains(producttitle) {
                            
                            
                        } else {
                            
                            tophealthproducts.append(producttitle)
                            
                            
                            
                            if var distance = subJson["sort"][2].float {
                                
                                tophealthdistances.append((String(format: "%.2f", distance)))
                                
                                
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
                                        
                                        tophealthimages.append(productphoto!)
                                                                                
                                        
                                        //                                    }
                                        
                                    }
                                    
                                    
                                } else {
                                    
                                    let test = UIImage(named: "LoadingImage")
                                    
                                    tophealthimages.append(test!)
                                }
                                
                                
                                
                                
                            }
                            
                            
                            
                            if var productid = subJson["_source"]["product_id"].string {
                                
                                tophealthids.append(productid)
                                
                            }
                            
                            
                            
                            
                            DispatchQueue.main.async {
                                
                                self.collectionViewTwo.reloadData()
                                
                                
                                
                            }
                        }
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                }
                
                
                
                
            } catch {
                
                DispatchQueue.main.async {
                    
                    self.collectionViewTwo.reloadData()
                    
                    
                }
                
                
            }
            
            
            
            
        }
        
        task.resume()
        
    }
    
    func toptoolquery() {
        
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
                                                "must": [ "match": [ "product_name": "Oil" ], ],
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
                        
                        if toptoolsproducts.contains(producttitle) {
                            
                            
                        } else {
                            
                            toptoolsproducts.append(producttitle)
                            
                            
                            
                            if var distance = subJson["sort"][2].float {
                                
                                toptoolsdistances.append((String(format: "%.2f", distance)))
                                
                                
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
                                        
                                        toptoolsimages.append(productphoto!)
                                        
//                                        self.collectionViewThree.reloadData()
                                        
                                        
                                        //                                    }
                                        
                                    }
                                    
                                    
                                } else {
                                    
                                    let test = UIImage(named: "LoadingImage")
                                    
                                    toptoolsimages.append(test!)
                                }
                                
                                
                                
                                
                            }
                            
                            
                            
                            if var productid = subJson["_source"]["product_id"].string {
                                
                                toptoolsid.append(productid)
                                
                            }
                            
                            
                            
                            
                            DispatchQueue.main.async {
                                
                                self.collectionViewThree.reloadData()
                                
                                
                                
                            }
                        }
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                }
                
                
                
                
            } catch {
                
                DispatchQueue.main.async {
                    
//                    self.collectionViewThree.reloadData()
                    
                    
                }
                
                
            }
            
            
            
            
        }
        
        task.resume()
        
    }

}



