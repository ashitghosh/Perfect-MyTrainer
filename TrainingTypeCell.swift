//
//  TrainingTypeCell.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 16/02/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit

class TrainingTypeCell: UITableViewCell {

    @IBOutlet var Tagline_text: UILabel!
    @IBOutlet var Name_lbl: UILabel!
    @IBOutlet var Profile_imageview: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
