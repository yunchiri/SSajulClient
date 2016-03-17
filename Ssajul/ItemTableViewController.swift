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


class ItemTableViewController: UITableViewController , UIWebViewDelegate{

    var selectedBoard : Board? = nil
    var selectedItem : Item? = nil
    
    var commentList = [Comment]()
    let webView2 = UIWebView()
    
    var contentSize : CGFloat = 0
    var isContentAdd : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
   
        
//        let c =  Comment(userID: "a", userName: "a", userIP: "a", createAt: "a", voteUp: 1, voteDown: 1, content: "a", rawData: "a")
//        let c1 =  Comment(userID: "a", userName: "a", userIP: "a", createAt: "a", voteUp: 1, voteDown: 1, content: "a", rawData: "a")
//        let c2 =  Comment(userID: "a", userName: "a", userIP: "a", createAt: "a", voteUp: 1, voteDown: 1, content: "a", rawData: "a")
//        let c3 =  Comment(userID: "a", userName: "a", userIP: "a", createAt: "a", voteUp: 1, voteDown: 1, content: "a", rawData: "a")
//        let c4 =  Comment(userID: "a", userName: "a", userIP: "a", createAt: "a", voteUp: 1, voteDown: 1, content: "a", rawData: "a")
//        let c5 =  Comment(userID: "a", userName: "a", userIP: "a", createAt: "a", voteUp: 1, voteDown: 1, content: "a", rawData: "a")
//        
//        
//        commentList.append(c)
//        commentList.append(c1)
//        commentList.append(c2)
//        commentList.append(c3)
//        commentList.append(c4)
//        commentList.append(c5)
        
        webView2.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        webView2.frame.size = CGSizeMake(100, 100)
        
        webView2.delegate = self
        webView2.scrollView.scrollEnabled = false
        webView2.scrollView.bounces = false
        webView2.backgroundColor = UIColor.blueColor()
        //
        self.tableView.estimatedRowHeight = 30
        self.tableView.rowHeight = UITableViewAutomaticDimension;

        
//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.estimatedRowHeight = 100
        
        let boardId = selectedBoard?.boardID
        let itemId = selectedItem?.uid
        
        let urlString = String(format:  "http://m.soccerline.co.kr/bbs/%@/view.html?uid=%@&page=1&code=%@&keyfield=&key=&period=",  boardId!, itemId!, boardId!)
        
        let url = NSURL(string: urlString)!
        
        
        Alamofire.request(.GET, url)
            .responseString(encoding: NSUTF8StringEncoding  ) { response in
                
                if let doc = Kanna.HTML(html: response.description, encoding: NSUTF8StringEncoding){
                    
                    let content : XMLElement = doc.css("div#articleView").first!
                    
                    let htmlCode =  SSajulClient.sharedInstance.createHTML(content.toHTML!)
                    self.webView2.loadHTMLString(htmlCode, baseURL: nil)
                    
                    //comment parsing()
                    
                    let commentHtml = doc.xpath("//div[3]/ul/li")
                    
                    
                    for comment in  commentHtml{
                        
                        if comment.xpath("p").count < 2 {
                            continue
                        }
                        
                        let newComment = Comment()
                        newComment.content = (comment.xpath("p").first?.text)!
                        newComment.userInfo = (comment.xpath("p").last?.text)!
                        
                        self.commentList.append(newComment)
                        
                    }
                    
                    self.tableView.reloadData()
                }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count + 2
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.row == 0 {

            let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! ItemCell
            
            cell.setItem(selectedItem!)
            
            return cell
            
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("contentCell", forIndexPath: indexPath)
            
            webView2.frame = CGRectMake(0, 0 ,cell.frame.size.width,contentSize + 1)

            
            if isContentAdd == false {
                cell.contentView.addSubview(webView2)
                isContentAdd = true
            }
            return cell
        }
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentCell
        
        cell.setComment(commentList[indexPath.row - 2])
        return cell
    }


    func webViewDidFinishLoad(webView: UIWebView) {
//        print( webView.scrollView.contentSize.height);
        //
        contentSize = webView.scrollView.contentSize.height
        
        self.tableView.reloadRowsAtIndexPaths( [NSIndexPath(forRow: 2, inSection: 0)], withRowAnimation: .Automatic)
        
    }
    

//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//        
//        if (indexPath.row == 1){
//            return contentSize;
//        }
//        
//        if (indexPath.row > 1){
//            return 100
//        }
//        
//        return 60;
//    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        if (indexPath.row == 1){
            return 500;
        }
        
        if (indexPath.row > 1){
            return 70
        }
        
        return 60;
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
    
}
