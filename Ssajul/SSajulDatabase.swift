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
        
        saveUserMap(item: item)
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
    
    func getUerID(unm : String)->String?{
        let realm = try! Realm()
        
        if unm.isEmpty == true {
            return nil
        }
        
        guard let userMappingID = realm.objects(UserMap.self).filter( "unm == '" + unm + "'" ).first?.uid else {
            return nil
        }
        
        if userMappingID.isEmpty == true {
            return nil
        }
        return userMappingID
    }
    
    func saveUserMap(item : Item)
    {
        if item.userID.isEmpty == true {
            return
        }
        
        let userMap = UserMap()
        userMap.uid = item.userID
        userMap.unm = item.userName
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(userMap, update: true)
        }
    }
    
    
}
    
