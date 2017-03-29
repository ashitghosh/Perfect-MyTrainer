//
//  MyPostCell.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 24/03/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit

class MyPostCell: UITableViewCell {

    @IBOutlet var Date_lbl: UILabel!
    @IBOutlet var like_count_lbl: UILabel!
    @IBOutlet var Comment_count_lbl: UILabel!
    @IBOutlet var Delete_btn: UIButton!
    @IBOutlet var description_lbl: UILabel!
    @IBOutlet var title_lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
