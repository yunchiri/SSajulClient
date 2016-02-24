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
        
        
        let url = "http://m.soccerline.co.kr/bbs/soccerboard/list.html"

        Alamofire.request(.GET, url).responseJSON { response in
            switch response.result {
            case .Success(let data):
                
                print(data)
//                let json = JSON(data)
//                let name = json["name"].stringValue
//                print(name)
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
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