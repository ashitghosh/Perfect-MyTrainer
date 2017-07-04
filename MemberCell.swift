//
//  MemberCell.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 09/06/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {
    @IBOutlet var Profile_image: UIImageView!
    @IBOutlet var Name_lbl: UILabel!

    @IBOutlet var Booking_type_lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
