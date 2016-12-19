//
//  Comment.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 2. 23..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import Foundation


struct Comment{
    var commentId : String?
    var userID : String?
    var userName : String?
    var userIP : String?
    var createAt : String?
    var voteUp : Int?
    var voteDown : Int?
    var content : String
    
    var rawData : String?
    
    var userInfo : String?
    var isBest : Bool
    //func HTML() : String

    
    init(userID : String, userName : String, userIP : String, createAt : String, voteUp : Int, voteDown : Int, content : String, rawData : String, commentId : String, isBest : Bool){
        self.userID = userID
        self.userName = userName
        self.userIP = userIP
        self.createAt = createAt
        self.voteUp = voteUp
        self.voteDown = voteDown
        self.content = content
        self.commentId = commentId
        self.isBest = isBest
        self.rawData = rawData
    }
    
    
//    init(rawData : String){
//        self.rawData = rawData
//    }
    
    
    init(){
        self.userID = ""
        self.userName = ""
        self.userIP = ""
        
        self.createAt = ""
        self.voteUp = 0
        self.voteDown = 0
        self.content = ""
        
        self.rawData = ""
        self.commentId = ""
        self.isBest = false
    }
    
}
