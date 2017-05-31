//
//  ViewController.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 5/30/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit

var searchString = String()


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var popularsearchterms = [String]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var currentlocation: UILabel!
    
    @IBAction func tapCart(_ sender: Any) {
    }
    @IBOutlet weak var tapcart: UIButton!
    @IBAction func tapShop(_ sender: Any) {
    }
    @IBOutlet weak var tapshop: UIButton!
    @IBAction func tapSearch(_ sender: Any) {
    }
    @IBOutlet weak var tapsearch: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return popularsearchterms.count
        
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopularSearches", for: indexPath) as! PopularSearchesTableViewCell
        
        if popularsearchterms.count > indexPath.row {
            
        cell.searchterm.text = popularsearchterms[indexPath.row]
            
        }
        
        return cell
        
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchString = popularsearchterms[indexPath.row]

        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "SearchToProducts",sender: self)
        }
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
        
        searchString = searchbar.text!

        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "SearchToProducts",sender: self)
        }
                
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    

}

