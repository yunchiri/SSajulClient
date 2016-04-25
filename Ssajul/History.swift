//
//  History.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 4. 23..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import Foundation
import RealmSwift


class History : Object {
//    dynamic var type  = "" //SSajulClient.historyType = SSajulClient.historyType.watch
    dynamic var boardId = ""
    dynamic var uid = ""
    dynamic var title = ""
    dynamic var updateAt : NSDate? = nil
    
    

}