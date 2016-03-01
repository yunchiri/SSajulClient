//
//  DetailViewController.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 2. 1..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
import WebKit

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
        
        webView2.loadRequest(NSURLRequest(URL: url))
        webView2.allowsBackForwardNavigationGestures = true
        
    }
    
    override func didReceiveMemoryWarning() {
        
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

