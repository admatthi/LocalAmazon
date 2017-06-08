//
//  ActualProductDetailsTableViewCell.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 5/30/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit

class ActualProductDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewername: UILabel!
    @IBOutlet weak var reviewdescription: UILabel!
    @IBOutlet weak var reviewsimage: UIImageView!
    @IBOutlet weak var reviewheadline: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
