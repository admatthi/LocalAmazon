//
//  AddProductToSellerAccountTableViewCell.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 6/9/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit

class AddProductToSellerAccountTableViewCell: UITableViewCell {

    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var title: UILabel!
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
