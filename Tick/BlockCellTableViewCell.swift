//
//  BlockCellTableViewCell.swift
//  Tick
//
//  Created by Nabeel Mamoon on 6/3/17.
//  Copyright © 2017 Nabeel Mamoon. All rights reserved.
//

import UIKit

class BlockCellTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        name.layer.masksToBounds = true
        name.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
