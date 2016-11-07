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
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview( self.refreshControl)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 53
        
        
        setUpAdmob()
        
        
//        self.nativeExpressAdvieW.hidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = false
        self.tabBarController?.delegate = self;
        loadingContent()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func handleRefresh(_ refreshControl : UIRefreshControl){
        self.loadingContent()
        refreshControl.endRefreshing()
    }
    
    func setUpAdmob(){
        DispatchQueue.main.async {
            self.bannerView.delegate = self
            self.bannerView.adUnitID = "ca-app-pub-8030062085508715/2541766586"
            self.bannerView.rootViewController = self
            self.bannerView.load(GADRequest())
        }
        
    }
    

    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.tableView.setContentOffset(CGPoint.zero, animated:true)
    }
    

    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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

    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        
        
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
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        SSajulClient.sharedInstance.webView2.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                                                completionHandler: { (html: AnyObject?, error: NSError?) in
                                                                    self.parsing(html as! String)
//                                                                                                                                        print(html)
        })
        
    }
    

    
    // MARK: - Parsing

    
    func loadingContent(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
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
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        
        let url = SSajulClient.sharedInstance.urlForBoardItemList( 1 )
        SSajulClient.sharedInstance.webView2.stopLoading()
        SSajulClient.sharedInstance.webView2.load(URLRequest.init(url: URL.init(string: url)!))
        SSajulClient.sharedInstance.webView2.navigationDelegate = self
        
    }
    
    func parsing(_ htmlString : String){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let parsingBestSections = htmlString.regex("var content1 = \".*?</table>\"")
        
        
        for bestSection in parsingBestSections {
            
            
            let bestHrefList = bestSection.regex("<a.*?>.*?</a>.*?</td>")
            
            for bestHref in bestHrefList{
                
                
                var newBestItem = Item()
                
                let substractUid = bestHref.regex("<a..*uid=[0-9]+").first
                
                let indexOfUid = substractUid?.characters.index((substractUid?.endIndex)!, offsetBy: -10)
                let uid = substractUid?.substring(from: indexOfUid!)
                
                guard uid != nil else {
                    continue
                }
                
                
                newBestItem.uid = uid!
                newBestItem.title = bestHref.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                
                newBestItem.title = newBestItem.title.trimmingCharacters(in: CharacterSet.whitespaces)
                
                //comment parsing
                if newBestItem.title.contains("[") == false || newBestItem.title.characters.last != "]" {
                    newBestItem.commentCount = 0
                }else{
                    var indexOfCommentCount = 1
                    for char in newBestItem.title.characters.reversed() {
                        if char == "[" {
                            break;
                        }
                        indexOfCommentCount = indexOfCommentCount + 1;
                    }
                    let commentStartIndex = newBestItem.title.characters.index(newBestItem.title.endIndex, offsetBy: -indexOfCommentCount)
                    let commentCountString = newBestItem.title.substring(  from: commentStartIndex )
                    
                    let commentCount = String(String(commentCountString.characters.dropLast()).characters.dropFirst())
                    
                    if  let commentCountInt = Int(commentCount) {
                        newBestItem.commentCount = commentCountInt
                        //                                newBestItem.title.removeRange(Range.init(start: commentStartIndex, end: newBestItem.title.endIndex ))
                        newBestItem.title.removeSubrange(Range.init(commentStartIndex ..< newBestItem.title.endIndex ))
                        newBestItem.title = newBestItem.title.trimmingCharacters(in: CharacterSet.whitespaces)
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
