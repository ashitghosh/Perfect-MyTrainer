//
//  DiscountCell.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 26/04/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit

class DiscountCell: UITableViewCell {
    
    @IBOutlet var Session_Delete_btn: UIButton!
    
    @IBOutlet var Session_edit_btn: UIButton!

    @IBOutlet var Session_select_btn: UIButton!
    @IBOutlet var Session_select_imageview: UIImageView!
    @IBOutlet var Seassion_status_lbl: UILabel!
    @IBOutlet var session_price: UILabel!
    @IBOutlet var Session_count: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
