//
//  HistoryTableViewController.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 4. 20..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
import RealmSwift
import BTNavigationDropdownMenu

class HistoryTableViewController: UITableViewController {
    
    
    var menuView: BTNavigationDropdownMenu!
    var historyList = List<History>()
    //var historyx : History
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "2"
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.contentInset = UIEdgeInsetsMake( 0, 50, 0, 0)
        //        self.title = SSajulClient.sharedInstance.selectedItem?.title
        setUp()
        //        loadingContent()
        
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.tabBarController?.navigationItem.rightBarButtonItem?.enabled = false
    }
    
    func setUp(){
        let items = ["즐겨찾기", "최근 본글", "나의 댓글"]
        //self.selectedCellLabel.text = items.first
        self.navigationController?.navigationBar.translucent = false
        //        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: items[1], items: items)
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        //        menuView.cellSelectionColor = UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
        menuView.keepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.blackColor()
        //        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.cellTextLabelAlignment = .Left // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            //            self.selectedCellLabel.text = items[indexPath]
        }
        
        self.navigationItem.titleView = menuView
//        self.tabBarController?.navigationItem.titleView = menuView
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
        
        
        //cell.textLabel?.text = historyList[indexPath.row].title
        
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
                
//                var item = Item()
                
                //                item.uid =
                //                SSajulClient.sharedInstance.selectedItem =
                
                
            }
        }
    }
    
    func loadingContent(){
        let realm = try! Realm();
        //        self.historyList = realm.objects(History)
        var historyList = realm.objects(History)
        
        for ii in historyList {
            print( (ii as History).title )
        }
        
        
        
    }
    
    
}
