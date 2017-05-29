//
//  BasicPostCell.swift
//  Tick
//
//  Created by Nabeel Mamoon on 5/12/17.
//  Copyright © 2017 Nabeel Mamoon. All rights reserved.
//

import UIKit

class BasicPostCell: UITableViewCell {
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var Pic: UIImageView!
    @IBOutlet weak var Content: UILabel!
    @IBOutlet weak var UpvoteLabel: UILabel!
    
    @IBOutlet weak var TimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        NameLabel.layer.masksToBounds = true
        NameLabel.layer.cornerRadius = 15
        Content.layer.masksToBounds = true
        Content.layer.cornerRadius = 15
        Pic.layer.masksToBounds = true
        Pic.layer.cornerRadius = 15
        UpvoteLabel.layer.masksToBounds = true
        UpvoteLabel.layer.cornerRadius = 15
        TimeLabel.layer.masksToBounds = true
        TimeLabel.layer.cornerRadius = 15
         TimeLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
