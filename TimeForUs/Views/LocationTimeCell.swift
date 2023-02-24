//
//  LocationTimeCell.swift
//  TimeForUs
//
//  Created by Cameo Sameshima on 2023-02-23.
//

import UIKit
import SwipeCellKit

class LocationTimeCell: SwipeTableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
