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
import ChameleonFramework
import WebKit





class ItemListAdViewConroller: UIViewController, UITableViewDelegate, UITableViewDataSource , UITabBarControllerDelegate,UISearchBarDelegate, UISearchResultsUpdating, WKNavigationDelegate, AdamAdViewDelegate{
    
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
    
    //@IBOutlet weak var adView: AdamAdView!
    /// The interstitial ad.
//    var interstitial: GADInterstitial!
    
    @IBOutlet weak var tableView: UITableView!

    
    @IBOutlet weak var adView: UIView!
    
    
    var refreshControl : UIRefreshControl!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationItem.title = SSajulClient.sharedInstance.selectedBoard?.name
        
        updateBoardList()
        
        self.uiWriteContentButton =  UIBarButtonItem(title: "글쓰기", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ItemListAdViewConroller.pushWriteViewController(_:)) );
        self.tabBarController?.navigationItem.rightBarButtonItem = uiWriteContentButton
        
        setUpTableView()
        setUpSearchBarController()
        
        self.tabBarController?.navigationItem.title = SSajulClient.sharedInstance.selectedBoard?.name
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        
        self.tabBarController?.delegate = self;
        
        if SSajulClient.sharedInstance.isLogin() == true {
            self.uiWriteContentButton!.isEnabled = true
        }else{
            self.uiWriteContentButton!.isEnabled = false
        }
//        self.tabBarController?.navigationItem.title = SSajulClient.sharedInstance.selectedBoard?.name
        
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
        
        self.adView.subviews.forEach { view in
            (view as! AdamAdView).delegate = nil
            view.removeFromSuperview()
        }
        
        searchController.isActive = false
    }
    
    deinit{
        if let superView = searchController.view.superview{
            superView.removeFromSuperview()
        }
        
        
    }
    

//    mark
    func didReceiveAd(_ adView: AdamAdView!) {
//        print("2")
    }
    
    func didFail(toReceiveAd adView: AdamAdView!, error: Error!) {
//        print(error)
    }
    
    func setUpTableView(){
        
        self.refreshControl = UIRefreshControl()
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview( self.refreshControl)
        
        self.tableView.estimatedRowHeight = 30
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tabBarController?.tabBar.isTranslucent = false
        self.tabBarController?.navigationController?.navigationBar.isTranslucent = false
    }
    
    func setUpSearchBarController(){
        searchController.searchBar.delegate = self
        
        searchController.automaticallyAdjustsScrollViewInsets = true
        
        if SSajulClient.sharedInstance.isLogin() == true {
            searchController.searchBar.scopeButtonTitles = ["제목", "필명", "아이디","내가쓴글"]
        }else{
            searchController.searchBar.scopeButtonTitles = ["제목", "필명", "아이디"]
        }
        
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSForegroundColorAttributeName : FlatBlackDark()], for: UIControlState.normal)
        
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSForegroundColorAttributeName : FlatWhite()], for: UIControlState.selected)
        
        
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("serarch update" + String(searchController.searchBar.selectedScopeButtonIndex))
        
    }
    
    // MARK: - SearchBar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = true
        currentPage = 1
        itemList.removeAll()
        updateBoardList()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        currentPage = 1
        itemList.removeAll()
        updateBoardList()
    }
    
    
    
    
    func pushWriteViewController (_ sender: AnyObject){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let itemWriteVC = storyboard.instantiateViewController(withIdentifier: "itemWriteVC") as! ItemWriteViewController
        
        self.present(itemWriteVC, animated: true, completion: nil)
        
    }
    
    // MARK: - Tabbar
    

    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

        
        if tabBarController.selectedIndex != 0 {
            selectedTabbarIndex = tabBarController.selectedIndex
            return
        }
        
        if selectedTabbarIndex != 0 {
            selectedTabbarIndex = tabBarController.selectedIndex
            return
        }
        
        if self.tableView.numberOfRows(inSection: 0) > 0 {
            let indexPath = IndexPath(item: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
            
            if self.tableView.contentOffset.y == self.searchController.searchBar.frame.height {
                handleRefresh(self.refreshControl!)
                
            }
        }
        
    }
    
    //
    
    func handleRefresh(_ refreshControl : UIRefreshControl){
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning   implementation, return the number of rows
        return itemList.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        
        
        let item = itemList[indexPath.row]
        
        cell.setItem( item)
        
        DispatchQueue.main.async {
            cell.setItemLayout(item)
            cell.setNeedsLayout()
        }
        
        // Configure the cell...
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if itemList[indexPath.row].title == "ADMOBNATIVE" {
            
            return 80
        }
        
        
        return UITableViewAutomaticDimension
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "itemSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow{
                
                let selectedItem = itemList[indexPath.row] as Item
                
                let itemController = segue.destination as! ContentAdViewController
                
                SSajulClient.sharedInstance.selectedItem = selectedItem
                
                itemController.navigationItem.leftItemsSupplementBackButton = true
                
            }
        }
        
        if segue.identifier == "writeContentSegue"{
            
            //            print( SSajulClient.sharedInstance.selectedBoard?.name )
            
            if SSajulClient.sharedInstance.selectedBoard?.boardID == "recomboard" {
                
                let alertController = UIAlertController(title: "이 게시판에는 글 못씀", message: "아마 꾸레들이 점령한듯...", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    //                    print("OK")
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
    }
    
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
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
        
        
        if self.searchController.isActive == true && isSearching == true {
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
    
    func getItemListWebviewEngine(_ url : String){
        
        SSajulClient.sharedInstance.webView2.navigationDelegate = self
        SSajulClient.sharedInstance.webView2.load(URLRequest.init(url: URL.init(string: url)!))
        
    }
    
    func getItemList(_ url : String){
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(url)
                .responseString(encoding: String.Encoding.init(rawValue: UInt(CFStringConvertEncodingToNSStringEncoding(0x0422)) ) ) { response in
            //.responseString(encoding:CFStringConvertEncodingToNSStringEncoding( 0x0422 ) ) { response in
                
                if response.result.isFailure == true{
                    //                    self.isLoading = false
                    if ((response.result.error.debugDescription.contains("serialized")) == true){
                    //if ((response.result.error?.description.containsString("serialized")) == true){
                        self.getItemListWebviewEngine(url)
                    }
                    
                    return
                }
                
                self.parsing(response.description)
                
                
        }
    }
    
    func parsing(_ htmlString : String) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        if let doc = Kanna.HTML(html: htmlString, encoding: String.Encoding.utf8){
            
            guard let element : XMLElement = doc.css("table.te2").first else {
                self.isLoading = false
                return
            }
            
            
            
            for xxx in  (element as XMLElement?)!.css("tr"){
                
                //let verifyItem = xxx.toHTML as String!
                
                guard let verifyItem = xxx.toHTML as String! else {
                    
                    return
                }
                if verifyItem.contains("<tr height=\"2\">"){ continue }
                
                if verifyItem.contains("<tr height=\"20\">") {continue}
                
                if verifyItem.contains("<td colspan=\"8\"") {continue}
                
                
                
                
                let searchCharacter: Character = "="
                let searchCharacterQueto: Character = "&"
                
                guard let href = xxx.xpath("td[2]/a/@href").first?.text as String! else {
                    continue
                }
                
                //let indexOfStart = href.lowercased().characters.index(of: searchCharacter)!.advancedBy(1)
                
                
                
                var indexOfStart = href.lowercased().characters.index(of: searchCharacter)
                indexOfStart = href.lowercased().characters.index(after: indexOfStart!)
                
                
                //let indexOfEnd = href.lowercased().characters.index(searchCharacterQueto, offsetBy: 0)
                let indexOfEnd = href.lowercased().characters.index(of: searchCharacterQueto)
                
                
                //18
                let preUid = href.substring(with: indexOfStart! ..< indexOfEnd!)
                
                
                if self.itemList.count > 0 {
                    if self.itemList.contains(where: { (Item) -> Bool in
                        if Item.uid == preUid { return true }
                        return false
                    }) == true {
                        continue
                    }
                    
                }
                
                var newItem = Item()
                
                newItem.uid = preUid
                
                newItem.title = xxx.xpath("td[2]").first?.text as String!
                

                newItem.title = newItem.title.trimmingCharacters(in: CharacterSet.whitespaces)
                
                //comment parsing
                if newItem.title.contains("[") == false || newItem.title.characters.last != "]" {
                    newItem.commentCount = 0
                }else{
                    var indexOfCommentCount = 1
                    for char in newItem.title.characters.reversed() {
                        if char == "[" {
                            break;
                        }
                        indexOfCommentCount = indexOfCommentCount + 1;
                    }
                   
                    //18
//                     let commentStartIndex = newItem.title.endIndex.advancedBy( -indexOfCommentCount )
                    let commentStartIndex = newItem.title.index(newItem.title.endIndex, offsetBy: -indexOfCommentCount)
//                     let commentCountString = newItem.title.substringFromIndex(  commentStartIndex )
                    let commentCountString = newItem.title.substring(from: commentStartIndex)
                    
                     let commentCount = String(String(commentCountString.characters.dropLast()).characters.dropFirst())
                    
                     if  let commentCountInt = Int(commentCount) {
                         newItem.commentCount = commentCountInt
                         //                                newItem.title.removeRange(Range.init(start: commentStartIndex, end: newItem.title.endIndex ))
                    
                         newItem.title.removeSubrange(Range.init( commentStartIndex ..< newItem.title.endIndex ))
                         //newItem.title = newItem.title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                         newItem.title = newItem.title.trimmingCharacters(in: CharacterSet.whitespaces)
                     }else {
                         newItem.commentCount = 0
                     }
                    
                }
                
                
                newItem.userName = xxx.xpath("td[3]").first?.text as String!
                newItem.createAt = xxx.xpath("td[4]").first?.text as String!
                
                if let readCount = Int((xxx.xpath("td[5]").first?.text)!) {
                    newItem.readCount = readCount
                }
                
                //upd and down sibal
                if let upAndDown = (xxx.xpath("td[6]").first?.text) {
                    if let voteUp = Int(upAndDown.substring(to: upAndDown.index(after: upAndDown.startIndex))) {
                        newItem.voteUp = voteUp
                    }
                
                    if let voteDown = Int(upAndDown.substring(from: upAndDown.index(before: upAndDown.endIndex))) {
                        newItem.voteDown = voteDown
                    }
                }
                
                
                self.itemList.append(newItem)
                
            }
            
            self.tableView.reloadData()
            self.isLoading = false
        }
    }
    

    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        // SSajulClient.sharedInstance.webView2.evaluateJavaScript("document.documentElement.outerHTML.toString()",
        //                                                         completionHandler: { (html: Any?, error: NSError?) in
        //                                                             self.parsing(html as! String)
        // })
        
        SSajulClient.sharedInstance.webView2.evaluateJavaScript("document.documentElement.outerHTML.toString()") { (html, error) in
            self.parsing(html as! String)
        }
    }
    

}
