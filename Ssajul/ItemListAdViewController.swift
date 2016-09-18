//
//  ItemListAdViewController.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 6. 29..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
import Alamofire
import Kanna
import GoogleMobileAds
import ChameleonFramework
import WebKit






class ItemListAdViewConroller: UIViewController, UITableViewDelegate, UITableViewDataSource , UITabBarControllerDelegate,UISearchBarDelegate, UISearchResultsUpdating, WKNavigationDelegate,GADBannerViewDelegate{
    
    var itemList = [Item]()
    var isLoading : Bool = false
    var isSearching : Bool = false
    //    var searchingKey : String = ""
    //    var selectedBoard : Board? = nil
    var currentPage : Int = 1
    var selectedTabbarIndex : Int = 0
    
    var uiWriteContentButton : UIBarButtonItem?
    let searchController = UISearchController(searchResultsController: nil)
    //    @IBOutlet weak var uiWriteContentButton: UIBarButtonItem!
    
    /// The interstitial ad.
//    var interstitial: GADInterstitial!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    
    var refreshControl : UIRefreshControl!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = SSajulClient.sharedInstance.selectedBoard?.name
        
        
        updateBoardList()
        
        
        
        
        self.uiWriteContentButton =  UIBarButtonItem(title: "글쓰기", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ItemListViewConroller.pushWriteViewController(_:)) );
        self.tabBarController?.navigationItem.rightBarButtonItem = uiWriteContentButton
        
        setUpTableView()
        setUpSearchBarController()
        
        setUpAdmob()
        
        
        //        loadInterstitial()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        self.tabBarController?.delegate = self;
        
        
        if SSajulClient.sharedInstance.isLogin() == true {
            self.uiWriteContentButton!.enabled = true
            
            
        }else{
            self.uiWriteContentButton!.enabled = false
        }
        
        self.tabBarController?.navigationItem.title = SSajulClient.sharedInstance.selectedBoard?.name
        
        //        if SSajulClient.sharedInstance.isShowIntertitialAfter2Hour() == true {
        //            showInterstitial()
        //        }
    }
    
    deinit{
        if let superView = searchController.view.superview{
            superView.removeFromSuperview()
        }
        
        
    }
    
    func setUpTableView(){
        
        self.refreshControl = UIRefreshControl()
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview( self.refreshControl)
        
//        
//        self.refreshControl?.addTarget(self, action: #selector(ItemListViewConroller.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)

        
        self.tableView.estimatedRowHeight = 30
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tabBarController?.tabBar.translucent = false
        self.tabBarController?.navigationController?.navigationBar.translucent = false
    }
    
    func setUpSearchBarController(){
        searchController.searchBar.delegate = self
        //        searchController.searchResultsUpdater = self
        if SSajulClient.sharedInstance.isLogin() == true {
            searchController.searchBar.scopeButtonTitles = ["제목", "필명", "아이디","내가쓴글"]
        }else{
            searchController.searchBar.scopeButtonTitles = ["제목", "필명", "아이디"]
        }
        
        
        
        //        let textFieldInsideSearchBar = searchController.searchBar.valueForKey("searchField") as? UITextField
        //        textFieldInsideSearchBar?.textColor = UIColor.whiteColor()
        
        
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSForegroundColorAttributeName : FlatBlackDark()], forState: UIControlState.Normal)
        
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSForegroundColorAttributeName : FlatWhite()], forState: UIControlState.Selected)
        
        
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        print("serarch update" + String(searchController.searchBar.selectedScopeButtonIndex))
        
        
    }
    
    // MARK: - SearchBar
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        //        searchingKey = searchBar.text!
        //        self.title = searchingKey + " 검색중"
        //        self.searchController.searchBar.placeholder = searchingKey
        isSearching = true
        currentPage = 1
        itemList.removeAll()
        updateBoardList()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        isSearching = false
        currentPage = 1
        itemList.removeAll()
        updateBoardList()
    }
    
    
    
    
    func pushWriteViewController (sender: AnyObject){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let itemWriteVC = storyboard.instantiateViewControllerWithIdentifier("itemWriteVC") as! ItemWriteViewController
        
        self.presentViewController(itemWriteVC, animated: true, completion: nil)
        
    }
    
    // MARK: - Tabbar
    

    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {

        
        if tabBarController.selectedIndex != 0 {
            selectedTabbarIndex = tabBarController.selectedIndex
            return
        }
        
        if selectedTabbarIndex != 0 {
            selectedTabbarIndex = tabBarController.selectedIndex
            return
        }
        
        if self.tableView.numberOfRowsInSection(0) > 0 {
            let indexPath = NSIndexPath(forItem: 0, inSection: 0)
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            
            if self.tableView.contentOffset.y == self.searchController.searchBar.frame.height {
                handleRefresh(self.refreshControl!)
                
            }
        }
        
    }
    
    //
    
    func handleRefresh(refreshControl : UIRefreshControl){
        currentPage = 1
        itemList.removeAll()
        updateBoardList()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning   implementation, return the number of rows
        return itemList.count
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! ItemCell
        
        
        let item = itemList[indexPath.row]
        
        cell.setItem( item)
        
        dispatch_async(dispatch_get_main_queue()) {
            cell.setItemLayout(item)
            cell.setNeedsLayout()
        }
        
        // Configure the cell...
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if itemList[indexPath.row].title == "ADMOBNATIVE" {
            
            return 80
        }
        
        
        return UITableViewAutomaticDimension
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "itemSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow{
                
                let selectedItem = itemList[indexPath.row] as Item
                
                let itemController = segue.destinationViewController as! ItemTableViewController
                
                SSajulClient.sharedInstance.selectedItem = selectedItem
                
                itemController.navigationItem.leftItemsSupplementBackButton = true
                
            }
        }
        
        if segue.identifier == "writeContentSegue"{
            
            //            print( SSajulClient.sharedInstance.selectedBoard?.name )
            
            if SSajulClient.sharedInstance.selectedBoard?.boardID == "recomboard" {
                
                let alertController = UIAlertController(title: "이 게시판에는 글 못씀", message: "아마 꾸레들이 점령한듯...", preferredStyle: UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                    //                    print("OK")
                }
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        }
    }
    
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= -40) {
            //            print("reload");
            currentPage += 1
            updateBoardList()
        }
    }
    
    
    
    
    func updateBoardList(){
        //let url = SSajulClient.sharedInstance.urlForBoardItemList( currentPage)
        var url = ""
        if isLoading == true { return }
        isLoading = true
        
        
        if self.searchController.active == true && isSearching == true {
            //print( self.searchController.searchBar.text )
            
            var searchType = ""
            
            switch self.searchController.searchBar.selectedScopeButtonIndex {
            case 0 :
                searchType = "subject"
            case 1 :
                searchType = "name"
            case 2 :
                searchType = "mem_id"
            case 3 :
                searchType = "myContent"
            default:
                searchType = "subject"
            }
            //subject
            //name
            //mem_id
            
            url = SSajulClient.sharedInstance.urlForBoardItemSearchedList(currentPage, key: self.searchController.searchBar.text! , keyfield: searchType)
        }else{
            url = SSajulClient.sharedInstance.urlForBoardItemList(currentPage)
        }
        
        //        let url = SSajulClient.sharedInstance.urlForBoardItemSearchedList(currentPage, key: "77", keyfield: "subject")
        
        //if isSearching
        
        getItemList(url)
    }
    
    func getItemListWebviewEngine(url : String){
        
        SSajulClient.sharedInstance.webView2.navigationDelegate = self
        SSajulClient.sharedInstance.webView2.loadRequest(NSURLRequest.init(URL: NSURL.init(string: url)!))
        
    }
    
    func getItemList(url : String){
        
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.GET, url)
            .responseString(encoding:CFStringConvertEncodingToNSStringEncoding( 0x0422 ) ) { response in
                
                if response.result.isFailure == true{
                    //                    self.isLoading = false
                    if ((response.result.error?.description.containsString("serialized")) == true){
                        self.getItemListWebviewEngine(url)
                    }
                    
                    return
                }
                
                self.parsing(response.description)
                
                
        }
    }
    
    func parsing(htmlString : String) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        if let doc = Kanna.HTML(html: htmlString, encoding: NSUTF8StringEncoding){
            
            guard let element : XMLElement? = doc.css("table.te2").first else {
                self.isLoading = false
                return
            }
            
            
            guard element != nil else {
                self.isLoading = false
                return
            }
            
            
            for xxx in  (element as XMLElement?)!.css("tr"){
                
                let verifyItem = xxx.toHTML as String!
                
                if verifyItem.containsString("<tr height=\"2\">"){ continue }
                
                if verifyItem.containsString("<tr height=\"20\">") {continue}
                
                if verifyItem.containsString("<td colspan=\"8\"") {continue}
                
                
                
                
                let searchCharacter: Character = "="
                let searchCharacterQueto: Character = "&"
                
                guard let href = xxx.xpath("td[2]/a/@href").first?.text as String! else {
                    continue
                }
                
                let indexOfStart = href.lowercaseString.characters.indexOf(searchCharacter)!.advancedBy(1)
                let indexOfEnd = href.lowercaseString.characters.indexOf(searchCharacterQueto)!.advancedBy(0)
                let range = Range.init(indexOfStart ..< indexOfEnd)// Range.init(start: indexOfStart, end: indexOfEnd)
                
                
                let preUid = href.substringWithRange(range)
                
                
                if self.itemList.count > 0 {
                    
                    if self.itemList.contains({ (Item) -> Bool in
                        if Item.uid == preUid { return true }
                        return false
                    }) == true {
                        continue
                    }
                    
                }
                
                var newItem = Item()
                
                newItem.uid = preUid
                
                newItem.title = xxx.xpath("td[2]").first?.text as String!
                
                newItem.title = newItem.title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                
                //comment parsing
                if newItem.title.containsString("[") == false || newItem.title.characters.last != "]" {
                    newItem.commentCount = 0
                }else{
                    var indexOfCommentCount = 1
                    for char in newItem.title.characters.reverse() {
                        if char == "[" {
                            break;
                        }
                        indexOfCommentCount = indexOfCommentCount + 1;
                    }
                    let commentStartIndex = newItem.title.endIndex.advancedBy( -indexOfCommentCount )
                    let commentCountString = newItem.title.substringFromIndex(  commentStartIndex )
                    
                    let commentCount = String(String(commentCountString.characters.dropLast()).characters.dropFirst())
                    
                    if  let commentCountInt = Int(commentCount) {
                        newItem.commentCount = commentCountInt
                        //                                newItem.title.removeRange(Range.init(start: commentStartIndex, end: newItem.title.endIndex ))
                        
                        newItem.title.removeRange(Range.init( commentStartIndex ..< newItem.title.endIndex ))
                        newItem.title = newItem.title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    }else {
                        newItem.commentCount = 0
                    }
                    
                }
                
                
                newItem.userName = xxx.xpath("td[3]").first?.text as String!
                newItem.createAt = xxx.xpath("td[4]").first?.text as String!
                
                if let readCount = Int((xxx.xpath("td[5]").first?.text)!) {
                    newItem.readCount = readCount
                }
                if let upAndDown = (xxx.xpath("td[6]").first?.text) {
                    if let voteUp = Int(upAndDown.substringToIndex( upAndDown.startIndex.advancedBy(1))) {
                        newItem.voteUp = voteUp
                    }
                    
                    if let voteDown = Int(upAndDown.substringFromIndex( upAndDown.endIndex.advancedBy(-1))){
                        newItem.voteDown = voteDown
                    }
                }
                
                
                self.itemList.append(newItem)
                
            }
            
            self.tableView.reloadData()
            self.isLoading = false
        }
    }
    
    
    //AD
//    func showInterstitial(){
//        
//        if self.interstitial == nil {
//            return
//        }
//        
//        if self.interstitial!.isReady {
//            self.interstitial.presentFromRootViewController(self)
//            SSajulClient.sharedInstance.saveShowIntertitialDateTime()
//        }
//        
//        
//    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        SSajulClient.sharedInstance.webView2.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                                                completionHandler: { (html: AnyObject?, error: NSError?) in
                                                                    self.parsing(html as! String)
                                                                    //                                                                    print(html)
        })
        
    }
    

    
    //AD
    func setUpAdmob(){
        dispatch_async(dispatch_get_main_queue()) {
            self.bannerView.delegate = self
            self.bannerView.adUnitID = "ca-app-pub-8030062085508715/2541766586"
            self.bannerView.rootViewController = self
            self.bannerView.loadRequest(GADRequest())
        }
        
    }
    
//    func loadInterstitial() {
//        self.interstitial = GADInterstitial(adUnitID: "ca-app-pub-8030062085508715/4144217788")
//        
//        
//        self.interstitial.delegate = self
//        
//        // Request test ads on devices you specify. Your test device ID is printed to the console when
//        // an ad request is made. GADInterstitial automatically returns test ads when running on a
//        // simulator.
//        self.interstitial.loadRequest(GADRequest());
//    }
//    
//    
//    
//    func interstitialDidReceiveAd(ad: GADInterstitial!) {
//        //print("receiver")
//    }
//    func interstitialDidFailToReceiveAdWithError(interstitial: GADInterstitial,
//                                                 error: GADRequestError) {
//        //print("\(#function): \(error.localizedDescription)")
//    }
//    
//    func interstitialDidDismissScreen(interstitial: GADInterstitial) {
//        //        print(#function)
//        //        startNewGame()
//    }
    
    
}
