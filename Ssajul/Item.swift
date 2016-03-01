//
//  Item.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 2. 23..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import Foundation

class Item {
    var uid : String
    var userID : String
    var userName : String
    var userIP : String
    var createAt : String
    var voteUp : Int?
    var voteDown : Int?
    var readCount : Int?
    var title : String
    var content : String
    var commentCount : Int
    var comments = [Comment?]()
    
    var rawData : String
    
    //    func HTML() -> String
    
    init(uid : String, userID : String, userName : String, userIP : String, createAt : String, voteUp : Int, voteDown : Int, title : String, content : String, commentCount : Int , readCount : Int , rawData : String){
        self.uid = uid
        self.userID = userID
        self.userName = userName
        self.userIP = userIP
        self.createAt = createAt
        self.voteUp = voteUp
        self.voteDown = voteDown
        self.title = title
        self.content = content
        
        self.readCount = readCount
        self.commentCount = commentCount
        self.rawData = rawData
        
    }
    
    init( uid : String, userName : String,  createAt : String, voteUp : Int, voteDown : Int, title : String,  commentCount : Int ,readCount : Int ){
        self.uid = uid
        self.userID = ""
        self.userName = userName
        self.userIP = ""
        
        self.createAt = createAt
        self.voteUp = voteUp
        self.voteDown = voteDown
        self.title = title
        self.content = ""
        
        self.readCount = readCount
        
        self.commentCount = 0
        self.rawData = ""
        
    }
    
    init(){
        self.uid = ""
        self.userID = ""
        self.userName = ""
        self.userIP = ""
        
        self.createAt = ""
        self.voteUp = 0
        self.voteDown = 0
        self.title = ""
        self.content = ""
        
        self.readCount = 0
        self.commentCount = 0
        
        self.rawData = ""
    }
    
    
    
}
