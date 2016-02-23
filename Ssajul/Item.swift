//
//  Item.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 2. 23..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import Foundation

class Item {
    var userID : String
    var userName : String
    var userIP : String
    var createAt : String
    var voteUp : Int
    var voteDown : Int
    var title : String
    var content : String
    var comments = [Comment]()
    
    var rawData : String
    
//    func HTML() -> String
    
    init(userID : String, userName : String, userIP : String, createAt : String, voteUp : Int, voteDown : Int, title : String, content : String, rawData : String){
        self.userID = userID
        self.userName = userName
        self.userIP = userIP
        self.createAt = createAt
        self.voteUp = voteUp
        self.voteDown = voteDown
        self.title = title
        self.content = content
        
        self.rawData = rawData
        
    }
    
//    init(rawData : String){
//        self.rawData = rawData
//        
//        //parsing
//    }
    
    
}
