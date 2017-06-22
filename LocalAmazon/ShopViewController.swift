//
//  ShopViewController.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 6/21/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit


class ShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var categories = [String]()


    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        comingfromshop = false
        
        categories.removeAll()
        
        categories.append("Restaurants, Food, & Grocery")

        categories.append("Beauty & Health")

        categories.append("Clothing, Shoes, & Jewelry")
        categories.append("Home & Garden")
        categories.append("Sports & Outdoors")
        categories.append("Automotive, Tools, & Industrial")
        categories.append("Toys, Kids, & Baby")
        
        
        tableView.tableFooterView = UIView()


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
        
       
       return categories.count
        
        
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let lightgrey  = UIColor(red:0.91, green:0.91, blue:0.90, alpha:1.0)
        

        

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCell", for: indexPath) as! ShopTableViewCell
            
     
        cell.categoryimage.image = UIImage(named: "\(categories[indexPath.row])")
        cell.CATEGORYLABEL.text = categories[indexPath.row]
        
        if indexPath.row > 0 {
            
            cell.forwardbutton.alpha = 0
            
            cell.CATEGORYLABEL.textColor = .gray
        
            
            cell.selectionStyle = .none
            
            
        }
        
        return cell
        
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        
    {
     
        comingfromshop = true

        self.performSegue(withIdentifier: "ShopToSearch", sender: self)
        
        
    }
    
    internal func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        
        if indexPath.row > 0 {
            
            return nil

        } else {
            
            return indexPath
        }
        
    }
    
   


}
