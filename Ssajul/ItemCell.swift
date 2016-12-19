//
//  ItemCell.swift
//  Ssajul
//
//  Created by 서 홍원 on 2016. 2. 26..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
import QuartzCore

import RealmSwift
import ChameleonFramework
import SDWebImage


class ItemCell: UITableViewCell {

    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var createAt: UILabel!
    
    @IBOutlet weak var commentCount: UILabel!
    
    @IBOutlet weak var readCount: UILabel!
    
    @IBOutlet weak var voteUpAndDown: UILabel!
    
    @IBOutlet weak var userPic: UIImageView!
    
    var item : Item?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        readCount.layer.backgroundColor  = UIColor.redColor().CGColor
        self.commentCount.layer.cornerRadius = 10
        self.commentCount.clipsToBounds = true
        
        self.userPic.layer.cornerRadius = 15
        self.userPic.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func isRead(_ item : Item)-> Bool{
        
        let realm = try! Realm()
        let result = realm.objects(History.self).filter( "type == '" + HistoryType.Read + "' and uid == '" + item.uid + "' ")
        
        if result.count > 0 {
            return true
        }
        
        return false
        
    }
    
    func getItem() -> Item{
        
        guard let commentItem = self.item else {
            return Item()
        }
        return commentItem
    }
    
    func setItem(_ item : Item) {
        
        if item.userID.isEmpty == true {
            guard let userMappingID = SSajulDatabase.sharedInstance.getUerID(unm: item.userName) else {
                self.item = item
                mapping(item: item)
                return
            }
            
            var newItem = Item()
            newItem = item
            newItem.userID = userMappingID
            
            self.item = newItem
            
        }else {
            self.item = item
        }
        
        mapping(item: item)

        

    }
    
    func mapping(item : Item){
        self.content.text = item.title
        self.userName.text = item.userName
        self.createAt.text = item.createAt
        self.commentCount.text = String(item.commentCount)
        self.readCount.text = "조회 : " + String(item.readCount)
        self.voteUpAndDown.text = "추천 : " + String(item.voteUp) + " / " + String(item.voteDown)
        
        guard let userId = self.item?.userID else {
            return
        }

        
        self.userPic.sd_setImage(with: SSajulClient.sharedInstance.urlForUserPic(userId: userId) as URL  , placeholderImage: UIImage.init(named: "Person.png") )
    }
    
    func setItemLayout(_ item: Item){
        if isRead(item) {
            self.content.textColor =  FlatWhiteDark()
        }else{
            self.content.textColor = UIColor.black
        }
        
        
        
        if item.commentCount > 10 {
            self.commentCount.font = UIFont.boldSystemFont(ofSize: 12)
            self.commentCount.backgroundColor = FlatYellowDark()// UIColor.init(red: 0.996, green: 0.812, blue: 0.196, alpha: 1)
        }else if item.commentCount > 0{
            self.commentCount.font = UIFont.systemFont(ofSize: 11)
            self.commentCount.backgroundColor = UIColor.init(red: 0.11, green: 0.6, blue: 0.39, alpha: 1)
        }else{
            self.commentCount.font = UIFont.systemFont(ofSize: 10)
            self.commentCount.backgroundColor = UIColor.clear
        }
        
        if item.readCount > 150 {
            self.readCount.font = UIFont.boldSystemFont(ofSize: 11)
            self.readCount.backgroundColor = UIColor.yellow
        }else{
            self.readCount.font = UIFont.systemFont(ofSize: 10)
            self.readCount.backgroundColor = UIColor.clear
        }
        
        if item.voteUp > item.voteDown {
            self.voteUpAndDown.font = UIFont.boldSystemFont(ofSize: 11)
            self.voteUpAndDown.backgroundColor = FlatLime().withAlphaComponent(0.5)
        }else if item.voteUp < item.voteDown{
            self.voteUpAndDown.font = UIFont.systemFont(ofSize: 10)
            self.voteUpAndDown.backgroundColor = FlatPink().withAlphaComponent(0.5)// UIColor(red: 0.7098, green: 0.2706, blue: 0.2314, alpha: 0.5)
        }else{
            self.voteUpAndDown.font = UIFont.systemFont(ofSize: 10)
            self.voteUpAndDown.backgroundColor = UIColor.clear
        }
    }
    


}
