//
//  WorkSchduleCell.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 07/04/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit

class WorkSchduleCell: UITableViewCell {
    @IBOutlet var Day_lbl: UILabel!

    @IBOutlet var DeleteBtn: UIButton!
    @IBOutlet var Startime_lbl: UILabel!
    @IBOutlet var Endtime_lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

