//
//  MyPurchasesTableViewCell.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 5/30/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit

class MyPurchasesTableViewCell: UITableViewCell {

    @IBAction func tapTrackOrder(_ sender: Any) {
    }
    @IBOutlet weak var productprice: UILabel!
    @IBOutlet weak var datepurchased: UILabel!
    @IBOutlet weak var orderstatus: UILabel!
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
