//
//  AddPriceToProductViewController.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 6/9/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import Firebase

class AddPriceToProductViewController: UIViewController {

    var latitude = ""
    var longitude = ""
    var price = ""
    var storeaddress = ""
    var storename = ""
    
    var ref: FIRDatabaseReference?
    
    var thisproductid = sellerviewrelevantproductids[thisproduct]
    
    @IBAction func tapSave(_ sender: Any) {
        
        let user = FIRAuth.auth()?.currentUser
        
        let uid = user!.uid
       
        price = pricetextfield.text!
        
        print("\(thisproductid) motherucker")
        
        self.ref?.child("Products").child("\(thisproductid)").child("AllSellers").child(uid).setValue(["Latitude" : latitude, "Longitude" : longitude, "Price" : price, "StoreAddress" : storeaddress, "StoreName" : storename])

    }
    
    @IBOutlet weak var pricetextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()


        // Do any additional setup after loading the view.
        
        let user = FIRAuth.auth()?.currentUser
        
        let uid = user!.uid
        
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

}
