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
    
    let config = WKWebViewConfiguration()
    var webView2 : WKWebView// = WKWebView()
    
    
    
    
    init(){
        config.selectionGranularity = .character
        self.webView2 = WKWebView(frame: CGRect.zero, configuration: config)
        
    }
    
    func getBoardList() -> Array<Board>{
        
        
//soccermingboard
//columnboard
        return
             [
             Board(name: "전체 게시판", boardID: "totalboard")
            , Board(name: "해외축구게시판", boardID: "soccerboard")
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
    
    func getExtraBoardList() -> Array<Board>{
        
        
        //soccermingboard
        //columnboard
        return
            [   Board(name: "다음 해외스포츠", boardID : "http://sports.media.daum.net/sports/worldsoccer")
                , Board(name: "네이버 해외축구", boardID : "http://sports.news.naver.com/wfootball/index.nhn")
        ]
    }
    
    func getItemList(_ board : Board, page : Int) -> String{
        
//        guard board == nil else{
//            return
//        }
        
        
        let url = "http://m.soccerline.co.kr/bbs/locker/list.html?&code=locker&keyfield=&key=&period=&page=4"

            Alamofire.request( url)
                .responseString(encoding: String.Encoding.utf8) { response in
                    print(response.description)
            }
        
        return ""
    }
    
    func getItem(_ board : Board, itemID : String) -> String{
        
        return ""
    }
    
    func login(_ loginId : String , loingPwd : String) {
        _isLogin = true
        
        UserDefaults.standard.set( loginId, forKey: "login_id")
        UserDefaults.standard.set( loingPwd, forKey: "login_pwd")
        UserDefaults.standard.synchronize()
        
        
    }
    
    func logout() {
        _isLogin = false
        
        UserDefaults.standard.set( "", forKey: "login_pwd")
        UserDefaults.standard.synchronize()
    }
    
    func isLogin() -> Bool {
        return _isLogin
    }
    
    
    func createHTML(_ content : String) -> String{
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
    
    func createHTML33(_ content : String) -> String{
        
        let contentAsync = content.replacingOccurrences(of: "src=", with: "data-aload=")
        
        
        let html = "<html>"
            + "<head>"
            
            
            + "<script> function aload(t){\"use strict\";t=t||window.document.querySelectorAll(\"[data-aload]\"),void 0===t.length&&(t=[t]);var a,e=0,r=t.length;for(e;r>e;e+=1)a=t[e],a[\"LINK\"!==a.tagName?\"src\":\"href\"]=a.getAttribute(\"data-aload\"),a.removeAttribute(\"data-aload\");return t}"
            + "window.onload = function () {          aload();        }; </script>"
//            + "<script data-aload=\"http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js\"></script>"
            + "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />"
            + "<meta name=\"viewport\""
            + "\tcontent=\"width=device-width, initial-scale=1.0, user-scalable=no\" />"
            
            
            + "<style type=\"text/css\">"
            + "#articleView * {"
            + "\tmax-width: 100%; !important;"
            + "}"
            + "</style>"
            + "</head><body>"
            + "\(contentAsync) </body></html>"
        
        return html
    }

    func createHTML2(_ content : String) -> String{
        
        let html = "<html>"
            + "<head>"
            + "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />"
            + "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=0\" />"

            
            + "<style type=\"text/css\">"
            + "#articleView * {"
            + "\tmax-width: 100%; !important;"
            + "}"
            + "</style>"
            + "</head><body>"
            + "\(content) </body></html>"
        
        return html
    }
    
    
    func createHTML3(_ content : String) -> String{
        
        let types: NSTextCheckingResult.CheckingType = .link
        let detector = try? NSDataDetector(types: types.rawValue)
        let content2 = content.replacingOccurrences(of: "<br>", with: " <br> ")
//         content2 = content.stringByReplacingOccurrencesOfString("\n", withString: "")
//         content2 = content.stringByReplacingOccurrencesOfString("\r", withString: "")
//         content2 = content.stringByReplacingOccurrencesOfString("\t", withString: "")
//        content2 = content.stringByReplacingOccurrencesOfString("\r\n", withString: "")
        var content3 = content2
        let matches = detector!.matches(in: content2, options: .reportCompletion, range: NSMakeRange(0, content2.characters.count))
        
        for match in matches {
            
            
            if content.contains("img") == true || content.contains("embed") == true { break }
            print(match.url!)
            var urlx = match.url?.absoluteString
            
            urlx = urlx?.replacingOccurrences(of: "amp;", with: "")
            
            let link = "\r <a href =\"" + urlx! + "\"> " + urlx!  + "</a>"
            content3 = content2.replacingOccurrences(of: (match.url?.absoluteString)!, with: link )
        }
        
        
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
            + "\(content3) </body></html>"
        return html
    }
    
    //cookie utils
    
    func showCookies() {
        
        let cookieStorage = HTTPCookieStorage.shared
        //println("policy: \(cookieStorage.cookieAcceptPolicy.rawValue)")
        
        let cookies = cookieStorage.cookies! as [HTTPCookie]
        
        print("Cookies.count: \(cookies.count)")
        
        for cookie in cookies {
            print("ORGcookie: \(cookie)")
        }
    }
    
    func deleteCookies() {
        let storage : HTTPCookieStorage = HTTPCookieStorage.shared
        for cookie in storage.cookies!  as [HTTPCookie]
        {
            storage.deleteCookie(cookie)
        }
        UserDefaults.standard
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
    
    func urlForBoardItemList(_ page : Int) -> String{
        if selectedBoard == nil { return "http://127.0.0.1" }
        
        let boardId = selectedBoard!.boardID
        
        return String(format:  "http://www.soccerline.co.kr/slboard/list.php?page=%d&code=%@&keyfield=&key=&period=&", page, boardId)
    }
    
    func urlForBoardItemSearchedList(_ page : Int, key : String, keyfield : String) -> String{

        if selectedBoard == nil { return "http://127.0.0.1" }
        
        var newKey = key
        var newKeyfiled = keyfield
        if keyfield == "myContent" {
            newKeyfiled = "mem_id"
            newKey = SSajulClient.sharedInstance.getLoginID()
        }
        
        
        guard let encodingKey = newKey.addingPercentEscapes(using: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding( 0x0422 )) )
             else {
            return "http://127.0.0.1"
        }
        
        let boardId = selectedBoard!.boardID
        
        let url = String(format:  "http://www.soccerline.co.kr/slboard/list.php?page=%d&code=%@&key=%@&keyfield=%@&period=0|1987508143", page, boardId,  encodingKey, newKeyfiled)
        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
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
            let userID = UserDefaults.standard.object( forKey: "login_id") as! String
            
            if userID.characters.count == 0 {
                return notlogin
            }
            
            return userID
        }
        
        return notlogin
    
    }
    
    
    func isShowIntertitialAfter2Hour() -> Bool{
        var result :  Bool = false
        
        if let lastShowInterstitialTime = UserDefaults.standard.object(forKey: "lastShowInterstitialTime") {
            
            let inteval = Date().timeIntervalSince(lastShowInterstitialTime as! Date)
            
            if inteval > 7200 {
                result = true
            }
        }else{
            saveShowIntertitialDateTime()
        }
        
        
        return result
    }
    
    
    func saveShowIntertitialDateTime(){
        DispatchQueue.global( qos: DispatchQoS.QoSClass.utility).async {
            UserDefaults.standard.set(Date(), forKey: "lastShowInterstitialTime")
            UserDefaults.standard.synchronize()
        }
    }

    
    
    
}
