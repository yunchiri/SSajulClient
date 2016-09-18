

//
//  HistoryOfCommentConroller
//  Ssajul
//
//  Created by yunchiri on 2016. 6. 5..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryOfCommentController: HistoryTableViewBase {
    
    var historyItemList : Results<History>? = nil
    
    class func instantiateFromStoryboard() -> HistoryOfCommentController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! HistoryOfCommentController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        getHistoryList()
        
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        guard historyItemList?.count > 0 else {
            return
        }
        self.tableView .reloadData()
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
        return historyItemList!.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! ItemCell
        
        if historyItemList == nil {
            return cell
        }
        
        let item = historyItemList![ indexPath.row ].getItem()
        
        cell.setItem( item )
        
        
        return cell
    }
    
    
    func getHistoryList(){
        let realm = try! Realm()
        let result = realm.objects(History).filter( "type == '" + HistoryType.Comment + "'" ).sorted("updateAt", ascending: false)
        historyItemList = result
        
        self.tableView.reloadData()
        
        
        
        
    }
    
    func setUpTableView(){
        
        
        self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.estimatedRowHeight = 30
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tabBarController?.tabBar.translucent = false
        self.tabBarController?.navigationController?.navigationBar.translucent = false
    }
    
    func handleRefresh(refreshControl : UIRefreshControl){
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "itemSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow{
                
                let historyItem = historyItemList![indexPath.row]
                
                SSajulClient.sharedInstance.selectedItem = historyItem.getItem()
                
                SSajulClient.sharedInstance.selectedBoard = historyItem.getBoard()
                
            }
        }
    }
    
    
    
    //     Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return true// if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            
            let realm = try! Realm()
            
            try! realm.write{
                realm.delete( historyItemList![indexPath.row ])
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            
        }
        //        } else if editingStyle == .Insert {
        //            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        //        }
    }
    
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        self.tableView.setEditing(editing, animated: animated)
    }
    
    
    override func removeAllItem(){
        let realm = try! Realm()
        realm.beginWrite()
        realm.delete(historyItemList!)
        try! realm.commitWrite()
        
        self.tableView.reloadData()
    }
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
