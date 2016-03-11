//
//  ItemCell.swift
//  Ssajul
//
//  Created by 서 홍원 on 2016. 2. 26..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var createAt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setItem(item : Item) {
        
        self.content.text = item.title
        self.userName.text = item.userName
        self.createAt.text = item.createAt
    }

}
