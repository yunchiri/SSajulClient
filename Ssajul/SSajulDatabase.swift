//
//  SSajulDatabase.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 5. 5..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import Foundation
//import RealmSwift

class SSajulDatabase{
    static let sharedInstance = SSajulClient()
    
    func saveWatching() {
        
        
        let history = History()
        //        history.type = historyType.comment.rawValue
//        history.boardId = (selectedBoard?.boardID)!
//        history.uid = (selectedItem?.uid)!
//        history.title = (selectedItem?.title)!
        
//        let realm = try! Realm(History)
//        
//        try! realm.write {
//            realm.add(history)
//        }
    }
    
    
}
    