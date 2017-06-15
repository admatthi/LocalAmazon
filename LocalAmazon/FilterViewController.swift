//
//  FilterViewController.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 6/2/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit

var filtervariable = ""

class FilterViewController: UIViewController {
    
    var distance = true
    var price = true

    @IBAction func tapDistance(_ sender: Any) {
        
        if distance {
            
            distance = false
            
            price = true
            
            tapdistance.setImage(UIImage(named: "Checked"), for: .normal)
            
            tapprice.setImage(UIImage(named: "Unchecked"), for: .normal)
            
            UserDefaults.standard.set(true, forKey: "Distance")
            
            UserDefaults.standard.set(false, forKey: "Price")

            
            filtervariable = "Distance"
            
            
        } else {
            
            distance = true
            
            price = false
            
            tapdistance.setImage(UIImage(named: "Unchecked"), for: .normal)
            
            tapprice.setImage(UIImage(named: "Checked"), for: .normal)
            
            UserDefaults.standard.set(false, forKey: "Distance")
            
            UserDefaults.standard.set(true, forKey: "Price")
            
            filtervariable = "Price"
            
        }
        

    }
    @IBAction func tapApply(_ sender: Any) {
    }
    @IBOutlet weak var tapdistance: UIButton!
    @IBAction func tapPrice(_ sender: Any) {
        
        if price {
            
            price = false
            
            distance = true
            
            tapdistance.setImage(UIImage(named: "Unchecked"), for: .normal)
            
            tapprice.setImage(UIImage(named: "Checked"), for: .normal)
            
            UserDefaults.standard.set(false, forKey: "Distance")
            
            UserDefaults.standard.set(true, forKey: "Price")
            
            filtervariable = "Price"
          
        } else {
            
            
            price = true
            
            distance = false

            tapdistance.setImage(UIImage(named: "Checked"), for: .normal)
            
            tapprice.setImage(UIImage(named: "Unchecked"), for: .normal)
            
            UserDefaults.standard.set(true, forKey: "Distance")
            
            UserDefaults.standard.set(false, forKey: "Price")
            
            filtervariable = "Distance"

        }
    }
    @IBOutlet weak var tapprice: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if firstlaunch == true {
            
            price = false
            
            tapprice.setImage(UIImage(named: "Checked"), for: .normal)
            
            filtervariable = "Price"
            
            UserDefaults.standard.set(true, forKey: "Price")

            
        } else {
            
            restoresavedvalues()
        }
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
    
    func restoresavedvalues() {
        
        if let previous = UserDefaults.standard.object(forKey: "Distance") as? Bool {
            
            if previous {
                
                distance = false
                
                tapdistance.setImage(UIImage(named: "Checked"), for: .normal)
                
                filtervariable = "Distance"
                
            }
            
        }
        
        if let previouss = UserDefaults.standard.object(forKey: "Price") as? Bool {
            
            if previouss {
                
                price = false
                
                tapprice.setImage(UIImage(named: "Checked"), for: .normal)
                
                filtervariable = "Price"
                
            }
            
        }
    }

}
