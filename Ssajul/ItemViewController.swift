//
//  DetailViewController.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 2. 1..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import Kanna

class ItemViewController: UIViewController , WKNavigationDelegate{
    
    var selectedBoard : Board? = nil
    var selectedItem : Item? = nil
    
    
    let webView2 = WKWebView()
    let progressSpinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView2.frame = CGRect(x: 0, y: 22, width: view.frame.width, height: view.frame.height-22)
        
        webView2.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        webView2.navigationDelegate = self
        
        progressSpinner.frame = CGRect(x: view.frame.width/2-30, y: view.frame.height/2-30, width: 60, height: 60)
        
        view.addSubview(webView2)
        view.addSubview(progressSpinner)
        view.backgroundColor = UIColor.whiteColor()
        
        
        let boardId = selectedBoard?.boardID
        let itemId = selectedItem?.uid
        
        let urlString = String(format:  "http://m.soccerline.co.kr/bbs/%@/view.html?uid=%@&page=1&code=%@&keyfield=&key=&period=",  boardId!, itemId!, boardId!)

        let url = NSURL(string: urlString)!
        
        
        Alamofire.request(.GET, url)
            .responseString(encoding: NSUTF8StringEncoding  ) { response in
                
                if let doc = Kanna.HTML(html: response.description, encoding: NSUTF8StringEncoding){
                    
                    let content : XMLElement = doc.css("div#articleView").first!
                    
                    let htmlCode =   self.createHTML(content.toHTML!)
                    self.webView2.loadHTMLString(htmlCode, baseURL: nil)
                    self.webView2.allowsBackForwardNavigationGestures = true

                }
        }


        
    }
    
    override func didReceiveMemoryWarning() {
        
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

