//
//  ShopViewController.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 6/21/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit


class ShopViewController: UIViewController {
    
    var categories = [String]()


    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories.removeAll()
        
        categories.append("Clothing, Shoes, & Jewelry")
        categories.append("Home & Garden")
        categories.append("Sports & Outdoors")
        categories.append("Restaurants, Food, & Grocery")
        categories.append("Automotive, Tools, & Industrial")
        categories.append("Beauty & Health")
        categories.append("Toys, Kids, & Baby")
        
        
        

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
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCell", for: indexPath) as! ShopTableViewCell
            
     
        cell.categoryimage.image = UIImage(named: "\(categories[indexPath.row])")
        cell.CATEGORYLABEL.text = categories[indexPath.row]
        
        return cell
        
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        
    {
     
        
    }

}
