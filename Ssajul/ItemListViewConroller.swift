////
////  ItemListViewConroller.swift
////  Ssajul
////
////  Created by yunchiri on 2016. 2. 23..
////  Copyright © 2016년 youngchill. All rights reserved.
////
//
//import UIKit
//import Alamofire
//import Kanna
//import GoogleMobileAds
//import ChameleonFramework
//import WebKit
//
//struct searchController{
//    
//}
//
//
//class ItemListViewConroller: UITableViewController , UITabBarControllerDelegate,UISearchBarDelegate, UISearchResultsUpdating, WKNavigationDelegate,GADInterstitialDelegate{
//    
//    var itemList = [Item]()
//    var isLoading : Bool = false
//    var isSearching : Bool = false
////    var searchingKey : String = ""
//    //    var selectedBoard : Board? = nil
//    var currentPage : Int = 1
//    
//    var uiWriteContentButton : UIBarButtonItem?
//    let searchController = UISearchController(searchResultsController: nil)
//    //    @IBOutlet weak var uiWriteContentButton: UIBarButtonItem!
//    
//    /// The interstitial ad.
//    var interstitial: GADInterstitial!
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//        self.title = SSajulClient.sharedInstance.selectedBoard?.name
//
//
//        updateBoardList()
//        
//        
//        
//        
//        self.uiWriteContentButton =  UIBarButtonItem(title: "글쓰기", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ItemListViewConroller.pushWriteViewController(_:)) );
//        self.tabBarController?.navigationItem.rightBarButtonItem = uiWriteContentButton
//        
//        setUpTableView()
//        setUpSearchBarController()
//        
//
//        
////        loadInterstitial()
//
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        //        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
//        super.viewWillAppear(animated)
//        self.tabBarController?.delegate = self;
//        
//        
//        if SSajulClient.sharedInstance.isLogin() == true {
//            self.uiWriteContentButton!.isEnabled = true
//            
//            
//        }else{
//            self.uiWriteContentButton!.isEnabled = false
//        }
//        
//        self.tabBarController?.navigationItem.title = SSajulClient.sharedInstance.selectedBoard?.name
//        
////        if SSajulClient.sharedInstance.isShowIntertitialAfter2Hour() == true {
////            showInterstitial()
////        }
//    }
//    
//    deinit{
//        if let superView = searchController.view.superview{
//            superView.removeFromSuperview()
//        }
//        
//        
//    }
//    
//    func setUpTableView(){
//
//        
//        self.refreshControl?.addTarget(self, action: #selector(ItemListViewConroller.handleRefresh(_:)), for: UIControlEvents.valueChanged)
//        self.tableView.estimatedRowHeight = 30
//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        
//        self.tabBarController?.tabBar.isTranslucent = false
//        self.tabBarController?.navigationController?.navigationBar.isTranslucent = false
//    }
//    
//    func setUpSearchBarController(){
//        searchController.searchBar.delegate = self
////        searchController.searchResultsUpdater = self
//        if SSajulClient.sharedInstance.isLogin() == true {
//            searchController.searchBar.scopeButtonTitles = ["제목", "필명", "아이디","내가쓴글"]
//        }else{
//            searchController.searchBar.scopeButtonTitles = ["제목", "필명", "아이디"]
//        }
//        
//        
//        
////        let textFieldInsideSearchBar = searchController.searchBar.valueForKey("searchField") as? UITextField
////        textFieldInsideSearchBar?.textColor = UIColor.whiteColor()
//        
//        
//        searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSForegroundColorAttributeName : FlatBlackDark()], for: UIControlState.normal)
//        
//        searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSForegroundColorAttributeName : FlatWhite()], for: UIControlState.selected)
//        
//        
//        searchController.obscuresBackgroundDuringPresentation = false
//
//        searchController.searchBar.sizeToFit()
//        
//        self.tableView.tableHeaderView = searchController.searchBar
//    }
//    
//    func updateSearchResults(for searchController: UISearchController) {
//        print("serarch update" + String(searchController.searchBar.selectedScopeButtonIndex))
//        
//        
//    }
//
//    // MARK: - SearchBar
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
////        searchingKey = searchBar.text!
////        self.title = searchingKey + " 검색중"
////        self.searchController.searchBar.placeholder = searchingKey
//        isSearching = true
//        currentPage = 1
//        itemList.removeAll()
//        updateBoardList()
//    }
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        isSearching = false
//        currentPage = 1
//        itemList.removeAll()
//        updateBoardList()
//    }
//    
//    
//    
//    
//    func pushWriteViewController (_ sender: AnyObject){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        let itemWriteVC = storyboard.instantiateViewController(withIdentifier: "itemWriteVC") as! ItemWriteViewController
//        
//        self.present(itemWriteVC, animated: true, completion: nil)
//        
//    }
//    
//    // MARK: - Tabbar
//    
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if self.tableView.numberOfRows(inSection: 0) > 0 {
//            let indexPath = IndexPath(item: 0, section: 0)
//            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
//            
//            if self.tableView.contentOffset.y == self.searchController.searchBar.frame.height {
//                handleRefresh(self.refreshControl!)
//                
//            }
//        }
//    }
//    
//    //
//    
//    func handleRefresh(_ refreshControl : UIRefreshControl){
//        currentPage = 1
//        itemList.removeAll()
//        updateBoardList()
//        self.tableView.reloadData()
//        refreshControl.endRefreshing()
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    // MARK: - Table view data source
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning   implementation, return the number of rows
//        return itemList.count
//        
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        
//        
//        
//        if itemList[indexPath.row].title == "ADMOBNATIVE" {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "admobNativeCell", for: indexPath) as! AdCell
//            
//            
//            cell.nativeExpressAdvieW.adUnitID = "ca-app-pub-8030062085508715/2596335385"
//            cell.nativeExpressAdvieW.rootViewController = self
//            
//            let request = GADRequest()
//            //request.testDevices = [kGADSimulatorID]
//            cell.nativeExpressAdvieW.load(request)
//            
//            return cell
//        }
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
//        
//        
//        let item = itemList[indexPath.row]
//        cell.setItem( item)
//        // Configure the cell...
//        return cell
//    }
//    
//
//    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    
//        if itemList[indexPath.row].title == "ADMOBNATIVE" {
//
//            return 80
//        }
//        
//        
//        return UITableViewAutomaticDimension
//    }
//    
//    
//    // MARK: - Navigation
//    
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "itemSegue" {
//            if let indexPath = self.tableView.indexPathForSelectedRow{
//                
//                let selectedItem = itemList[indexPath.row] as Item
//                
//                let itemController = segue.destination as! ItemTableViewController
//                
//                SSajulClient.sharedInstance.selectedItem = selectedItem
//                
//                itemController.navigationItem.leftItemsSupplementBackButton = true
//                
//            }
//        }
//        
//        if segue.identifier == "writeContentSegue"{
//            
//            //            print( SSajulClient.sharedInstance.selectedBoard?.name )
//            
//            if SSajulClient.sharedInstance.selectedBoard?.boardID == "recomboard" {
//                
//                let alertController = UIAlertController(title: "이 게시판에는 글 못씀", message: "아마 꾸레들이 점령한듯...", preferredStyle: UIAlertControllerStyle.alert)
//                
//                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
////                    print("OK")
//                }
//                alertController.addAction(okAction)
//                self.present(alertController, animated: true, completion: nil)
//                
//            }
//        }
//    }
//    
//    
//    
//    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let currentOffset = scrollView.contentOffset.y;
//        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
//        
//        if (maximumOffset - currentOffset <= -40) {
//            //            print("reload");
//            currentPage += 1
//            updateBoardList()
//        }
//    }
//    
//    
//
//
//    func updateBoardList(){
//        //let url = SSajulClient.sharedInstance.urlForBoardItemList( currentPage)
//        var url = ""
//        if isLoading == true { return }
//        isLoading = true
//        
//        
//        if self.searchController.isActive == true && isSearching == true {
//            //print( self.searchController.searchBar.text )
//            
//            var searchType = ""
//            
//            switch self.searchController.searchBar.selectedScopeButtonIndex {
//            case 0 :
//                searchType = "subject"
//            case 1 :
//                searchType = "name"
//            case 2 :
//                searchType = "mem_id"
//            case 3 :
//                searchType = "myContent"
//            default:
//                searchType = "subject"
//            }
//            //subject
//            //name
//            //mem_id
//            
//            url = SSajulClient.sharedInstance.urlForBoardItemSearchedList(currentPage, key: self.searchController.searchBar.text! , keyfield: searchType)
//        }else{
//            url = SSajulClient.sharedInstance.urlForBoardItemList(currentPage)
//        }
//
////        let url = SSajulClient.sharedInstance.urlForBoardItemSearchedList(currentPage, key: "77", keyfield: "subject")
//        
//        //if isSearching
//        
//        getItemList(url)
//    }
//    
//    func getItemListWebviewEngine(_ url : String){
//        
//        SSajulClient.sharedInstance.webView2.navigationDelegate = self
//        SSajulClient.sharedInstance.webView2.load(URLRequest.init(url: URL.init(string: url)!))
//        
//    }
//    
//    func getItemList(_ url : String){
//        
//        
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        Alamofire.request( url)
//            .responseString(encoding:CFStringConvertEncodingToNSStringEncoding(CFStringEncoding.init(0x0422)) ) { response in
//                
//                if response.result.isFailure == true{
////                    self.isLoading = false
//                    if ((response.result.error?.description.containsString("serialized")) == true){
//                        self.getItemListWebviewEngine(url)
//                    }
//                    
//                    return
//                }
//                
//                self.parsing(response.description)
//                
//                
//        }
//    }
//    
//    func parsing(_ htmlString : String) {
//        
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        
//        if let doc = Kanna.HTML(html: htmlString, encoding: String.Encoding.utf8){
//            
//            guard let element : XMLElement? = doc.css("table.te2").first else {
//                self.isLoading = false
//                return
//            }
//            
//            
//            guard element != nil else {
//                self.isLoading = false
//                return
//            }
//            
//            
//            for xxx in  (element as XMLElement?)!.css("tr"){
//                
//                let verifyItem = xxx.toHTML as String!
//                
//                if (verifyItem?.contains("<tr height=\"2\">"))!{ continue }
//                
//                if (verifyItem?.contains("<tr height=\"20\">"))! {continue}
//                
//                if (verifyItem?.contains("<td colspan=\"8\""))! {continue}
//                
//                
//                
//                
//                let searchCharacter: Character = "="
//                let searchCharacterQueto: Character = "&"
//                
//                guard let href = xxx.xpath("td[2]/a/@href").first?.text as String! else {
//                    continue
//                }
//                
//                let indexOfStart = href.lowercased().characters.index(of: searchCharacter)!.advancedBy(1)
//                let indexOfEnd = href.lowercased().characters.index(of: searchCharacterQueto)!.advancedBy(0)
//                let range = Range.init(indexOfStart ..< indexOfEnd)// Range.init(start: indexOfStart, end: indexOfEnd)
//                
//                
//                let preUid = href.substringWithRange(range)
//                
//                
//                if self.itemList.count > 0 {
//                    
//                    if self.itemList.contains(where: { (Item) -> Bool in
//                        if Item.uid == preUid { return true }
//                        return false
//                    }) == true {
//                        continue
//                    }
//                    
//                }
//                
//                var newItem = Item()
//                
//                newItem.uid = preUid
//                
//                newItem.title = xxx.xpath("td[2]").first?.text as String!
//                
//                newItem.title = newItem.title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
//                
//                //comment parsing
//                if newItem.title.containsString("[") == false || newItem.title.characters.last != "]" {
//                    newItem.commentCount = 0
//                }else{
//                    var indexOfCommentCount = 1
//                    for char in newItem.title.characters.reversed() {
//                        if char == "[" {
//                            break;
//                        }
//                        indexOfCommentCount = indexOfCommentCount + 1;
//                    }
//                    let commentStartIndex = newItem.title.endIndex.advancedBy( -indexOfCommentCount )
//                    let commentCountString = newItem.title.substringFromIndex(  commentStartIndex )
//                    
//                    let commentCount = String(String(commentCountString.characters.dropLast()).characters.dropFirst())
//                    
//                    if  let commentCountInt = Int(commentCount) {
//                        newItem.commentCount = commentCountInt
//                        //                                newItem.title.removeRange(Range.init(start: commentStartIndex, end: newItem.title.endIndex ))
//                        
//                        newItem.title.removeSubrange(Range.init( commentStartIndex ..< newItem.title.endIndex ))
//                        newItem.title = newItem.title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
//                    }else {
//                        newItem.commentCount = 0
//                    }
//                    
//                }
//                
//                
//                newItem.userName = xxx.xpath("td[3]").first?.text as String!
//                newItem.createAt = xxx.xpath("td[4]").first?.text as String!
//                
//                if let readCount = Int((xxx.xpath("td[5]").first?.text)!) {
//                    newItem.readCount = readCount
//                }
//                if let upAndDown = (xxx.xpath("td[6]").first?.text) {
//                    if let voteUp = Int(upAndDown.substringToIndex( upAndDown.startIndex.advancedBy(1))) {
//                        newItem.voteUp = voteUp
//                    }
//                    
//                    if let voteDown = Int(upAndDown.substringFromIndex( upAndDown.endIndex.advancedBy(-1))){
//                        newItem.voteDown = voteDown
//                    }
//                }
//                
//                
//                self.itemList.append(newItem)
//                
//            }
//            if itemList.count > 20 {
//                var adItem = Item()
//                adItem.title = "ADMOBNATIVE"
//
//                self.itemList.insert( adItem , at: itemList.count - 10)
//            }
//            
//            self.tableView.reloadData()
//            self.isLoading = false
//        }
//    }
//    
//    
//    //AD
//    func showInterstitial(){
//        
//        if self.interstitial == nil {
//            return
//        }
//        
//        if self.interstitial!.isReady {
//            self.interstitial.present(fromRootViewController: self)
//            SSajulClient.sharedInstance.saveShowIntertitialDateTime()
//        }
//
//        
//    }
//    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//  
//        SSajulClient.sharedInstance.webView2.evaluateJavaScript("document.documentElement.outerHTML.toString()",
//                                                                completionHandler: { (html: AnyObject?, error: NSError?) in
//                                                                    self.parsing(html as! String)
////                                                                    print(html)
//        })
//        
//    }
//    
//    
//    func loadInterstitial() {
//        self.interstitial = GADInterstitial(adUnitID: "ca-app-pub-8030062085508715/4144217788")
//        
//        
//        self.interstitial.delegate = self
//        
//        // Request test ads on devices you specify. Your test device ID is printed to the console when
//        // an ad request is made. GADInterstitial automatically returns test ads when running on a
//        // simulator.
//        self.interstitial.load(GADRequest());
//    }
//    
//    
//    
//    func interstitialDidReceiveAd(_ ad: GADInterstitial!) {
//        //print("receiver")
//    }
//    func interstitialDidFailToReceiveAdWithError(_ interstitial: GADInterstitial,
//                                                 error: GADRequestError) {
//        //print("\(#function): \(error.localizedDescription)")
//    }
//    
//    func interstitialDidDismissScreen(_ interstitial: GADInterstitial) {
//        //        print(#function)
//        //        startNewGame()
//    }
//    
//    
//}
