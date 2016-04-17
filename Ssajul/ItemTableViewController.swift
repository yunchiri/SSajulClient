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


class ItemTableViewController: UITableViewController , UIWebViewDelegate , CommentWriteCellDelegate {
    
    
    @IBOutlet weak var inputContainerView: UIView!
    
    
    enum CellType : Int {
        case header = 0
        case body = 1
        case comment
        case commentAdder
        
    }
    
    var commentWriteCell : CommentWriteCell? = nil
    
    //    var selectedBoard : Board? = nil
    //    var selectedItem : Item? = nil
    
    var commentList = [Comment]()
    let webView2 = UIWebView()
    
    var contentSize : CGFloat = 0
    var isContentAdd : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = SSajulClient.sharedInstance.selectedItem?.title
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        
        webView2.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        webView2.frame.size = CGSizeMake(100, 100)
        webView2.delegate = self
        webView2.scrollView.scrollEnabled = true
        webView2.scrollView.bounces = false
        //webView2.backgroundColor = UIColor.blueColor()
        //
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        
        loadingContent();
        
        
    }
    
    func handleRefresh(refreshControl : UIRefreshControl){
        self.loadingContent()
        refreshControl.endRefreshing()
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
        return commentList.count + 3
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == CellType.header.rawValue {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! ItemCell
            
            cell.setItem( SSajulClient.sharedInstance.selectedItem!)
            
            return cell
            
        }
        if indexPath.row == CellType.body.rawValue {
            let cell = tableView.dequeueReusableCellWithIdentifier("contentCell", forIndexPath: indexPath)
            
            webView2.frame = CGRectMake(0, 0 ,cell.frame.size.width,contentSize+1)
            
            
            if isContentAdd == false {
                cell.contentView.addSubview(webView2)
                isContentAdd = true
            }
            return cell
        }
        
        if indexPath.row == commentList.count + 2 {
            
            let cell2 = tableView.dequeueReusableCellWithIdentifier("commentWriteCell", forIndexPath: indexPath) as! CommentWriteCell
            
            commentWriteCell = cell2
            cell2.delegate = self
            return cell2
        }
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentCell
        
        cell.setComment(commentList[indexPath.row - 2])
        return cell
    }
    
    
    
    func loadingContent()  {
        
        if commentList.count > 0 {
                commentList.removeAll()
        }
        
        let url = NSURL(string: SSajulClient.sharedInstance.urlForContent( ))!
        
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        Alamofire.request(.GET, url)
            .responseString(encoding: NSUTF8StringEncoding  ) { response in
                
                
                if let doc = Kanna.HTML(html: response.description, encoding: NSUTF8StringEncoding){
                    
                    
                    
                    let content : XMLElement = doc.css("div#articleView").first!
                    
                    let htmlCode =  SSajulClient.sharedInstance.createHTML(content.toHTML!)
                    
                    
                    //content
                    dispatch_async(dispatch_get_main_queue(), {
                        self.webView2.loadHTMLString(htmlCode, baseURL: nil)
                    })
                    
                    //comment
                    
                    //comment item
                    
                    //let commentParameter = doc.css("#viewWriteCommentFrm")

                    let commentHtml = doc.xpath("//div[3]/ul/li")
                    
                    for comment in  commentHtml{
                        guard comment.xpath("p").count >= 2 else {
                            continue
                        }
                        self.commentList.append(self.createComment(comment))
                    }
                    self.tableView.reloadData()
                }
        }
    }
    
    func createComment( commentHTML : XMLElement) -> Comment{
        
        
        
        
        var newComment = Comment()
        
        let commentDetail = (commentHTML.xpath("p").last?.text)!
        
        newComment.content = (commentHTML.xpath("p").first?.text)!
        newComment.userInfo = commentDetail
        
        var commentDetailList = commentDetail.characters.split("-").map(String.init)
        
        if commentDetailList.count > 3 {
           
            for var y in 1..<commentDetailList.count - 2 {
                commentDetailList[0] = commentDetailList[0] + "-" + commentDetailList[y]
            }
            
        }
        
        let searchCharacter: Character = "("
        let indexOfStart = commentDetailList[0].characters.indexOf(searchCharacter)
        
        
        let userName = commentDetailList[0].substringToIndex(indexOfStart!).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        let userID = commentDetailList[0].substringFromIndex(indexOfStart!).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        newComment.userName = userName
        newComment.userID = String(String(userID.characters.dropLast()).characters.dropFirst())
        newComment.createAt = commentDetailList[ commentDetailList.count - 1  ]
        
        return newComment
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        contentSize = webView.scrollView.contentSize.height
        
        self.tableView.reloadRowsAtIndexPaths( [NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    
    //댓글
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == CellType.body.rawValue {
            return contentSize
        }
        
        if indexPath.row == commentList.count + 2 {
            return 120
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == CellType.body.rawValue {
            return UITableViewAutomaticDimension;
        }
        
        return 60;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        
        if selectedCell is CommentCell {
            let userName = (selectedCell as! CommentCell).getUserName()
            commentWriteCell?.addTargetUser(userName)
            
        }
        
    }
    
    func  commentDidPost() {
        self.loadingContent()
    }
    
    func needLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController = storyboard.instantiateViewControllerWithIdentifier("loginVC") as! LoginViewController
        
        self.presentViewController(loginViewController, animated: true, completion: nil)
        
    }
    
    
    
}
