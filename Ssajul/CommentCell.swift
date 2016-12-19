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
import QuartzCore
import SDWebImage

class CommentCell: UITableViewCell {

    @IBOutlet weak var content: ActiveLabel!
    @IBOutlet weak var userInfo: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPic: UIImageView!
    
    var _comment : Comment?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        content.handleURLTap { url in
            UIApplication.shared.openURL(url)
        }
        
        self.userPic.layer.cornerRadius = 15
        self.userPic.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        print("selecte")
        // Configure the view for the selected state
    }
    
    func setComment(_ comment : Comment) {
        self._comment = comment
        self.content.text = comment.content
        self.userInfo.text = "추천 : " + String(describing: comment.voteUp!) + " 비추 : " +   String(describing: comment.voteDown!) + " " +  comment.createAt!
        self.userName.text = comment.userName! + "(" + comment.userID! + ")"
        
        
        
        guard let userId = comment.userID else {
          return
        }
        
        self.userPic.sd_setImage(with: SSajulClient.sharedInstance.urlForUserPic(userId: userId) as URL  , placeholderImage: UIImage.init(named: "Person.png") )
        
        
        if comment.isBest == true {
            self.backgroundColor = FlatRed().withAlphaComponent(0.3)
            return
        }
        
        if (SSajulClient.sharedInstance.getLoginID() == userId) {
            self.backgroundColor =  UIColor.white
        }else if (SSajulClient.sharedInstance.selectedItem?.userID == comment.userID) {
            self.backgroundColor = FlatMint().withAlphaComponent(0.3)
    }else{
            self.backgroundColor =  UIColor.groupTableViewBackground
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
        
        return (_comment!.userName!) + "(" + (_comment?.userID)! + ")"
    }
    
    func openWebView(){
        print("open webview")
    }
    
}
