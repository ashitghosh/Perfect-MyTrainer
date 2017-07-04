//
//  SchedulelistCell.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 09/05/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit

class SchedulelistCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet var Invoice_date_lbl: UILabel!
    @IBOutlet var Message_lbl: UILabel!
    @IBOutlet var Message_imageview: UIImageView!
    @IBOutlet var Reschedule_image: UIImageView!
    @IBOutlet var Border_lbl: UILabel!
    @IBOutlet var Reschdule_lbl: UILabel!
    @IBOutlet var Schdule_back_Ground_lbl: UIView!
    @IBOutlet var Session_time_lbl: UILabel!
    @IBOutlet var confirm_lbl: UILabel!
    @IBOutlet var Profile_image: UIImageView!
    @IBOutlet var Confirm_btn: UIButton!
    @IBOutlet var message_btn: UIButton!
    @IBOutlet var Reschdule_btn: UIButton!
    @IBOutlet var Total_session_lbl: UILabel!
    @IBOutlet var Paid_lbl: UILabel!
    @IBOutlet var Session_date_time_lbl: UILabel!
    @IBOutlet var Session_type_lbl: UILabel!
    @IBOutlet var name_lbl: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
