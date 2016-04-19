//
//  ItemCell.swift
//  Ssajul
//
//  Created by 서 홍원 on 2016. 2. 26..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
import QuartzCore

class ItemCell: UITableViewCell {

    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var createAt: UILabel!
    
    @IBOutlet weak var commentCount: UILabel!
    
    @IBOutlet weak var readCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        readCount.layer.backgroundColor  = UIColor.redColor().CGColor
        self.commentCount.layer.cornerRadius = 10
        self.commentCount.clipsToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setItem(item : Item) {
        
        self.content.text = item.title
        self.userName.text = item.userName
        self.createAt.text = item.createAt
        self.commentCount.text = String(item.commentCount)
        self.readCount.text = "조회 : " + String(item.readCount)
        
        
        if item.commentCount > 100 {
            self.commentCount.font = UIFont.boldSystemFontOfSize(11)
        }else{
            self.commentCount.font = UIFont.systemFontOfSize(11)
        }
        
    }
    


}
