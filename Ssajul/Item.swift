//
//  Item.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 2. 23..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import Foundation

struct Item {
    var uid : String = ""
    var userID : String = ""
    var userName : String = ""
    var userIP : String = ""
    var createAt : String = ""
    var voteUp : Int = 0
    var voteDown : Int = 0
    var readCount : Int = 0
    var title : String = ""
    var content : String = ""
    var commentCount : Int = 0
    var comments = [Comment?]()
    
    var tbl_name : String = ""
    var comment_board_name : String = ""
//

//    
//    init(uid : String, userID : String, userName : String, userIP : String, createAt : String, voteUp : Int, voteDown : Int, title : String, content : String, commentCount : Int , readCount : Int , rawData : String){
//        self.uid = uid
//        self.userID = userID
//        self.userName = userName
//        self.userIP = userIP
//        self.createAt = createAt
//        self.voteUp = voteUp
//        self.voteDown = voteDown
//        self.title = title
//        self.content = content
//        
//        self.readCount = readCount
//        self.commentCount = commentCount
//        self.rawData = rawData
//        
//    }
//    
//    init( uid : String, userName : String,  createAt : String, voteUp : Int, voteDown : Int, title : String,  commentCount : Int ,readCount : Int ){
//        self.uid = uid
//        self.userID = ""
//        self.userName = userName
//        self.userIP = ""
//        
//        self.createAt = createAt
//        self.voteUp = voteUp
//        self.voteDown = voteDown
//        self.title = title
//        self.content = ""
//        
//        self.readCount = readCount
//        
//        self.commentCount = 0
//        self.rawData = ""
//        
//    }
//    
//    init(){
//        self.uid = ""
//        self.userID = ""
//        self.userName = ""
//        self.userIP = ""
//        
//        self.createAt = ""
//        self.voteUp = 0
//        self.voteDown = 0
//        self.title = ""
//        self.content = ""
//        
//        self.readCount = 0
//        self.commentCount = 0
//        
//        self.rawData = ""
//    }
    
    
    
}
