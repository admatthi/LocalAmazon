//
//  ProductDetailsTableViewCell.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 5/30/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit

class ProductDetailsTableViewCell: UITableViewCell {
    
    @IBAction func tapAddToCart(_ sender: Any) {
    }

    @IBOutlet weak var distanceaway: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var reviewimage: UIImageView!
    @IBOutlet weak var servings: UILabel!
    @IBOutlet weak var productname: UILabel!
    @IBOutlet weak var productimage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
