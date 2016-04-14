////
////  ContentCell.swift
////  Ssajul
////
////  Created by yunchiri on 2016. 3. 6..
////  Copyright © 2016년 youngchill. All rights reserved.
////
//
//import UIKit
//
//import Alamofire
//import Kanna
//class ContentCell: UITableViewCell ,UIWebViewDelegate{
//
//    //
//    
//
//
//    @IBOutlet weak var webView: UIWebView!
//    
//
//    
//    
//    func updateContent(boardId : String, itemId : String){
//      
//        webView.delegate = self
//        
//        let urlString = String(format:  "http://m.soccerline.co.kr/bbs/%@/view.html?uid=%@&page=1&code=%@&keyfield=&key=&period=",  boardId, itemId, boardId)
//        
//        let url = NSURL(string: urlString)!
//        
//        Alamofire.request(.GET, url)
//            .responseString(encoding: NSUTF8StringEncoding  ) { response in
//                
//                if let doc = Kanna.HTML(html: response.description, encoding: NSUTF8StringEncoding){
//                    
//                    let content : XMLElement = doc.css("div#articleView").first!
//                    
//                    let htmlCode =   self.createHTML(content.toHTML!)
//                    self.webView.loadHTMLString(htmlCode, baseURL: nil)
//                    
//                }
//        }
//        
//
//    }
//    
//    func webViewDidFinishLoad(webView: UIWebView) {
//        print(webView.scrollView.contentSize.height)
//        print("finish")
//    }
//    
//    func createHTML(content : String) -> String{
//        let html = "<html>"
//            + "<head>"
//            + "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />"
//            + "<meta name=\"viewport\""
//            + "\tcontent=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi\" />"
//            + "<script"
//            + "\tsrc=\"http://code.jquery.com/mobile/1.0.1/jquery.mobile-1.0.1.min.js\"></script>"
//            + "<style type=\"text/css\">"
//            + "#articleView * {"
//            + "\tmax-width: 100%; !important;"
//            + "}"
//            + "</style>"
//            + "</head><body>"
//            + "\(content) </body></html>"
//        
//        return html
//    }
//    
//}
