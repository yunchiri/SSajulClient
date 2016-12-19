//
//  ContentAdViewController.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 11. 22..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import Kanna
import ChameleonFramework
import SVProgressHUD


class ContentAdViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AdamAdViewDelegate , WKUIDelegate , WKNavigationDelegate, CommentWriteCellDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var adView: UIView!
    @IBOutlet var uiDownButton: UIButton!

    var refreshControl : UIRefreshControl!
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
        
        self.tabBarController?.hidesBottomBarWhenPushed = true
        setUp()
        loadingContent();
        
        self.tableView.addSubview( uiDownButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // SSajulClient.sharedInstance.saveWatching()
        SVProgressHUD.setMinimumDismissTimeInterval(1)

        let adamAdView = AdamAdView.shared()
        adamAdView?.frame = CGRect.init(x: 0, y: 0, width: self.adView.frame.size.width, height: self.adView.frame.size.height)
        
        adamAdView?.clientId = "DAN-1h7ooubgv7nzn"
        adamAdView?.delegate = self
        adamAdView?.gender = "M"
        
        if adamAdView?.usingAutoRequest == false {
            adamAdView?.startAutoRequestAd(60.0)
        }
        
        self.adView.addSubview(adamAdView!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        SSajulDatabase.sharedInstance.saveReadHistory(SSajulClient.sharedInstance.selectedBoard!, item: SSajulClient.sharedInstance.selectedItem!)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    

    
    func keyboardWasShown(_ notification: Notification)
    {
        let info = notification.userInfo
        var kbRect = (info![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        kbRect = view.convert(kbRect!, from: nil)
        
        var contentInsets = tableView.contentInset
        contentInsets.bottom = (kbRect?.size.height)! + 30
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWillBeHidden(_ notification: Notification)
    {
        var contentInsets = tableView.contentInset
        contentInsets.bottom = 0.0
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
    




    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView2.stopLoading()
        self.isLoading = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        webView2.removeFromSuperview()
        
        self.adView.subviews.forEach { view in
            (view as! AdamAdView).delegate = nil
            view.removeFromSuperview()
        }
    }
    
    func handleRefresh(_ refreshControl : UIRefreshControl){
        refreshControl.layoutIfNeeded()
        refreshControl.beginRefreshing()
        self.loadingContent()
        refreshControl.endRefreshing()
    }
    
    
    func setUp(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(self.refreshControl)
        
        self.title = SSajulClient.sharedInstance.selectedItem?.userName
        webView2.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView2.frame.size = CGSize(width: 100, height: 100)
        webView2.uiDelegate = self
        webView2.navigationDelegate = self
        webView2.scrollView.isScrollEnabled = true
        webView2.scrollView.bounces = false
        
        webView2.isUserInteractionEnabled = true
        
        
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
    }
    
    deinit{
        webView2.removeFromSuperview()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        self.uiDownButton.isHidden = true
    }
    

    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        webView2.setNeedsLayout()
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        self.uiDownButton.isHidden = false
    }
    
    
    
    
    @IBAction func addComent(_ sender: AnyObject) {
        self.tableView.endEditing(true)
    }
    
    @IBAction func goLastContent(_ sender: Any) {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count + 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == CellType.header.rawValue {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "contentHeaderCell", for: indexPath) as! ContentHeaderCell
            
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
            .responseString(encoding: String.Encoding.init(rawValue: CFStringConvertEncodingToNSStringEncoding(0x0422))  ) { response in
                
                
                
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
                
                //set content header
                self.updateHeader(doc: doc)
                
                
                
                guard let content:XMLElement =  doc.css("#DocContent").first else {
                    self.isLoading = false
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    return
                }
                
                let htmlCode =  SSajulClient.sharedInstance.createHTML2(content.innerHTML!)
                
                let dispatchGroup = DispatchGroup.init()
                
                
                
                
                
                
                DispatchQueue.global(qos: .userInitiated).async(group:dispatchGroup) {
                    self.webView2.loadHTMLString(htmlCode, baseURL: nil)
                }
                
                
                DispatchQueue.global(qos: .userInitiated).async(group:dispatchGroup) {
                    let commentHtml = doc.css("center center center table")
                    
                    if self.commentList.count > 0 {
                        self.commentList.removeAll()
                    }
                    
                    //무슨코드지?
                    for comment in  commentHtml{
                        guard comment.css("td").count >= 19 else {
                            //                        guard (comment.xpath("p") as XMLNodeSet).count>= 2 else {
                            continue
                        }
                        self.commentList.append(self.createComment(comment))
                        
                        SSajulClient.sharedInstance.selectedItem?.commentCount = self.commentList.count
                    }
                    
                }

                
                dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                    self.tableView.reloadData()
                    self.isLoading = false
                })
                
                
        }
    }
    
    func updateHeader(doc : HTMLDocument  ){
        let contentHeader:XPathObject = doc.css(".te1 .te2")
        if contentHeader.count > 0 {
            let headerList = contentHeader.makeIterator()
            
            var headerListIndex : Int = 0
            while let header = headerList.next(){
                
                if headerListIndex == 0 {
                    SSajulClient.sharedInstance.selectedItem?.userName = header.text!
                    
                }
                if headerListIndex == 1 {
                    SSajulClient.sharedInstance.selectedItem?.userID = header.text!
                    break;
                }
                
                headerListIndex = headerListIndex + 1
            }
        }
        
        
        if tableView.cellForRow(at: IndexPath.init(row: CellType.header.rawValue, section: 0) )  is ContentHeaderCell {
            let headerCell =  tableView.cellForRow(at: IndexPath.init(row: CellType.header.rawValue, section: 0) ) as! ContentHeaderCell
            headerCell.setItem(SSajulClient.sharedInstance.selectedItem!)
        }
        
            
        
        
    }
    
    func createComment( _ commentHTML : XMLElement) -> Comment{
        
        
        
        var newComment = Comment()
        
        
        newComment.userName = commentHTML.at_css("tr:nth-child(4) td b")?.content?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        newComment.content = (commentHTML.at_css("tr:nth-child(4)  td:nth-child(3) div")?.content)!
        newComment.createAt = commentHTML.at_css("tr:nth-child(4)  td:nth-child(4)")?.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        newComment.voteUp = Int((commentHTML.at_css("tr:nth-child(5) td.te2 table tr td:nth-child(2) b")?.text)!)
        newComment.voteDown = Int((commentHTML.at_css("tr:nth-child(5) td.te2 table tr td:nth-child(4) b")?.text)!)
        
        
        let isBestItem = commentHTML.css("tr:nth-child(4) td img")
        if isBestItem.count == 2 {
            newComment.isBest = true
        }
        

        let minusCharacterCount = newComment.content.characters.filter { $0 == "-" }.count
        
        
        
        var contentsList = newComment.content.characters.split(separator: "-")
        
        if  minusCharacterCount < 2 {
            return newComment
        }
        
        if minusCharacterCount >= 2 {
//            var content = contentsList.joined()
            
            contentsList.removeLast() // userip doesn't need now
            
            newComment.userID = String( contentsList[ contentsList.count - 1]).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            contentsList.removeLast()
            
            newComment.content = String( contentsList.joined(separator: ["-"])).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
            
        
        
//
//        let userName = commentDetailList[0].substring(to: indexOfStart!).trimmingCharacters(in: CharacterSet.whitespaces)
//        
//        let userID = commentDetailList[0].substring(from: indexOfStart!).trimmingCharacters(in: CharacterSet.whitespaces)
//        
//        newComment.userName = userName.replacingOccurrences(of: "- ", with: "")
//        newComment.userID = String(String(userID.characters.dropLast()).characters.dropFirst())
//        newComment.createAt = commentDetailList[ commentDetailList.count - 1  ]
        
        return newComment
    }
    
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //        print("didCommitNavigation");
        
        if isLoading == true {
            self.contentSize = 300
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == CellType.body.rawValue {
            return UITableViewAutomaticDimension;
        }
        
        return 60;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        if selectedCell is CommentCell {
            let userName = (selectedCell as! CommentCell).getUserName()
            commentWriteCell?.addTargetUser(userName)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        
        
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
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
        
        let voteDown = UITableViewRowAction(style: .normal, title: "비추") { (action, index) in
            print("voteDown")
//            self.commentVote(index: index, isVoteUp: false)
            
        }
        
        
        
        return [ delete , voteDown, voteUp ]
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
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
    
//# have to impletement 귀찮아서 못하겠다
    //todo
    func commentVote(index : IndexPath, isVoteUp : Bool){
        
        if SSajulClient.sharedInstance.isLogin() == false {
            let loginVC =  SSajulClient.sharedInstance.getLoginVC()
            
            self.present(loginVC, animated: true, completion: nil)
        }
        
        
//        var commentCell = self.tableView.cellForRow(at: index) as! CommentCell
//        
//        commentCell._comment
        
        let url = URL(string: SSajulClient.sharedInstance.urlForCommentYN( ))!
        
        
        
        Alamofire.request(url).responseString(encoding: String.Encoding.init(rawValue: CFStringConvertEncodingToNSStringEncoding(0x0422))  ) { response in
            
        }
    }
//    func deleteComment(){
//        let url = URL(string: SSajulClient.sharedInstance.urlForContent( ))!
//        
//        
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        
//        Alamofire.request( url)
//            .responseString(encoding: String.Encoding.init(rawValue: CFStringConvertEncodingToNSStringEncoding(0x0422))  ) { response in
//
//    }
}
