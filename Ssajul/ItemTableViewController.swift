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
import NextGrowingTextView


class ItemTableViewController: UITableViewController , UIWebViewDelegate{

    
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var growingTextView: NextGrowingTextView!
    
    
    
    var selectedBoard : Board? = nil
    var selectedItem : Item? = nil
    
    var commentList = [Comment]()
    let webView2 = UIWebView()
    
    var contentSize : CGFloat = 0
    var isContentAdd : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.selectedItem?.title
        
        //댓글 셋팅
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        self.growingTextView.layer.cornerRadius = 4
        self.growingTextView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        
        
        webView2.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        webView2.frame.size = CGSizeMake(100, 100)
        
        webView2.delegate = self
        webView2.scrollView.scrollEnabled = true
        webView2.scrollView.bounces = false
        //webView2.backgroundColor = UIColor.blueColor()
        //
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension;

        
//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.estimatedRowHeight = 100
        
        let boardId = selectedBoard?.boardID
        let itemId = selectedItem?.uid
        
        let urlString = String(format:  "http://m.soccerline.co.kr/bbs/totalboard/view.html?uid=%@&page=1&code=%@&keyfield=&key=&period=", itemId!, boardId!)
        
        let url = NSURL(string: urlString)!
        
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        Alamofire.request(.GET, url)
            .responseString(encoding: NSUTF8StringEncoding  ) { response in
                
                
                if let doc = Kanna.HTML(html: response.description, encoding: NSUTF8StringEncoding){
                    
                    
                    let content : XMLElement = doc.css("div#articleView").first!
                    
                    let htmlCode =  SSajulClient.sharedInstance.createHTML(content.toHTML!)
                    

                    
                    self.webView2.loadHTMLString(htmlCode, baseURL: nil)
                    
                    //comment parsing()
                    
                    let commentHtml = doc.xpath("//div[3]/ul/li")
                    
                    
                    for comment in  commentHtml{
                        
                        guard comment.xpath("p").count >= 2 else {
                            continue
                        }
                        
//                        if comment.xpath("p").count < 2 {
//                            continue
//                        }
                        
                        let newComment = Comment()
                        newComment.content = (comment.xpath("p").first?.text)!
                        newComment.userInfo = (comment.xpath("p").last?.text)!
                        
                        self.commentList.append(newComment)
                        
                    }
                    
                    self.tableView.reloadData()

                }

        }
        
    }

    @IBAction func addComent(sender: AnyObject) {
            self.tableView.endEditing(true)
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
            
            webView2.frame = CGRectMake(0, 0 ,cell.frame.size.width,contentSize+1)

            
            if isContentAdd == false {
                cell.contentView.addSubview(webView2)
                isContentAdd = true
            }
            return cell
        }
        
//        if indexPath.row == 1 {
//            let cell = tableView.dequeueReusableCellWithIdentifier("q1", forIndexPath: indexPath) as! ContentCell
//            
//           //            
//            return cell
//        }
        
   
        
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentCell
        
        cell.setComment(commentList[indexPath.row - 2])
        return cell
    }


    func webViewDidFinishLoad(webView: UIWebView) {
//        print( webView.scrollView.contentSize.height);
        //
        contentSize = webView.scrollView.contentSize.height
        
//        self.tableView.deleteRowsAtIndexPaths( [NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)

        self.tableView.reloadRowsAtIndexPaths( [NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    

    //댓글
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return contentSize
        }
        
        return UITableViewAutomaticDimension
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        if indexPath.row == 1 {
            return UITableViewAutomaticDimension;
        }
        
        if indexPath.row > 1 {
            return 70
        }
        
        return 60;
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func handleSendButton(sender: AnyObject) {
        self.growingTextView.text = ""
        self.view.endEditing(true)
    }
    
    
    func keyboardWillHide(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            if let _ = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
            }
        }
    }
    func keyboardWillShow(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
//                self.inputContainerViewBottom.constant = keyboardHeight


//
            
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
                tableViewScrollToBottom(true)
            
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRowsInSection(numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
            }
            
        })
    }
    
}
