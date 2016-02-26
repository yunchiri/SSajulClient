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
    var currentPage : Int = 0
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateBoardList()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
  
    }
    override func viewWillAppear(animated: Bool) {
        
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
                
                let itemController = segue.destinationViewController as! ItemViewController
                
                
                itemController.selectedBoard = selectedBoard
                itemController.selectedItem = selectedItem
                itemController.navigationItem.leftItemsSupplementBackButton = true
                
            }
        }
    }


    
    
    
    func updateBoardList(){

        
        //SSajulClient.sharedInstance.getItemList( sb , page: 1)
        
        //let url = "http://www.soccerline.co.kr/slboard/list.php?page=2&code=soccerboard&keyfield=&key=&period=&"
        
        let boardId = selectedBoard?.boardID
        
        let url = String(format:  "http://www.soccerline.co.kr/slboard/list.php?page=1&code=%@&keyfield=&key=&period=&",  boardId!)
        
//        //NSUTF8StringEncoding
        
        Alamofire.request(.GET, url)
            .responseString(encoding:CFStringConvertEncodingToNSStringEncoding( 0x0422 ) ) { response in
                //print(response.description)
//                if let doc = Kanna.HTML(html: response.result.value!, encoding: CFStringConvertEncodingToNSStringEncoding( 0x0422 ) ){
                if let doc = Kanna.HTML(html: response.description, encoding: NSUTF8StringEncoding){
                    
                    let element : XMLElement? = doc.css(("table.te2 , table.te2.a")).first
                    
                    print( element?.text)
                    
                    
                    let elements : XMLNodeSet = (element?.css("tr"))!
                    
                    for item in elements{

                        
                        let verifyItem = item.toHTML as String!
                        
                        if verifyItem.containsString("<tr height=\"2\">"){ continue }

                        if verifyItem.containsString("<tr height=\"20\">") {continue}
                        
                        
                        var parsingCnt = 1
                        
                        var itemId : String = ""
                        var itemTitle : String = ""
                        var itemUserName : String = ""
                        var itemDate : String = ""
                        var itemReadCount : Int = 0
                        var itemVoteUP : Int = 0
                        var itemVoteDown : Int = 0
                        

                        for model : XMLElement in item.css("td"){
                           
                           
                            if parsingCnt == 1 {
                                itemId = model.text!
                                
                            }
                            
                            if parsingCnt == 2 {
                                itemTitle = model.text!
                            }
                            
                            if parsingCnt == 3 {
                                itemUserName = model.text!
                            }
                            
                            if parsingCnt == 4 {
                                itemDate = model.text!
                            }
                            
                            if parsingCnt == 5 {
                                itemReadCount = 0
                            }
                            
                            if parsingCnt == 6 {
                                itemVoteUP = 0
                                itemVoteDown = 0
                            }
                            
                            if parsingCnt == 6 {
                                let newItem = Item()
                                
                                
                                newItem.id = itemId
                                newItem.title = itemTitle
                                newItem.userName = itemUserName
                                newItem.createAt = itemDate
                                newItem.readCount = itemReadCount
                                newItem.voteUp = itemVoteUP
                                newItem.voteDown = itemVoteDown
                                
                                parsingCnt = 0
                                self.itemList.append(newItem)
                            }
                            
                            parsingCnt++
                            continue
                        }
                        
                    }
                    self.tableView.reloadData()
                    
                    
                
                }
                
                
                
                
        }
        

        
        
    }
    
}
