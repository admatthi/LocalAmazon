//
//  ShopTableViewCell.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 6/21/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryimage: UIImageView!
    @IBOutlet weak var CATEGORYLABEL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
