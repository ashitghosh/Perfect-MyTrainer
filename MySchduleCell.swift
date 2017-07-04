//
//  MySchduleCell.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 09/05/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit

class MySchduleCell: UITableViewCell {

    @IBOutlet var DayoffSwitch: UISwitch!
    @IBOutlet var View_btn: UIButton!
    @IBOutlet var schdule_type_lbl: UILabel!
    @IBOutlet var Schdule_image_lbl: UIImageView!
    @IBOutlet var time_lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
