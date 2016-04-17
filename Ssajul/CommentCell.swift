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
    @IBOutlet weak var userName: UILabel!
    
    var _comment : Comment?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    
    func setComment(comment : Comment) {
        self._comment = comment
        self.content.text = comment.content
        self.userInfo.text = comment.createAt
        self.userName.text = comment.userName
        
        if SSajulClient.sharedInstance.getLoginID() == comment.userID {
            self.backgroundColor =  UIColor(red: 39.0, green: 44.0, blue: 79.0, alpha: 1.0)
        }
    }
    
    func getUserName() -> String {
        guard self._comment != nil else {
            return ""
        }
        
        guard self._comment?.userName != nil else {
            return ""
        }
        
        return _comment!.userName!
    }
    
}
