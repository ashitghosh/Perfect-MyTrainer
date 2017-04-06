//
//  CommentCell.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 17/02/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet var Delete_btn: UIButton!
    @IBOutlet var Profile_image: UIImageView!
    @IBOutlet var time_lbl: UILabel!
    @IBOutlet var message_lbl: UILabel!
    @IBOutlet var Name_lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
