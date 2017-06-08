//
//  CreateProductViewController.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 6/5/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class CreateProductViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref: FIRDatabaseReference?

    @IBOutlet weak var pickerView: UIPickerView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    @IBOutlet weak var titleinput: UITextField!

    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var aboutbrand: UITextField!
    @IBOutlet weak var descriptioninput: UITextField!
    @IBAction func tapSave(_ sender: Any) {
        
        imagelabel = image.text!
        feature3label = feature3.text!
        feature2label = feature2.text!
        feature1label = feature1.text!
        quatnitylabel = quantity.text!
        brandlabel = brand.text!
        titlelabel = titleinput.text!
        descriptionlabel = descriptioninput.text!
        aboutbrandlabel = aboutbrand.text!
        
        
        self.ref?.child("Products").childByAutoId().setValue(["Image" : imagelabel, "ReviewsNumber" : "0", "CheapestLongitude" : "", "CheapestLatitude" : "", "Feature1" : feature1label, "Feature2" : feature2label, "Feature3" : feature3label, "LowestPrice" : lowestpricelabel, "Quantity" : quatnitylabel, "Brand" : brandlabel, "Title" : titlelabel, "Description" : descriptionlabel, "AboutBrand" : aboutbrandlabel])
        
    
        
        
    }
    
    @IBOutlet weak var image: UITextField!
    @IBOutlet weak var reviewsnumber: UITextField!
    @IBOutlet weak var cheapestlongitude: UITextField!
    @IBOutlet weak var cheapestlatitude: UITextField!
    @IBOutlet weak var feature3: UITextField!
    @IBOutlet weak var feature2: UITextField!
    @IBOutlet weak var feature1: UITextField!
    @IBOutlet weak var lowestprice: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var brand: UITextField!
 
    
    var imagelabel = ""
    var reviewsnumberlabel = ""
    var cheapestlongitudelabel = ""
    var cheapestlatitudelabel = ""
    var feature3label = ""
    var feature2label = ""
    var feature1label = ""
    var lowestpricelabel = ""
    var quatnitylabel = ""
    var brandlabel = ""
    var descriptionlabel = ""
    var titlelabel = ""
    var aboutbrandlabel = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories.removeAll()
        
        categories.append("Snacks")
        categories.append("Candies, Desserts, & Toppings")
        categories.append("Ghee, Oils & Vinegars")
        categories.append("Baking")
        categories.append("Bars, Cereals, & Granolas")
        categories.append("Coffee & Tea")
        categories.append("Honey & Sweeteners")
        categories.append("Nuts, Seeds & Trail Mixes")
        categories.append("Nut Butters & Fruit Spreads")
        categories.append("Beverages & Drink Mixes")
        categories.append("Packaged Fruits & Vegetables")
        categories.append("Spices, Seasoning & Salt")
        categories.append("Superfoods")
        categories.append("Protein")
        categories.append("Muscle Maintenaince")
        categories.append("Energy Drink Mix & Shots")
        categories.append("Detox & Digestion")
        
        
        ref = FIRDatabase.database().reference()
        
        let storage = FIRStorage.storage()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var categories = [String]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if categories.count > 0 {
            
            return categories.count
            
        } else {
            
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if categories.count > 0 {
            
            return categories[row]
            
        } else {
            
            return "Hello"
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
            self.category.text = self.categories[row]
            
            self.view.endEditing(true)
            
            self.pickerView.alpha = 0
            
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.view.endEditing(true)
        
        
        if textField == self.category
            
        {
            self.pickerView.alpha = 1
            
            self.pickerView.reloadAllComponents()
            
            textField.endEditing(true)
            
            
            
        }
        
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
