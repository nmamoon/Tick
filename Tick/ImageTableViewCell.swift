//
//  ImageTableViewCell.swift
//  Tick
//
//  Created by Nabeel Mamoon on 5/13/17.
//  Copyright © 2017 Nabeel Mamoon. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var ProfilePic: UIImageView!

    @IBOutlet weak var ConPic: UIImageView!
    @IBOutlet weak var Content: UILabel!
    @IBOutlet weak var UpvoteLabel: UILabel!
    
    @IBOutlet weak var TimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        NameLabel.layer.masksToBounds = true
        ProfilePic.layer.masksToBounds = true
        Content.layer.masksToBounds = true
        ConPic.layer.masksToBounds = true
        NameLabel.layer.cornerRadius = 15
        ProfilePic.layer.cornerRadius = 15
        Content.layer.cornerRadius = 15
        ConPic.layer.cornerRadius = 15
        UpvoteLabel.layer.masksToBounds = true
        UpvoteLabel.layer.cornerRadius = 15
        TimeLabel.layer.masksToBounds = true
        TimeLabel.layer.cornerRadius = 15
        TimeLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
