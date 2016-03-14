//
//  commentCell.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 3. 14..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var userInfo: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setComment(comment : Comment) {
        
        self.content.text = comment.content
        self.userInfo.text = comment.userInfo
    }
    
}
