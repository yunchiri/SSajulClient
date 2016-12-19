//
//  UserMap.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 12. 18..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import Foundation
import RealmSwift



class UserMap : Object {
    dynamic var uid = ""
    dynamic var unm  = ""
    
    override static func primaryKey() -> String? {
        return "unm"
    }
}
