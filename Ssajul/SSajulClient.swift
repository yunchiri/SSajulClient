//
//  SSajulClient.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 2. 23..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import Foundation

import Alamofire

class SSajulClient  {
    static let sharedInstance = SSajulClient()
    
    func getBoardList() -> Array<Board>{
        
        

        return         [Board(name: "간호사근무편성", boardID: "soccerboard"), Board(name: "전공의근무편성", boardID: "locker")]
    }
    
    func getItemList(board : Board, page : Int) -> String{
        
//        guard board == nil else{
//            return
//        }
        
        
        let url = "http://m.soccerline.co.kr/bbs/locker/list.html?&code=locker&keyfield=&key=&period=&page=4"

            Alamofire.request(.GET, url)
                .responseString(encoding: NSUTF8StringEncoding) { response in
                    print(response.description)
            }
        
        return ""
    }
    
    func getItem(board : Board, itemID : String) -> String{
        
        return ""
    }
    
    func login() {
        
    }
    
    func logout() {
        
    }

    
}