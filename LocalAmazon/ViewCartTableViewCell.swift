//
//  ViewCartTableViewCell.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 5/30/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit

class ViewCartTableViewCell: UITableViewCell {

    @IBAction func tapMore(_ sender: Any) {
    }
    @IBOutlet weak var tapmore: UIButton!
    @IBAction func tapLess(_ sender: Any) {
    }
    @IBOutlet weak var tapless: UIButton!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var productprice: UILabel!
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
