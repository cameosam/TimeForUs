//
//  LocationTimeCell.swift
//  TimeForUs
//
//  Created by Cameo Sameshima on 2023-02-23.
//

import UIKit

protocol CustomCellUpdater {
    func updateTableView(date: Date)
}

class LocationTimeCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!

    var updaterDelegate: CustomCellUpdater?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func DateTimeChanged(_ sender: Any) {
        self.updaterDelegate?.updateTableView(date: self.datePicker.date)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
