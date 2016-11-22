//
//  ItemTableViewController.swift
//  Ssajul
//
//  Created by 김영칠 on 2016. 3. 4..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import Kanna
import ChameleonFramework
import SVProgressHUD


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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // SSajulClient.sharedInstance.saveWatching()
        SVProgressHUD.setMinimumDismissTimeInterval(1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SSajulDatabase.sharedInstance.saveReadHistory(SSajulClient.sharedInstance.selectedBoard!, item: SSajulClient.sharedInstance.selectedItem!)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView2.stopLoading()
        self.isLoading = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        webView2.removeFromSuperview()
    }
    
    func handleRefresh(_ refreshControl : UIRefreshControl){
        
        self.loadingContent()
        refreshControl.endRefreshing()
    }
    
    
    func setUp(){
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        self.title = SSajulClient.sharedInstance.selectedBoard?.name
        webView2.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView2.frame.size = CGSize(width: 100, height: 100)
        webView2.uiDelegate = self
        webView2.navigationDelegate = self
        webView2.scrollView.isScrollEnabled = true
        webView2.scrollView.bounces = false
        
        
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
    }
    
    deinit{
        webView2.removeFromSuperview()
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        webView2.setNeedsLayout()
    }
    
    
    @IBAction func addComent(_ sender: AnyObject) {
        self.tableView.endEditing(true)
    }
    
    @IBAction func getContentLast(_ sender: AnyObject) {
        if self.tableView.numberOfRows(inSection: 0) > 0 {
            let indexPath = IndexPath(item: self.commentList.count + 2, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count + 3
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == CellType.header.rawValue {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
            
            cell.setItem( SSajulClient.sharedInstance.selectedItem!)
            
            return cell
            
        }
        if indexPath.row == CellType.body.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath)
            
            webView2.frame = CGRect(x: 0, y: 0 ,width: cell.frame.size.width,height: contentSize+1)
            
            
            if isContentAdd == false {
                cell.contentView.addSubview(webView2)
                isContentAdd = true
            }
            return cell
        }
        
        if indexPath.row == commentList.count + 2 {
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "commentWriteCell", for: indexPath) as! CommentWriteCell
            
            commentWriteCell = cell2
            cell2.delegate = self
            
            return cell2
        }
        

        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
        
        cell.setComment(commentList[indexPath.row - 2])
        
        return cell
    }
    
    
    
    func loadingContent()  {
        
        if isLoading == true {
            return
        }
        
        isLoading = true
        let url = URL(string: SSajulClient.sharedInstance.urlForContent( ))!
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Alamofire.request( url)
            .responseString(encoding: String.Encoding.utf8  ) { response in
                
                
                
                if response.result.isFailure == true{
                    self.isLoading = false
                    //UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    return
                }
                
                //guard let doc = Kanna.HTML(html: response.description, encoding: NSUTF8StringEncoding) else {
                guard let doc = Kanna.HTML(html: response.description, encoding: String.Encoding.utf8) else {
                    self.isLoading = false
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    return
                }
                
                guard doc.text?.contains("이미 삭제") == false else {
                    self.isLoading = false
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    let alertController = UIAlertController(title: "번개처럼 삭제~", message: " - 주멘 -", preferredStyle: UIAlertControllerStyle.alert)
                    
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
//                        print("OK")
                    }
                    alertController.addAction(okAction)
                    //self.presentViewController(alertController, animated: true, completion: nil)
                    
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
                guard doc.text?.contains("Bad Gateway") == false else {
                    self.isLoading = false
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    let alertController = UIAlertController(title: "502 Bad Gateway 탈세급 오류", message: " - 어리둥절 -", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        print("OK")
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                
                guard let content:XMLElement =  doc.css("div#articleView").first else {
                    self.isLoading = false
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    return
                }

                let htmlCode =  SSajulClient.sharedInstance.createHTML2(content.toHTML!)
                
                let dispatchGroup = DispatchGroup.init()
                

                
                
                
                
                DispatchQueue.global(qos: .userInitiated).async(group:dispatchGroup) {
                        self.webView2.loadHTMLString(htmlCode, baseURL: nil)
                }
                
//                dispatch_group_async(dispatchGroup, highPriorityQueue, {
//                    self.webView2.loadHTMLString(htmlCode, baseURL: nil)
//                })
                
                DispatchQueue.global(qos: .userInitiated).async(group:dispatchGroup) {
                        let commentHtml = doc.xpath("//div[3]/ul/li")
                        
                        if self.commentList.count > 0 {
                            self.commentList.removeAll()
                        }
                        
                        //무슨코드지?
                        for comment in  commentHtml{
                            guard comment.xpath("p").count >= 2 else {
                                //                        guard (comment.xpath("p") as XMLNodeSet).count>= 2 else {
                                continue
                            }
                            self.commentList.append(self.createComment(comment))
                            
                            SSajulClient.sharedInstance.selectedItem?.commentCount = self.commentList.count
                        }
                        
                }
                
//                dispatch_group_async(dispatch_group,highPriorityQueue , {
//                    let commentHtml = doc.xpath("//div[3]/ul/li")
//                    
//                    if self.commentList.count > 0 {
//                        self.commentList.removeAll()
//                    }
//                
//                //무슨코드지?
//                    for comment in  commentHtml{ 
//                        guard comment.xpath("p").count >= 2 else {
////                        guard (comment.xpath("p") as XMLNodeSet).count>= 2 else {
//                            continue
//                        }
//                        self.commentList.append(self.createComment(comment))
//                        
//                        SSajulClient.sharedInstance.selectedItem?.commentCount = self.commentList.count
//                    }
//                    
//                })
//
//                dispatch_group_notify(dispatch_group, DispatchQueue.main, {
//                    self.tableView.reloadData()
//                    self.isLoading = false
//                })
                
                dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                    self.tableView.reloadData()
                    self.isLoading = false
                })
                
                
        }
    }
    
    func createComment( _ commentHTML : XMLElement) -> Comment{
        
        
        
        var newComment = Comment()

        guard let content = (commentHTML.xpath("p").first?.text) else {
            return newComment
        }
        
        
        newComment.content = content

        

        guard let commentDetail = (commentHTML.xpath("p").reversed().first?.text) else {
//        guard let commentDetail = (commentHTML.xpath("p").last?.text) else {
            
            return newComment
        }
//
        
        newComment.userInfo = commentDetail
        
        
//        var commentDetailList = commentDetail.characters.split("-").map(String.init)
        
        var commentDetailList = commentDetail.components(separatedBy: "-")
        
        
        if commentDetailList.count > 3 {
            
            
            for idxDashInId in 1..<commentDetailList.count - 2 {
                commentDetailList[0] = commentDetailList[0] + "-" + commentDetailList[idxDashInId]
            }
            
        }
        
        let searchCharacter: Character = "("
        let indexOfStart = commentDetailList[0].characters.index(of: searchCharacter)
        
        let userName = commentDetailList[0].substring(to: indexOfStart!).trimmingCharacters(in: CharacterSet.whitespaces)
        
        let userID = commentDetailList[0].substring(from: indexOfStart!).trimmingCharacters(in: CharacterSet.whitespaces)
        
        newComment.userName = userName
        newComment.userID = String(String(userID.characters.dropLast()).characters.dropFirst())
        newComment.createAt = commentDetailList[ commentDetailList.count - 1  ]
        
        return newComment
    }
    
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //        print("didCommitNavigation");
        if isLoading == true {
            return
        }
        
        let javascriptString = "" +
            "var body = document.body;" +
            "var html = document.documentElement;" +
            "Math.max(" +
            "   body.scrollHeight," +
            "   body.offsetHeight," +
            "   html.clientHeight," +
            "   html.offsetHeight" +
        ");"
        
        webView.evaluateJavaScript(javascriptString) { (result, error) in
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
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadRows( at: [IndexPath(row: 0, section: 0)], with: .automatic)
                })
            }
        }
        
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //        print("didfinish Navigation");
        
        let javascriptString = "" +
            "var body = document.body;" +
            "var html = document.documentElement;" +
            "Math.max(" +
            "   body.scrollHeight," +
            "   body.offsetHeight," +
            "   html.clientHeight," +
            "   html.offsetHeight" +
        ");"
        
        
        webView.evaluateJavaScript(javascriptString) { (result, error) in
            if error == nil {
                //                print(result as! CGFloat)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                
                let finishContentSize = result as! CGFloat
                
                if self.contentSize != finishContentSize {
                    self.contentSize =   result as! CGFloat
                    //                    print("didfinish Navigation is Loaing : " + self.isLoading.description);
                    
                    guard self.isLoading == false else{
                        return
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadRows( at: [IndexPath(row: 0, section: 0)], with: .automatic)
                    })
                    
                }
            }
        }
        
    }
    
    
    //댓글
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == CellType.body.rawValue {
            return contentSize
        }
        
        if indexPath.row == commentList.count + 2 {
            return 132
        }
        
        if indexPath.row == commentList.count + 3 {
            return 120
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == CellType.body.rawValue {
            return UITableViewAutomaticDimension;
        }
        
        return 60;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        if selectedCell is CommentCell {
            let userName = (selectedCell as! CommentCell).getUserName()
            commentWriteCell?.addTargetUser(userName)
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        

        
        if indexPath.row == CellType.header.rawValue {
            return true
        }
        
        
        if indexPath.row == commentList.count + 2 {
            return false
        }
        
        if indexPath.row == CellType.body.rawValue{
            return false
        }
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell is CommentCell {
            
            return true
        }
        
        
        
        return false
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        if indexPath.row == CellType.header.rawValue{
            let deleteItem = UITableViewRowAction(style: .normal, title: "Report") { (action, index) in

                SVProgressHUD.showSuccess(withStatus: "Reporting to Manager")
                
                
                tableView.setEditing(false, animated: true)
                
                
            }
            deleteItem.backgroundColor = UIColor.red
            
            
            let favoriteItem = UITableViewRowAction(style: .default, title: "관심글") { (action, index) in
                
                SSajulDatabase.sharedInstance.saveFavoriteHistory(SSajulClient.sharedInstance.selectedBoard!, item: SSajulClient.sharedInstance.selectedItem!)
                SVProgressHUD.showSuccess(withStatus: "꼴꼴꼬르르를르ㅡㄹ르~~")
  
                
                tableView.setEditing(false, animated: true)
                
            }
            
            favoriteItem.backgroundColor = FlatLime()
            
            
            let reportUser = UITableViewRowAction(style: .normal, title: "Report User", handler: { (UITableViewRowAction, NSIndexPath) in
                SVProgressHUD.showSuccess(withStatus: "Reporting to Manager")
                
                
                tableView.setEditing(false, animated: true)
            })
            
            return [deleteItem, reportUser, favoriteItem]
//            return [favoriteItem]
        }
        
        
        let delete = UITableViewRowAction(style: .normal, title: "삭제") { (action, index) in
            print("delete")
            //delete this comment
        }
        
        delete.backgroundColor = UIColor.red
        //
        
        
        
        let voteUp = UITableViewRowAction(style: .normal, title: "추천") { (action, index) in
            print("voteUp")
            
            
        }

        
        return [ delete , voteUp ]
        
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        //guard indexPath.row == CellType.body
        
    }
    
    
    func  commentDidPost() {
        
        
        SSajulDatabase.sharedInstance.saveCommentHistory(SSajulClient.sharedInstance.selectedBoard!, item: SSajulClient.sharedInstance.selectedItem!)
        self.loadingContent()
        SVProgressHUD.showSuccess(withStatus: "")
    }
    
    func needLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        
        self.present(loginViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func share(_ sender: AnyObject) {
        
        let firstActivityItem = SSajulClient.sharedInstance.urlForContent()
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
}
