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


class ItemTableViewController: UITableViewController , UIWebViewDelegate  {
    
    
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var growingTextView: NextGrowingTextView!
    
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
        
        //댓글 셋팅
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        //
        //        self.growingTextView.layer.cornerRadius = 4
        //        self.growingTextView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        
        
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
        self.tableView.reloadData()
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
            
            return cell2
        }
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentCell
        
        cell.setComment(commentList[indexPath.row - 2])
        return cell
    }
    
    
    
    func loadingContent()  {
        
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
                    
                    //                    let commentParameter = doc.css("#viewWriteCommentFrm")
                    
                    
                    //comment parsing()
                    
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
        newComment.content = (commentHTML.xpath("p").first?.text)!
        newComment.userInfo = (commentHTML.xpath("p").last?.text)!
        
        let searchCharacter: Character = "-"
        let searchCharacterQueto: Character = "-"

        let indexOfStart = newComment.userInfo!.characters.indexOf(searchCharacter)!.advancedBy(1)
        let indexOfEnd = newComment.userInfo!.characters.indexOf(searchCharacter).
        let range = Range.init(start: indexOfStart, end: indexOfEnd)

        let preUid = newComment.userInfo!.substringWithRange(range)
        

        
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
        commentWriteCell?.addTargetUser("selected id")
    }
    
    
    
}
