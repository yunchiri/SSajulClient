//
//  SSajulClient.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 2. 23..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import Foundation
import WebKit
import Alamofire


class SSajulClient  {
    static let sharedInstance = SSajulClient()
    
    
    
//    enum historyType : String {
//        case content
//        case comment
//        case watch
//    }

    var _isLogin : Bool = false
    
    var selectedBoard :Board?
    var selectedItem : Item?
    
    var boundaryPart = "pIGWeRaGJ9VVoeGq"
    
    let webView2 : WKWebView = WKWebView()
    
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
    
    func login(loginId : String , loingPwd : String) {
        _isLogin = true
        
        NSUserDefaults.standardUserDefaults().setObject( loginId, forKey: "login_id")
        NSUserDefaults.standardUserDefaults().setObject( loingPwd, forKey: "login_pwd")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        
    }
    
    func logout() {
        _isLogin = false
        
        NSUserDefaults.standardUserDefaults().setObject( "", forKey: "login_pwd")
        NSUserDefaults.standardUserDefaults().synchronize()
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
    
    func createHTML2(content : String) -> String{
        
        let contentAsync = content.stringByReplacingOccurrencesOfString("src=", withString: "data-aload=")
        
        
        let html = "<html>"
            + "<head>"
            
            
            + "<script> function aload(t){\"use strict\";t=t||window.document.querySelectorAll(\"[data-aload]\"),void 0===t.length&&(t=[t]);var a,e=0,r=t.length;for(e;r>e;e+=1)a=t[e],a[\"LINK\"!==a.tagName?\"src\":\"href\"]=a.getAttribute(\"data-aload\"),a.removeAttribute(\"data-aload\");return t}"
            + "window.onload = function () {          aload();        }; </script>"
//            + "<script data-aload=\"http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js\"></script>"
            + "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />"
            + "<meta name=\"viewport\""
            + "\tcontent=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi\" />"
            
            
            + "<style type=\"text/css\">"
            + "#articleView * {"
            + "\tmax-width: 100%; !important;"
            + "}"
            + "</style>"
            + "</head><body>"
            + "\(contentAsync) </body></html>"
        
        return html
    }

    func createHTML3(content : String) -> String{
        
        let html = "<html>"
            + "<head>"
            + "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />"
            + "<meta name=\"viewport\""
            + "\tcontent=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi\" />"
            
            
            + "<style type=\"text/css\">"
            + "#articleView * {"
            + "\tmax-width: 100%; !important;"
            + "}"
            + "</style>"
            + "</head><body>"
            + "\(content) </body></html>"
        
        return html
    }
    
    
    //cookie utils
    
    func showCookies() {
        
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        //println("policy: \(cookieStorage.cookieAcceptPolicy.rawValue)")
        
        let cookies = cookieStorage.cookies! as [NSHTTPCookie]
        
        print("Cookies.count: \(cookies.count)")
        
        for cookie in cookies {
            print("ORGcookie: \(cookie)")
        }
    }
    
    func deleteCookies() {
        let storage : NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in storage.cookies!  as [NSHTTPCookie]
        {
            storage.deleteCookie(cookie)
        }
        NSUserDefaults.standardUserDefaults()
    }
    
    //urls
    
    func urlForLogin() -> String {
        return "http://www.soccerline.co.kr/login/login_ok3.php"
    }
    
    func urlForComment() -> String {
        return "https://www.soccerline.co.kr/slboard/comment_write.php"
    }
    
    
    func urlForContent() -> String{
        if selectedBoard == nil { return "http://127.0.0.1" }
        if selectedItem == nil { return "http://127.0.0.1" }
        
        let boardId = selectedBoard!.boardID
        let itemId = selectedItem!.uid
        
        return String(format:  "http://m.soccerline.co.kr/bbs/totalboard/view.html?uid=%@&page=1&code=%@&keyfield=&key=&period=", itemId, boardId)
    }
    
    func urlForBoardItemList(page : Int) -> String{
        if selectedBoard == nil { return "http://127.0.0.1" }
        
        let boardId = selectedBoard!.boardID
        
        return String(format:  "http://www.soccerline.co.kr/slboard/list.php?page=%d&code=%@&keyfield=&key=&period=&", page, boardId)
    }
    
    func urlForBoardItemSearchedList(page : Int, key : String, keyfield : String) -> String{

        
//        return "http://www.soccerline.co.kr/slboard/list.php?page=1&code=locker&key=77&keyfield=subject&period=0|1987508143"
        if selectedBoard == nil { return "http://127.0.0.1" }
//        let x = NSURL(fileURLWithFileSystemRepresentation: <#T##UnsafePointer<Int8>#>, isDirectory: <#T##Bool#>, relativeToURL: <#T##NSURL?#>)
//        let encodingKey = "용두".dataUsingEncoding( CFStringConvertEncodingToNSStringEncoding( 0x0422 ))
//        let urf8Key =  encodingKey.
        let boardId = selectedBoard!.boardID
        
        let url = String(format:  "http://www.soccerline.co.kr/slboard/list.php?page=%d&code=%@&key=%@&keyfield=%@&period=0|1987508143", page, boardId,  "%BD%CE%C1%D9%BA%E4", keyfield)
        let urlString = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
//        let urlString = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())!
        
            return urlString
        
    }
    
    func urlForCommentWrite() -> String{
        
        return  "https://www.soccerline.co.kr/slboard/comment_write.php"
    }
    
    func urlForContentWrite() -> String{
        return "http://www.soccerline.co.kr/slboard/post.php"
    }
    
//    func BodyForContent() -> String {
//        let parameters = [
//            "nickname" : "¸¸½ÃÁî"
//            ,"code" : "cheongchun"
//            , "comment_yn" : "1"
//            , "subject" : "asdf"
//            , "comment" : "fda"
//            , "mode" : "W"
//            , "comment" : ""
//        ]
//
//
//        let boundary = "------WebKitFormBoundarypIGWeRaGJ9VVoeGq"
//        let endLine = "\r\n"
//        var body = ""
//        
//        
//        for (key, value) in parameters {
//            
//            body.stringByAppendingString("\(boundary)")
//            body.stringByAppendingString(endLine)
//            body.stringByAppendingString("Content-Disposition: form-data; name=\"\(key)\"")
//            body.stringByAppendingString(endLine)
//            body.stringByAppendingString(endLine)
//            body.stringByAppendingString(value as NSString as String)
//        }
//        
//        body.stringByAppendingString(boundary)
//        return body
//    }
    
    func ParametersForComment() -> [ String : String ] {
        //body default
//        var parameters = [ "code" : "soccerboard"
//            ,"tbl_name" : "soccerboard"
//            ,"comment_board_name" : "7"
//            ,"nickname" : "a"
//            ,"page" : ""
//            , "key" : ""
//            , "keyfield" : ""
//            , "period" : ""
//            , "uid" : "1987159662"
//            , "mode" : "W"
//            , "comment" : ""
//        ]
        
        var parameters = [
            "comment_board_name" : "7"
            ,"page" : ""
            , "key" : ""
            , "keyfield" : ""
            , "period" : ""
            , "mode" : "W"
            , "comment" : ""
        ]
        
        parameters["code"] =  selectedBoard?.boardID
        parameters["tbl_name"] =  selectedBoard?.boardID
        parameters["uid"] =  selectedItem?.uid
        
        return parameters
        
    }
    
    
    func getLoginID() -> String {
        
        let notlogin = "not_logined"
        if isLogin() == true {
            let userID = NSUserDefaults.standardUserDefaults().objectForKey( "login_id") as! String
            
            if userID.characters.count == 0 {
                return notlogin
            }
            
            return userID
        }
        
        return notlogin
    
    }
    

    
    
    
}