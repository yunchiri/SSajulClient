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
    var selectedBoard : Board? = nil
    var currentPage : Int = 1
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    
        

        updateBoardList()
        
        self.tableView.estimatedRowHeight = 30
         self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
  
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
        
        
        
//        cell.textLabel!.text = itemList[indexPath.row].title
        
        cell.content.text = itemList[indexPath.row].title
        cell.userName.text = itemList[indexPath.row].userName
        cell.createAt.text = itemList[indexPath.row].createAt
        
        // Configure the cell...
        
        
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    5tl
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        if segue.identifier == "itemSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow{

                let selectedItem = itemList[indexPath.row] as Item
                
                let itemController = segue.destinationViewController as! ItemTableViewController
                
                
                itemController.selectedBoard = selectedBoard
                itemController.selectedItem = selectedItem
                itemController.navigationItem.leftItemsSupplementBackButton = true
                
            }
        }
    }


    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= -40) {
            print("reload");
            currentPage++
            updateBoardList()
        }
    }
    
 
    
    func updateBoardList(){

        let boardId = selectedBoard?.boardID
        
        let url = String(format:  "http://www.soccerline.co.kr/slboard/list.php?page=%d&code=%@&keyfield=&key=&period=&", currentPage, boardId!)

        Alamofire.request(.GET, url)
            .responseString(encoding:CFStringConvertEncodingToNSStringEncoding( 0x0422 ) ) { response in

                if let doc = Kanna.HTML(html: response.description, encoding: NSUTF8StringEncoding){
                    
                    let element : XMLElement? = doc.css("table.te2").first
                    
                    for xxx in  (element as XMLElement?)!.css("tr"){
        
                        let verifyItem = xxx.toHTML as String!
                        
                        if verifyItem.containsString("<tr height=\"2\">"){ continue }
                        
                        if verifyItem.containsString("<tr height=\"20\">") {continue}
                        
                        
                        let newItem = Item()
                        
                        //print( xxx.xpath("td[1]").first?.text ) // do nothing

                        let searchCharacter: Character = "="
                        let searchCharacterQueto: Character = "&"
                        
                        let href = xxx.xpath("td[2]/a/@href").first?.text as String!
                        
//                        if href.lowercaseString.characters.contains(searchCharacter) {
//                            print("word contains \(searchCharacter)")
//                        }
                        
                        let indexOfStart = href.lowercaseString.characters.indexOf(searchCharacter)!.advancedBy(1)
                        let indexOfEnd = href.lowercaseString.characters.indexOf(searchCharacterQueto)!.advancedBy(0)
                        let range = Range.init(start: indexOfStart, end: indexOfEnd)
                        
                        
                        newItem.uid = href.substringWithRange(range)
                        
                        newItem.title = xxx.xpath("td[2]").first?.text as String!
                        
                        newItem.userName = xxx.xpath("td[3]").first?.text as String!
                        
                        newItem.createAt = xxx.xpath("td[4]").first?.text as String!

                        newItem.readCount = Int((xxx.xpath("td[5]").first?.text)!)!
                        
                        let upAndDown = (xxx.xpath("td[6]").first?.text)!
                        
                        
                        
                        print("(")
                        print(  upAndDown.substringFromIndex( upAndDown.startIndex.advancedBy(1)) )
                        print("<>")
                        print(  upAndDown.substringToIndex( upAndDown.endIndex.advancedBy(-1)) )
                        print(")")
                        self.itemList.append(newItem)
                        
                    }
                    self.tableView.reloadData()
                    
                }
                
        }
        
    }
    
}
