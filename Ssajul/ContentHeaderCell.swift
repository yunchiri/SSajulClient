//
//  ContentHeaderCell.swift
//  Ssajul
//
//  Created by 서 홍원 on 2016. 3. 8..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit

class ContentHeaderCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var usernm: UILabel!
    @IBOutlet weak var createAt: UILabel!
}
