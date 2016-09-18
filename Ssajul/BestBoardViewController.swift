//
//  BestBoardViewController.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 5. 19..
//  Copyright © 2016년 youngchill. All rights reserved.
//


import UIKit
import Alamofire
import Kanna
import GoogleMobileAds
import WebKit

class BestBoardViewController: UIViewController ,UITabBarControllerDelegate , UITableViewDelegate, UITableViewDataSource,WKNavigationDelegate ,GADBannerViewDelegate {
    
    var realtimeBestList = [Item]()
    var todayBestList = [Item]()
    var commentBestList = [Item]()
    
    var bestItemList = [Item]()
    
    var refreshControl : UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
//    @IBOutlet weak var nativeExpressAdvieW: GADNativeExpressAdView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview( self.refreshControl)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 53
        
        
        setUpAdmob()
        
        
//        self.nativeExpressAdvieW.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.navigationItem.rightBarButtonItem?.enabled = false
        self.tabBarController?.delegate = self;
        loadingContent()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func handleRefresh(refreshControl : UIRefreshControl){
        self.loadingContent()
        refreshControl.endRefreshing()
    }
    
    func setUpAdmob(){
        dispatch_async(dispatch_get_main_queue()) {
            self.bannerView.delegate = self
            self.bannerView.adUnitID = "ca-app-pub-8030062085508715/2541766586"
            self.bannerView.rootViewController = self
            self.bannerView.loadRequest(GADRequest())
        }
        
    }
    
    
//    func setUpAdmob(){
//        
//        nativeExpressAdvieW!.adUnitID = "ca-app-pub-8030062085508715/2596335385"
//        nativeExpressAdvieW!.rootViewController = self
//        
//        let request = GADRequest()
//        //request.testDevices = [kGADSimulatorID]
//        nativeExpressAdvieW!.loadRequest(request)
//        
//        //        self.nativeExpressAdview.ad
//        //        self.nativeExpressAdview.adUnitID = "ca-app-pub-8030062085508715/2596335385"
//        //        self.nativeExpressAdview.rootViewController = self
//        //
//        //        let request = GADRequest()
//        //        self.nativeExpressAdview.loadRequest(request)
//        
//    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        self.tableView.setContentOffset(CGPoint.zero, animated:true)
    }
    

    
    // MARK: - Table view data source
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return realtimeBestList.count
        case 1:
            return todayBestList.count
        case 2:
            return commentBestList.count
        default:
            return 0
        }
        
        
    }
    
    //    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        var returnedView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 18)) //set these values as necessary
    //        returnedView.backgroundColor = UIColor.redColor()
    //
    //        var label = UILabel(frame: CGRectMake(10, 5, tableView.frame.size.width, 18))
    //        label.text = "dd"
    //        returnedView.addSubview(label)
    //
    //        return returnedView
    //    }
    //
    
    
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! ItemCell
        
        
        switch indexPath.section {
        case 0:
            //            cell.textLabel?.text = realtimeBestList[indexPath.row].title
            cell.setItem(realtimeBestList[indexPath.row])
        case 1:
            //            cell.textLabel?.text = todayBestList[indexPath.row].title
            cell.setItem(todayBestList[indexPath.row])
        case 2:
            //            cell.textLabel?.text = commentBestList[indexPath.row].title
            cell.setItem(commentBestList[indexPath.row])
        default:
            cell.textLabel?.text = "주영( 오류 )"
        }
        
        //        cell.textLabel?.font = UIFont.systemFontOfSize(15)
        //        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        return cell
    }
    
    //    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //
    //
    //        return UITableViewAutomaticDimension;
    //
    //    }
    
     func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title : String
        
        switch section {
        case 0:
            title = "실시간베스트"
        case 1:
            title = "Today베스트"
        case 2:
            title = "댓글 베스트"
        default:
            title = "따봉 베스트"
        }
        
        return title
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "bestItemSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow{
                
                var selectedItem : Item
                
                switch indexPath.section {
                case 0:
                    selectedItem = realtimeBestList[indexPath.row] as Item
                case 1:
                    selectedItem = todayBestList[indexPath.row] as Item
                case 2:
                    selectedItem = commentBestList[indexPath.row] as Item
                default:
                    selectedItem = realtimeBestList[indexPath.row] as Item
                }
                
                
                
                SSajulClient.sharedInstance.selectedItem = selectedItem
                
                
            }
        }
        
    }
    
    
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        SSajulClient.sharedInstance.webView2.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                                                completionHandler: { (html: AnyObject?, error: NSError?) in
                                                                    self.parsing(html as! String)
//                                                                                                                                        print(html)
        })
        
    }
    

    
    // MARK: - Admob
//    func adViewDidReceiveAd(bannerView: GADBannerView!) {
//        self.bannerView.hidden = false
//    }
    
    
    // MARK: - Parsing

    
    func loadingContent(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let url = SSajulClient.sharedInstance.urlForBoardItemList( 1 )
        
        Alamofire.request(.GET, url)
            .responseString(encoding:CFStringConvertEncodingToNSStringEncoding( 0x0422 ) ) { response in
                
                if response.result.isFailure == true{
                    
                    if ((response.result.error?.description.containsString("serialized")) == true){
                        self.loadingContentWebEngine()
                    }
                    
                    return
                }
                
                guard let htmlString = response.description as String? else {
                    return
                }
                
                self.parsing(htmlString)
                
        }
        
    }
    
    func loadingContentWebEngine(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        
        
        let url = SSajulClient.sharedInstance.urlForBoardItemList( 1 )
        SSajulClient.sharedInstance.webView2.stopLoading()
        SSajulClient.sharedInstance.webView2.loadRequest(NSURLRequest.init(URL: NSURL.init(string: url)!))
        SSajulClient.sharedInstance.webView2.navigationDelegate = self
        
    }
    
    func parsing(htmlString : String){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        let parsingBestSections = htmlString.regex("var content1 = \".*?</table>\"")
        
        
        for bestSection in parsingBestSections {
            
            
            let bestHrefList = bestSection.regex("<a.*?>.*?</a>.*?</td>")
            
            for bestHref in bestHrefList{
                
                
                var newBestItem = Item()
                
                let substractUid = bestHref.regex("<a..*uid=[0-9]+").first
                
                let indexOfUid = substractUid?.endIndex.advancedBy(-10)
                let uid = substractUid?.substringFromIndex(indexOfUid!)
                
                guard uid != nil else {
                    continue
                }
                
                
                newBestItem.uid = uid!
                newBestItem.title = bestHref.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                
                newBestItem.title = newBestItem.title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                
                //comment parsing
                if newBestItem.title.containsString("[") == false || newBestItem.title.characters.last != "]" {
                    newBestItem.commentCount = 0
                }else{
                    var indexOfCommentCount = 1
                    for char in newBestItem.title.characters.reverse() {
                        if char == "[" {
                            break;
                        }
                        indexOfCommentCount = indexOfCommentCount + 1;
                    }
                    let commentStartIndex = newBestItem.title.endIndex.advancedBy( -indexOfCommentCount )
                    let commentCountString = newBestItem.title.substringFromIndex(  commentStartIndex )
                    
                    let commentCount = String(String(commentCountString.characters.dropLast()).characters.dropFirst())
                    
                    if  let commentCountInt = Int(commentCount) {
                        newBestItem.commentCount = commentCountInt
                        //                                newBestItem.title.removeRange(Range.init(start: commentStartIndex, end: newBestItem.title.endIndex ))
                        newBestItem.title.removeRange(Range.init(commentStartIndex ..< newBestItem.title.endIndex ))
                        newBestItem.title = newBestItem.title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    }else {
                        newBestItem.commentCount = 0
                    }
                    
                }
                
                if self.realtimeBestList.count < 10 {
                    self.realtimeBestList.append(newBestItem)
                    continue
                }
                
                if self.todayBestList.count < 10 {
                    self.todayBestList.append(newBestItem)
                    continue
                }
                
                if self.commentBestList.count < 10 {
                    self.commentBestList.append(newBestItem)
                    continue
                }
                
                
            }
            
        }
        self.tableView.reloadData()
        
    }
    
}