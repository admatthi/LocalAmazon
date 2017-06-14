//
//  AddProductToAccountViewController.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 6/9/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase


var sellerviewallproductids = [String]()
var sellerviewrelevantproductids = [String]()
var sellerviewproductimages = [UIImage]()
var sellerviewtitles = [String]()
var sellerviewprices = [String]()
var sellerviewbrands = [String]()
var sellerviewdistances = [String]()
var sellerviewquantities = [String]()
var sellerviewbizlongitudes = [String]()
var sellerviewbizlatitudes = [String]()
var sellerviewreviewss = [String]()
var sellerviewstorenames = [String]()
var sellerviewaddresses = [String]()
var sellerviewsellerids = [String]()
var sellerviewsearchstrings = [String]()

class AddProductToAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
        
    @IBOutlet weak var tableView: UITableView!

        
    var ref: FIRDatabaseReference?
    
    


    
    let lightgreen = UIColor(red:0.23, green:0.77, blue:0.58, alpha:1.0)
    
  
    
    
    
    
    
    func queryforproductids(completed: @escaping ( () -> () )) {
        
        sellerviewallproductids.removeAll()
        
        sellerviewrelevantproductids.removeAll()
        
        var functioncounter = 0
        
        self.ref?.child("Products").observeSingleEvent(of: .value, with: { (snapshot) in
            
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
    
    func queryforpopularids(completed: @escaping ( () -> () )) {
        
        sellerviewallproductids.removeAll()
        
        sellerviewrelevantproductids.removeAll()
        
        var functioncounter = 0
        
        self.ref?.child("Products").queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: { (snapshot) in
            
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
    
    var uploadedtitles: [String:String] = [:]
    
    var uploadedids = [String]()

    func queryforuploadedids(completed: @escaping ( () -> () ))  {
        
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
    
    var catalogtitles = [String:String]()
    
    func queryforcatalogtitles(completed: @escaping ( () -> () )) {
        
        var functioncounter = 0
        
        catalogtitles.removeAll()
        
        for each in sellerviewallproductids {
            
            self.ref?.child("Products").child("\(each)").observeSingleEvent(of: .value, with: { (snapshot) in
                
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
    

    
    var latitude = ""
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
                    
                    self.ref?.child("Products").child("\(id)").child("AllSellers").child(uid).updateChildValues(["Latitude" : latitude, "Longitude" : longitude, "Price" : uploadedprices[idd], "StoreAddress" : storeaddress, "StoreName" : storename])
                    
                    let trimmedlowestprice = lowestprice.trimmingCharacters(in: .whitespaces)
                    let trimmedpricee = pricee.trimmingCharacters(in: .whitespaces)

                    
                    if var intlowestprice = Double(trimmedlowestprice)  {
                        
                        if var intpricee = Double(trimmedpricee) {
                        
                        if intpricee < intlowestprice {
                            
                            self.ref?.child("Products").child("\(id)").updateChildValues(["CheapestLatitude" : latitude, "CheapestLongitude" : longitude, "LowestPrice" : uploadedprices[idd],  "Brand" : storename])
                            
                        } else {
                            
                            
                            }
                            
                        } else {
                            
                            self.ref?.child("Products").child("\(id)").updateChildValues(["CheapestLatitude" : latitude, "CheapestLongitude" : longitude, "LowestPrice" : catalogtitles[id],  "Brand" : storename])
                        }
                    
                        
                    } else {
                        
                        self.ref?.child("Products").child("\(id)").updateChildValues(["CheapestLatitude" : latitude, "CheapestLongitude" : longitude, "LowestPrice" : uploadedprices[idd],  "Brand" : storename])
                    }

                    
                } else {
                    
                    
                }
            }
        }
    }
    
    func updatecheapestprice() {
     
        
        
    }
    
    func queryforproductdata(completed: @escaping () -> () ){
        
        
        var functioncounter = 0
        
        sellerviewproductimages.removeAll()
        sellerviewtitles.removeAll()
        sellerviewprices.removeAll()
        sellerviewbrands.removeAll()
        sellerviewdistances.removeAll()
        sellerviewquantities.removeAll()
        sellerviewdistances.removeAll()
        sellerviewstorenames.removeAll()
        sellerviewaddresses.removeAll()
        sellerviewreviewss.removeAll()
        
        
        for each in sellerviewrelevantproductids {
            
            self.ref?.child("Products").child("\(each)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary
                
                
                if var productitle = value?["Title"] as? String {
                    
                    sellerviewtitles.append(productitle)
                    
                }
                
                if var reviewnumber = value?["Brand"] as? String {
                    
                    sellerviewbrands.append(reviewnumber)
                    
                }
                
                if var quantity = value?["Quantity"] as? String {
                    
                    sellerviewquantities.append(quantity)
                    
                }
                
                
                
                if var address = value?["AddressOfLowestPrice"] as? String {
                    
                    sellerviewaddresses.append(address)
                    
                }
                
                if var reviewnumber = value?["ReviewNumber"] as? String {
                    
                    sellerviewreviewss.append(reviewnumber)
                    
                } else {
                    
                    sellerviewreviewss.append("0")
                    
                }
                
                
                if var lowprice = value?["LowestPrice"] as? String {
                    
                    sellerviewprices.append(lowprice)
                    
                }
                
                if var productimagee = value?["Image"] as? String {
                    
                    if productimagee.hasPrefix("http://") || productimagee.hasPrefix("https://") {
                        
                        let dummy = UIImage()
                        
                        sellerviewproductimages.append(dummy)
                        
                        let insertionIndex = sellerviewproductimages.count - 1
                        
                        let url = URL(string: productimagee)
                        
                        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        
                        if data != nil {
                            
                            let productphoto = UIImage(data: (data)!)
                            
                            if sellerviewproductimages.count > insertionIndex {
                                
                                sellerviewproductimages[insertionIndex] = productphoto!
                                
                                self.tableView.reloadData()
                                
                            }
                            
                        }
                        
                        
                    } else {
                        
                        let test = UIImage()
                        
                        sellerviewproductimages.append(test)
                    }

                }
        
                
                self.tableView.reloadData()
                self.tableView.reloadData()
                
                functioncounter += 1
                
                if functioncounter == sellerviewrelevantproductids.count {
                    
                    completed()
                }
                
                
            })
            
            self.tableView.reloadData()
            
        }
        
        self.tableView.reloadData()
        
    }
    
    
    
    
    
    //
    
    
    override func viewDidLoad() {
        
        ref = FIRDatabase.database().reference()
        
        super.viewDidLoad()
 
        let user = FIRAuth.auth()?.currentUser
        
        let uid = user!.uid
 
        let lightbrown = UIColor(red:0.96, green:0.95, blue:0.93, alpha:1.0)
        
        searchBar.backgroundColor = lightgreen
        searchBar.barTintColor = lightgreen
        searchBar.searchBarStyle = .prominent
        
        tableView.reloadData()
        
        self.ref?.child("Sellers").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if var add = value?["Address"] as? String {
                
                self.storeaddress = add
            }
            
            if var name = value?["StoreName"] as? String {
                
                self.storename = name
            }
            
            if var lat = value?["Latitude"] as? String {
                
                self.latitude = lat
            }
            
            if var long = value?["Longitude"] as? String {
                
                self.longitude = long
            }
            
        })

        
        
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
        
        if sellerviewtitles.count > 0 {
            
            return sellerviewtitles.count

            
        }
            
            
            
        else {
        
            
            return 0
        }
        
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AvailableProductsCell", for: indexPath) as! AddProductToSellerAccountTableViewCell
        
        if sellerviewtitles.count > indexPath.row {
            
            cell.title.text = sellerviewtitles[indexPath.row]
            
        } else {
            
            cell.title.text = ""
        }
        
        if sellerviewproductimages.count > indexPath.row {
            
            cell.productimage.image = sellerviewproductimages[indexPath.row]
            
        } else {
            
            cell.productimage.image = nil
        }
   
        
        
        return cell
        
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        
    {
        
        thisproduct = indexPath.row
        
        self.performSegue(withIdentifier: "ProductsToPrice", sender: self)
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
        
        
        searchString = searchBar.text!
    
        queryforproductids {
            
            self.queryforuploadedids {
                
                self.queryforcatalogtitles {
                    
                    self.queryforuploadedtitles {
                        
                        self.queryformatchingtitlesandupdateprices()
                            
                        
                    }
                }
            }
        }
        
        self.tableView.reloadData()
        
        self.view.endEditing(true)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
}





