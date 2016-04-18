//
//  BestBoardTableViewController.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 4. 19..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
import Alamofire
import Kanna

class BestBoardTableViewController: UITableViewController {

     var realtimeBestList = [Item]()
     var todayBestList = [Item]()
     var commentBestList = [Item]()
    
    var bestItemList = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = SSajulClient.sharedInstance.selectedItem?.title
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)

        
        self.title = SSajulClient.sharedInstance.selectedItem?.title
        
        loadingContent()
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
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
 
        
        let cell = tableView.dequeueReusableCellWithIdentifier("bestCell", forIndexPath: indexPath)
        
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = realtimeBestList[indexPath.row].title
        case 1:
            cell.textLabel?.text = todayBestList[indexPath.row].title
        case 2:
            cell.textLabel?.text = commentBestList[indexPath.row].title
        default:
            cell.textLabel?.text = "주멘( 오류 )"
        }
        
        cell.textLabel?.font = UIFont.systemFontOfSize(15)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
        
//        if segue.identifier == "writeContentSegue"{
//            
//            print( SSajulClient.sharedInstance.selectedBoard?.name )
//            
//            if SSajulClient.sharedInstance.selectedBoard?.boardID == "recomboard" {
//                
//                let alertController = UIAlertController(title: "이 게시판에는 글 못씀", message: "아마 꾸레들이 점령한듯...", preferredStyle: UIAlertControllerStyle.Alert)
//                
//                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
//                    print("OK")
//                }
//                alertController.addAction(okAction)
//                self.presentViewController(alertController, animated: true, completion: nil)
//                
//            }
//        }
    }
    
    
    
    func loadingContent(){
        let url = SSajulClient.sharedInstance.urlForBoardItemList( 1 )
        
        Alamofire.request(.GET, url)
            .responseString(encoding:CFStringConvertEncodingToNSStringEncoding( 0x0422 ) ) { response in

                let htmlString = response.description
                
                let parsingBestSections = htmlString.regex("var content1 = \".*?</table>\"")
                
                
                for bestSection in parsingBestSections {
                    
                    
                    let bestHrefList = bestSection.regex("<a.*?>.*?</a>.*?</td>")
                    
                    for bestHref in bestHrefList{
                        
                        
                        var newBestItem = Item()
                        
                        let substractUid = bestHref.regex("<a..*uid=[0-9]+").first
                        
                        let indexOfUid = substractUid?.endIndex.advancedBy(-10)
                        let uid = substractUid?.substringFromIndex(indexOfUid!)
                        
                        guard uid != nil else {
                            continue
                        }
                        
                        
                        newBestItem.uid = uid!
                        newBestItem.title = bestHref.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                        
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

}
