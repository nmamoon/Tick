//
//  WinningCell.swift
//  Tick
//
//  Created by Nabeel Mamoon on 5/20/17.
//  Copyright © 2017 Nabeel Mamoon. All rights reserved.
//

import UIKit

class WinningCell: UITableViewCell {

   
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var CommentLabel: UILabel!
    @IBOutlet weak var VotesLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        NameLabel.layer.masksToBounds = true
        NameLabel.layer.cornerRadius = 15
        
        ProfilePic.layer.masksToBounds = true
        ProfilePic.layer.cornerRadius = 15
        
        CommentLabel.layer.masksToBounds = true
        CommentLabel.layer.cornerRadius = 15
        
        VotesLabel.layer.masksToBounds = true
        VotesLabel.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
