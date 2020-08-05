//
//  CustomCell.swift
//  Swift5ChatApp02
//
//  Created by 中塚富士雄 on 2020/08/05.
//  Copyright © 2020 中塚富士雄. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
