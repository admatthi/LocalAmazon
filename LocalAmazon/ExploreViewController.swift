//
//  ExploreViewController.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 6/21/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var topfoodproducts = [String]()
    var topfoodimages = [String]()
    var topfooddistances = [String]()

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}

extension ExploreViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        topfoodproducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopFoodCell", for: indexPath) as! TopFoodCollectionViewCell
        
        cell.productimage.image = topfoodimages[indexPath.row]
        
        cell.productname.text = topfoodproducts[indexPath.row]
        
        cell.productdistances.text = topfooddistances[indexPath.row]
        
        return cell 
    }
}
