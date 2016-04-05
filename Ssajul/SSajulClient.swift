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
    
    var _isLogin : Bool = false
    
    
    func getBoardList() -> Array<Board>{
        
        
//soccermingboard
//columnboard
        return [Board(name: "해외축구게시판", boardID: "soccerboard")
            , Board(name: "국내축구게시판", boardID: "kookdaeboard")
            , Board(name: "축구동영상게시판", boardID: "soccermingboard")
            , Board(name: "축구칼럼게시판", boardID: "columnboard")
            , Board(name: "축구추천게시판", boardID: "recomboard")
            , Board(name: "라커룸", boardID: "locker")
            , Board(name: "동영상게시판", boardID: "streamingboard")
            , Board(name: "게임게시판", boardID: "gameboard")
            , Board(name: "투표게시판", boardID: "pollboard")
            , Board(name: "라커룸추천", boardID: "locker_recom")        
        ]
        
            

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
        _isLogin = true
        
    }
    
    func logout() {
        _isLogin = false
    }
    
    func isLogin() -> Bool {
        return _isLogin
    }
    
    
    func createHTML(content : String) -> String{
        let html = "<html>"
            + "<head>"
            + "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />"
            + "<meta name=\"viewport\""
            + "\tcontent=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi\" />"
            + "<script"
            + "\tsrc=\"http://code.jquery.com/mobile/1.0.1/jquery.mobile-1.0.1.min.js\"></script>"
            + "<style type=\"text/css\">"
            + "#articleView * {"
            + "\tmax-width: 100%; !important;"
            + "}"
            + "</style>"
            + "</head><body>"
            + "\(content) </body></html>"
        
        return html
    }

    
}