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



class ItemTableViewController: UITableViewController , WKUIDelegate , WKNavigationDelegate, CommentWriteCellDelegate {
    
    
    @IBOutlet weak var inputContainerView: UIView!
    var isLoading : Bool = false
    
    enum CellType : Int {
        case header = 0
        case body = 1
        case comment
        case commentAdder
        
    }
    
    var commentWriteCell : CommentWriteCell? = nil
    var commentList = [Comment]()
    let webView2 = SSajulClient.sharedInstance.webView2
    
    var contentSize : CGFloat = 0
    var isContentAdd : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        loadingContent();        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
       // SSajulClient.sharedInstance.saveWatching()

        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        webView2.stopLoading()
        self.isLoading = false
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    
    
    func handleRefresh(refreshControl : UIRefreshControl){
        
        self.loadingContent()
        refreshControl.endRefreshing()
    }
    
    
    func setUp(){
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        self.title = SSajulClient.sharedInstance.selectedItem?.title
        webView2.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        webView2.frame.size = CGSizeMake(100, 100)
        webView2.UIDelegate = self
        webView2.navigationDelegate = self
        webView2.scrollView.scrollEnabled = true
        webView2.scrollView.bounces = false
        
        
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
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
        
        if isLoading == true {
            return
        }
        
        isLoading = true
        let url = NSURL(string: SSajulClient.sharedInstance.urlForContent( ))!
        
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        Alamofire.request(.GET, url)
            .responseString(encoding: NSUTF8StringEncoding  ) { response in
                
                guard let doc = Kanna.HTML(html: response.description, encoding: NSUTF8StringEncoding) else { return }
   
                
                let content : XMLElement = doc.css("div#articleView").first!
                
                let htmlCode =  SSajulClient.sharedInstance.createHTML3(content.toHTML!)
                
                let dispatch_group = dispatch_group_create()
                let highPriorityQueue = dispatch_get_main_queue()
                let mediumPriorityQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//
//                //content
//                
//                
                dispatch_group_async(dispatch_group, highPriorityQueue, {
                    self.webView2.loadHTMLString(htmlCode, baseURL: nil)
                })
                
                
                dispatch_group_async(dispatch_group,mediumPriorityQueue , {
                    let commentHtml = doc.xpath("//div[3]/ul/li")
                    
                    if self.commentList.count > 0 {
                        self.commentList.removeAll()
                    }
                    
                    for comment in  commentHtml{
                        guard comment.xpath("p").count >= 2 else {
                            continue
                        }
                        self.commentList.append(self.createComment(comment))
                    }
                    
                })
                
                dispatch_group_notify(dispatch_group, dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    self.isLoading = false
                })
                
                    
//                    //content
//                    dispatch_async(dispatch_get_main_queue(), {
//                        self.webView2.loadHTMLString(htmlCode, baseURL: nil)
//                    })
//                    
//                    let commentHtml = doc.xpath("//div[3]/ul/li")
//                    
//                    if self.commentList.count > 0 {
//                        self.commentList.removeAll()
//                    }
//                    
//                    for comment in  commentHtml{
//                        guard comment.xpath("p").count >= 2 else {
//                            continue
//                        }
//                        self.commentList.append(self.createComment(comment))
//                    }
//                    self.tableView.reloadData()
                
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
    
    
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
//        print("didCommitNavigation");
        if isLoading == true {
            return
        }
        
        webView.evaluateJavaScript("document.height") { (result, error) in
            if error == nil {
//                print(result as! CGFloat)
                guard result is CGFloat else {
                    return
                }
                
                self.contentSize =   result as! CGFloat
                
                if self.contentSize < 300 {
                    self.contentSize = 300
                }
                
//                self.tableView.reloadRowsAtIndexPaths( [NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadRowsAtIndexPaths( [NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
                })
            }
        }

        
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print("didfinish Navigation");
        webView.evaluateJavaScript("document.height") { (result, error) in
            if error == nil {
//                print(result as! CGFloat)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                
                let finishContentSize = result as! CGFloat
                
                if self.contentSize != finishContentSize {
                    self.contentSize =   result as! CGFloat
                    print("didfinish Navigation is Loaing : " + self.isLoading.description);
                    
                    guard self.isLoading == false else{
                        return
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadRowsAtIndexPaths( [NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
                    })
                    
                }
            }
        }

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
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if SSajulClient.sharedInstance.isLogin() == false {
            return false
        }
        
        if indexPath.row == CellType.header.rawValue {
            return true
        }
        
        if indexPath.row == commentList.count + 2 {
            return false
        }
        
        if indexPath.row == CellType.body.rawValue{
            return false
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell is CommentCell {
            
//            if cell._comment?.userID == SSajulClient.sharedInstance.getLoginID() {
                return true
//            }
        }
        
        
        
        return false
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {


        if indexPath.row == CellType.header.rawValue{
            let deleteItem = UITableViewRowAction(style: .Normal, title: "글삭제") { (action, index) in
                print("delete header")
                
                
            }
            
            deleteItem.backgroundColor = UIColor.redColor()
            
            return [deleteItem]
        }
        
        
        let delete = UITableViewRowAction(style: .Normal, title: "삭제") { (action, index) in
            print("delete")
            
            
            //delete this comment
        }
        

        
        
        
        delete.backgroundColor = UIColor.redColor()
//
        let voteUp = UITableViewRowAction(style: .Normal, title: "추천") { (action, index) in
            print("voteUp")
            
            
        }
//
//        
//        voteUp.backgroundColor = UIColor.greenColor()
//        
//        
//        let voteDown = UITableViewRowAction(style: .Normal, title: "비추천") { (action, index) in
//            print("voteDown")
//            
//            
//        }
//        
//        
//        voteDown.backgroundColor = UIColor.grayColor()
//        
//        
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        
//        if cell is CommentCell {
//            let comment = (cell as! CommentCell)._comment
//            if comment?.userID == SSajulClient.sharedInstance.getLoginID() {
//                return [voteDown, voteUp ,delete]
//            }
//        }
        
        return [ delete , voteUp ]
        
    }


  
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        //guard indexPath.row == CellType.body
        
    }
    
    
    func  commentDidPost() {
        self.loadingContent()
    }
    
    func needLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController = storyboard.instantiateViewControllerWithIdentifier("loginVC") as! LoginViewController
        
        self.presentViewController(loginViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func share(sender: AnyObject) {
        
                 let firstActivityItem = SSajulClient.sharedInstance.urlForContent()
                 let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
              self.presentViewController(activityViewController, animated: true, completion: nil)

    }
    
}
