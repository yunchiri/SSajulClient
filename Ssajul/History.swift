//
//  History.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 4. 23..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import Foundation
import RealmSwift


struct HistoryType {
    static let Read = "Read"
    static let Favorite = "Favorite"
    static let Comment = "Comment"
    static let Write = "Write"
}


class History : Object {
    dynamic var key = ""
    dynamic var type  = HistoryType.Read //SSajulClient.historyType = SSajulClient.historyType.watch
    
    //board
    dynamic var boardId = ""
    
    //item
    dynamic var uid = ""
    dynamic var userID : String = ""
    dynamic var userName : String = ""
    dynamic var userIP : String = ""
    dynamic var createAt : String = ""
    dynamic var voteUp : Int = 0
    dynamic var voteDown : Int = 0
    dynamic var readCount : Int = 0
    dynamic var title : String = ""
    dynamic var content : String = ""
    dynamic var commentCount : Int = 0
    
    
    dynamic var updateAt : NSDate? = nil
    
    
//    dynamic lazy var compoundKey : String = self.compoundKeyValue()
//    
//    func compoundKeyValue() -> String {
//        return "\(type)\(uid)"
//    }
    override static func primaryKey() -> String? {
        return "key"
    }
    
    func getItem() -> Item {
        var item = Item()
        item.uid = self.uid
        item.userID = self.userID
        item.userName = self.userName
        item.createAt = self.createAt
        item.voteUp  = self.voteUp
        item.voteDown = self.voteDown
        item.readCount = self.readCount
        item.title = self.title
        item.content = self.content
        item.commentCount = self.commentCount
    
        return item
    }
    
    func setItem(item : Item){
        self.uid = item.uid
        self.userID = item.userID
        self.userName = item.userName
        self.createAt = item.createAt
        self.voteUp  = item.voteUp
        self.voteDown = item.voteDown
        self.readCount = item.readCount
        self.title = item.title
        self.content = item.content
        self.commentCount = item.commentCount
    }
    
    func getBoard() -> Board {
        let board = Board(boardID: self.boardId)
        return board
        
    }
    
    func setBoard(board : Board){
        self.boardId = board.boardID
    }

}