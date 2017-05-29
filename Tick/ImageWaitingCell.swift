//
//  ImageWaitingCell.swift
//  Tick
//
//  Created by Nabeel Mamoon on 5/21/17.
//  Copyright © 2017 Nabeel Mamoon. All rights reserved.
//

import UIKit

class ImageWaitingCell: UITableViewCell {

    
    
    @IBOutlet weak var CommentsLabel: UILabel!
    
    @IBOutlet weak var VotesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CommentsLabel.layer.masksToBounds = true
        CommentsLabel.layer.cornerRadius = 15
        
        VotesLabel.layer.masksToBounds = true
        VotesLabel.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
