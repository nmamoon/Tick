//
//  WaitingCell.swift
//  Tick
//
//  Created by Nabeel Mamoon on 5/20/17.
//  Copyright © 2017 Nabeel Mamoon. All rights reserved.
//

import UIKit

class WaitingCell: UITableViewCell {

    @IBOutlet weak var VotesLabel: UILabel!
    
    @IBOutlet weak var CommentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
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
