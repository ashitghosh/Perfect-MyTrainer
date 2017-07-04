//
//  FeedCellTwo.swift
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 12/04/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

import UIKit

class FeedCellTwo: UITableViewCell {
    
    
    @IBOutlet var Like_lbl: UILabel!
    @IBOutlet var Profile_link_btn: UIButton!

    @IBOutlet var like_btn: UIButton!
    @IBOutlet var Comments_btn: UIButton!
    @IBOutlet var comment_count_lbl: UILabel!
    @IBOutlet var like_count_lbl: UILabel!
    @IBOutlet var Feed_imageview: UIImageView!
    @IBOutlet var profle_image: UIImageView!
    @IBOutlet var Details_btn: UIButton!
    @IBOutlet var Description_lbl: UILabel!
    @IBOutlet var Date_lbl: UILabel!
    @IBOutlet var name_lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}