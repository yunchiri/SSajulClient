//
//  SSajulDatabase.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 5. 5..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import Foundation
import RealmSwift

class SSajulDatabase{
    static let sharedInstance = SSajulDatabase()
    
    func saveReadHistory(_ board : Board, item : Item) {
        
        
        let history = History()
        
        history.type = HistoryType.Read
        
        history.key = "(\(history.type) \(item.uid)"
        history.setBoard(board)
        history.setItem(item)
        
        history.updateAt = Date()
        
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(history, update: true)
        }
    }
    
    
    func saveFavoriteHistory(_ board : Board, item : Item) {
        
        
        let history = History()
        
        history.type = HistoryType.Favorite
        
        history.key = "(\(history.type) \(item.uid)"        
        history.setBoard(board)
        history.setItem(item)
        
        history.updateAt = Date()
        
        
        let realm = try! Realm()
        
        try! realm.write {
        realm.add(history, update: true)
        }
    }
    
    func saveWirteHistory(){
        
    }
    
    func saveCommentHistory(_ board : Board, item : Item) {
        
        
        let history = History()
        
        history.type = HistoryType.Comment
        
        history.key = "(\(history.type) \(item.uid)"
        history.setBoard(board)
        history.setItem(item)
        
        history.updateAt = Date()
        
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(history, update: true)
        }
        
    }
    
    
    
}
    
