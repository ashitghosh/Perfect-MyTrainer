//
//  RescheduleCell.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 31/05/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit

class RescheduleCell: UITableViewCell {

    @IBOutlet var Reschedule_btn: UIButton!
    @IBOutlet var Time_lbl: UILabel!
    @IBOutlet var Day_lbl: UILabel!
    @IBOutlet var Date_lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
