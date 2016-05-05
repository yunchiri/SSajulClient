//
//  HistoryTableViewController.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 4. 20..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryTableViewController: UITableViewController {

    
    
    var historyList = List<History>()
    //var historyx : History
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.title = SSajulClient.sharedInstance.selectedItem?.title
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        
        //        self.title = SSajulClient.sharedInstance.selectedItem?.title
        
        loadingContent()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.navigationItem.rightBarButtonItem?.enabled = false
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func handleRefresh(refreshControl : UIRefreshControl){
        self.loadingContent()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        switch section {
//        case 0:
//            return realtimeBestList.count
//        case 1:
//            return todayBestList.count
//        case 2:
//            return commentBestList.count
//        default:
//            return 0
//        }
        return historyList.count
        
        
    }

    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath)
        
        
        

        
        cell.textLabel?.text = historyList[indexPath.row].title
        
        return cell
    }
    
    
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//        var title : String
//        
//        switch section {
//        case 0:
//            title = "실시간베스트"
//        case 1:
//            title = "Today베스트"
//        case 2:
//            title = "댓글 베스트"
//        default:
//            title = "따봉 베스트"
//        }
//        
//        return title
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "historySegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow{
                
                var item = Item()
                
//                item.uid = 
//                SSajulClient.sharedInstance.selectedItem =
                
                
            }
        }
    }
    
    func loadingContent(){
        let realm = try! Realm();
//        self.historyList = realm.objects(History)
        var historyList = realm.objects(History)
        
        
        
        
        
        
        
    }
    
        
}
