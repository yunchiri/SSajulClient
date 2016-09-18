//
//  commentCell.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 3. 14..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
import ActiveLabel
import ChameleonFramework

class CommentCell: UITableViewCell {

    @IBOutlet weak var content: ActiveLabel!
    @IBOutlet weak var userInfo: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    var _comment : Comment?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        content.handleURLTap { url in
            UIApplication.sharedApplication().openURL(url)
        }
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        print("selecte")
        // Configure the view for the selected state
    }
    
    func setComment(comment : Comment) {
        self._comment = comment
        self.content.text = comment.content
        self.userInfo.text = comment.createAt
        self.userName.text = comment.userName
        
        
        if (SSajulClient.sharedInstance.getLoginID() == comment.userID) {
            self.backgroundColor =  UIColor.whiteColor()
        }else if (SSajulClient.sharedInstance.selectedItem?.userName == comment.userName) {
            self.backgroundColor = FlatLime()
    }else{
            self.backgroundColor =  UIColor.groupTableViewBackgroundColor()
        }
    }
    
    func getUserName() -> String {
        guard self._comment != nil else {
            return ""
        }
        
        guard self._comment?.userName != nil else {
            return ""
        }
        guard self._comment?.userID != nil else{
            return ""
        }
        
        return (_comment?.userID)! + "(" + _comment!.userName! + ")"
    }
    
    func openWebView(){
        print("open webview")
    }
    
}
