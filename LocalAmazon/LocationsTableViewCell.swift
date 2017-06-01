//
//  LocationsTableViewCell.swift
//  LocalAmazon
//
//  Created by Alek Matthiessen on 6/1/17.
//  Copyright © 2017 AA Tech. All rights reserved.
//

import UIKit

class LocationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var availability: UILabel!
    @IBOutlet weak var distanceaway: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var address: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
