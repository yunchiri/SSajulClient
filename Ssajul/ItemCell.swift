//
//  ItemCell.swift
//  Ssajul
//
//  Created by 서 홍원 on 2016. 2. 26..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
import QuartzCore
import Colours
import RealmSwift
import ChameleonFramework


class ItemCell: UITableViewCell {

    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var createAt: UILabel!
    
    @IBOutlet weak var commentCount: UILabel!
    
    @IBOutlet weak var readCount: UILabel!
    
    @IBOutlet weak var voteUpAndDown: UILabel!
    
    
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
    
    func isRead(item : Item)-> Bool{
        
        let realm = try! Realm()
        let result = realm.objects(History).filter( "type == '" + HistoryType.Read + "' and uid == '" + item.uid + "' ")
        
        if result.count > 0 {
            return true
        }
        
        return false
        
        
        
    }
    
    
    func setItem(item : Item) {
        

        
        self.content.text = item.title
        self.userName.text = item.userName
        self.createAt.text = item.createAt
        self.commentCount.text = String(item.commentCount)
        self.readCount.text = "조회 : " + String(item.readCount)
        self.voteUpAndDown.text = "추천 : " + String(item.voteUp) + " / " + String(item.voteDown)
        

        
    }
    
    func setItemLayout(item: Item){
        if isRead(item) {
            self.content.textColor =  FlatWhiteDark()
        }else{
            self.content.textColor = UIColor.blackColor()
        }
        
        if item.commentCount > 10 {
            self.commentCount.font = UIFont.boldSystemFontOfSize(11)
            self.commentCount.backgroundColor = UIColor.init(red: 0.996, green: 0.812, blue: 0.196, alpha: 1)
        }else if item.commentCount > 0{
            self.commentCount.font = UIFont.systemFontOfSize(11)
            self.commentCount.backgroundColor = UIColor.init(red: 0.529, green: 0.737, blue: 0.149, alpha: 1)
        }else{
            self.commentCount.font = UIFont.systemFontOfSize(10)
            self.commentCount.backgroundColor = UIColor.clearColor()
        }
        
        if item.readCount > 150 {
            self.readCount.font = UIFont.boldSystemFontOfSize(11)
            self.readCount.backgroundColor = UIColor.yellowColor()
        }else{
            self.readCount.font = UIFont.systemFontOfSize(10)
            self.readCount.backgroundColor = UIColor.clearColor()
        }
        
        if item.voteUp > item.voteDown {
            self.voteUpAndDown.font = UIFont.boldSystemFontOfSize(11)
            self.voteUpAndDown.backgroundColor = UIColor.paleGreenColor()
        }else if item.voteUp < item.voteDown{
            self.voteUpAndDown.font = UIFont.systemFontOfSize(10)
            self.voteUpAndDown.backgroundColor = UIColor.paleRoseColor()// UIColor(red: 0.7098, green: 0.2706, blue: 0.2314, alpha: 0.5)
        }else{
            self.voteUpAndDown.font = UIFont.systemFontOfSize(10)
            self.voteUpAndDown.backgroundColor = UIColor.clearColor()
        }
    }
    


}
