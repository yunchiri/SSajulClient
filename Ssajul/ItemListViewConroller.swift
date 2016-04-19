//
//  ItemListViewConroller.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 2. 23..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
import Alamofire
import Kanna




class ItemListViewConroller: UITableViewController {

    var itemList = [Item]()
//    var selectedBoard : Board? = nil
    var currentPage : Int = 1
    
    var uiWriteContentButton : UIBarButtonItem?
    
//    @IBOutlet weak var uiWriteContentButton: UIBarButtonItem!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = SSajulClient.sharedInstance.selectedBoard?.name
        
        
//        self.refreshControl?.addTarget(self, action: #selector(ItemListViewConroller.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl?.addTarget(self, action: #selector(ItemListViewConroller.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        updateBoardList()
        
        
        self.tableView.estimatedRowHeight = 30
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tabBarController?.tabBar.translucent = false
        self.tabBarController?.navigationController?.navigationBar.translucent = false
        
        self.uiWriteContentButton =  UIBarButtonItem(title: "글쓰기", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ItemListViewConroller.pushWriteViewController(_:)) );
        self.tabBarController?.navigationItem.rightBarButtonItem = uiWriteContentButton

  
    }
    
    func pushWriteViewController (sender: AnyObject){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let itemWriteVC = storyboard.instantiateViewControllerWithIdentifier("itemWriteVC") as! ItemWriteViewController
        
        self.presentViewController(itemWriteVC, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        

        
        if SSajulClient.sharedInstance.isLogin() == true {
            self.uiWriteContentButton!.enabled = true
            
            
        }else{
            self.uiWriteContentButton!.enabled = false
        }


//        self.tabBarController?.navigationController?.navigationItem.leftBarButtonItem = uiWriteContentButton
        
        self.tabBarController?.navigationItem.title = SSajulClient.sharedInstance.selectedBoard?.name
        
        
        
    }
    
    

    
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning   implementation, return the number of rows
        return itemList.count
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! ItemCell
        
        
        let item = itemList[indexPath.row]
        cell.setItem( item)
        // Configure the cell...
        return cell
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
                
                
//                itemController.selectedBoard = selectedBoard
//                itemController.selectedItem = selectedItem
                
                //SSajulClient.sharedInstance.selectedBoard = selectedBoard
                SSajulClient.sharedInstance.selectedItem = selectedItem
                
                itemController.navigationItem.leftItemsSupplementBackButton = true
                
            }
        }
        
        if segue.identifier == "writeContentSegue"{
        
            print( SSajulClient.sharedInstance.selectedBoard?.name )
            
            if SSajulClient.sharedInstance.selectedBoard?.boardID == "recomboard" {
                
                let alertController = UIAlertController(title: "이 게시판에는 글 못씀", message: "아마 꾸레들이 점령한듯...", preferredStyle: UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                    print("OK")
                }
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        }
    }


    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= -40) {
            print("reload");
            currentPage += 1
            updateBoardList()
        }
    }
    
 
    
    func updateBoardList(){
        
        let url = SSajulClient.sharedInstance.urlForBoardItemList( currentPage)
        
        Alamofire.request(.GET, url)
            .responseString(encoding:CFStringConvertEncodingToNSStringEncoding( 0x0422 ) ) { response in

                if let doc = Kanna.HTML(html: response.description, encoding: NSUTF8StringEncoding){
                    
                    let element : XMLElement? = doc.css("table.te2").first
                    
                    
                    
                    for xxx in  (element as XMLElement?)!.css("tr"){
        
                        let verifyItem = xxx.toHTML as String!
                        
                        if verifyItem.containsString("<tr height=\"2\">"){ continue }
                        
                        if verifyItem.containsString("<tr height=\"20\">") {continue}

                        if verifyItem.containsString("<td colspan=\"8\"") {continue}

                        
                        
                        
                        let searchCharacter: Character = "="
                        let searchCharacterQueto: Character = "&"
                        
                        let href = xxx.xpath("td[2]/a/@href").first?.text as String!
                        
                        let indexOfStart = href.lowercaseString.characters.indexOf(searchCharacter)!.advancedBy(1)
                        let indexOfEnd = href.lowercaseString.characters.indexOf(searchCharacterQueto)!.advancedBy(0)
                        let range = Range.init(start: indexOfStart, end: indexOfEnd)
                        
                        let preUid = href.substringWithRange(range)
                        
//                        newItem.uid = href.substringWithRange(range)
                        
                        if self.itemList.count > 0 {
                            
                            if self.itemList.contains({ (Item) -> Bool in
                                if Item.uid == preUid { return true }
                                return false
                            }) == true {
                                print("exist uid")
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
                            newItem.commentCount = Int(commentCount)!
                            
                            
                            newItem.title.removeRange(Range.init(start: commentStartIndex, end: newItem.title.endIndex ))
                            newItem.title = newItem.title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())                            
                        }
                        
                        
                        newItem.userName = xxx.xpath("td[3]").first?.text as String!
                        
                        newItem.createAt = xxx.xpath("td[4]").first?.text as String!
                        
                        if let readCount = Int((xxx.xpath("td[5]").first?.text)!) {
                            newItem.readCount = readCount
                        }
                        
                        //div comment

                        
                        let upAndDown = (xxx.xpath("td[6]").first?.text)!
                        
                        newItem.voteUp = Int(upAndDown.substringToIndex( upAndDown.startIndex.advancedBy(1)))!
                        newItem.voteDown = Int(upAndDown.substringFromIndex( upAndDown.endIndex.advancedBy(-1)))!
                        
                        
                        self.itemList.append(newItem)
                        
                    }
                    self.tableView.reloadData()
                    
                }
                
        }
        
    }
    
}
