//
//  ItemTableViewController.swift
//  Ssajul
//
//  Created by 서 홍원 on 2016. 3. 4..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import Kanna


class ItemTableViewController: UITableViewController , WKNavigationDelegate{

    var selectedBoard : Board? = nil
    var selectedItem : Item? = nil
    
    var commentList = [Comment]()
    let webView2 = WKWebView()
    
    var contentSize : CGFloat = 0
    var isContentAdd : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let c =  Comment(userID: "a", userName: "a", userIP: "a", createAt: "a", voteUp: 1, voteDown: 1, content: "a", rawData: "a")
        
        commentList.append(c)
        
//        webView2.frame = CGRect(x: 0, y: 22, width: view.frame.width, height: 0)//view.frame.height-22)
        
        webView2.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        webView2.navigationDelegate = self
        
        webView2.backgroundColor = UIColor.brownColor()

        
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
                    
                }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return commentList.count + 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("contentCell", forIndexPath: indexPath)
            
            //webView2.frame = CGRectMake(0,0,cell.frame.size.width,contentSize)
            
            (cell as! ContentCell).updateContent((selectedBoard?.boardID)!,  itemId: (selectedItem?.uid)!)


            
            return cell
        }
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath)
        cell.textLabel?.text = commentList[indexPath.row - 1].content
        
        return cell
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        print( webView.scrollView.contentSize.height);
        //
        contentSize = webView.scrollView.contentSize.height
        
        self.tableView.reloadRowsAtIndexPaths( [NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Automatic)
        
    }

    

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (indexPath.row == 0){
            return 200;
//            
//            contentHeights[webView.tag] = webView.scrollView.contentSize.height
//            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: webView.tag, inSection: 0)], withRowAnimation: .Automatic)
        }
        
        return 44;
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
