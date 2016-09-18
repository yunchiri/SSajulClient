//
//  BoardViewcontroller
//  Ssajul
//
//  Created by yunchiri on 2016. 2. 1..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
import GoogleMobileAds

class BoardViewcontroller: UITableViewController{

    @IBOutlet weak var uiLogin: UIBarButtonItem!
    

    
    var itemListViewConroller : ItemListViewConroller? = nil
//    var itemViewController: ItemViewController? = nil

    
    var boardList = SSajulClient.sharedInstance.getBoardList()
    var extraBoardList = SSajulClient.sharedInstance.getExtraBoardList()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(animated: Bool) {
//        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
        loginButtonChanger()

        
    }

    func loginButtonChanger(){
        if SSajulClient.sharedInstance.isLogin() == true {
            uiLogin.title = "로그아웃"
            
            
        }else{
            uiLogin.title = "로그인"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if self.tableView.indexPathForSelectedRow?.section == 1 {
            let indexPath = self.tableView.indexPathForSelectedRow
            let selectedBoard = extraBoardList[indexPath!.row] as Board!
            let extraSiteUrl : NSURL = NSURL(string:   selectedBoard.boardID)!
            UIApplication.sharedApplication().openURL(extraSiteUrl)
            return false
        }
        
        if identifier == "loginSegue" {
            if SSajulClient.sharedInstance.isLogin() == true {
                SSajulClient.sharedInstance.logout()
                loginButtonChanger()
                return false
            }
        }
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tabbarSergue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedBoard = boardList[indexPath.row] as Board!
                SSajulClient.sharedInstance.selectedBoard = selectedBoard

            }
        }
        
      


    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return boardList.count
            
        }
        
        if section == 1 {
            return extraBoardList.count
            
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            
            let boardID = extraBoardList[indexPath.row].name as String!
            
            cell.textLabel!.text = boardID
            return cell
        }
        
        if boardList[indexPath.row].name == "ADMOBNATIVE" {
            let cell = tableView.dequeueReusableCellWithIdentifier("admobNativeCell", forIndexPath: indexPath) as! AdCell
            
            
            cell.nativeExpressAdvieW.adUnitID = "ca-app-pub-8030062085508715/2596335385"
            cell.nativeExpressAdvieW.rootViewController = self
            
            let request = GADRequest()
            //request.testDevices = [kGADSimulatorID]
            cell.nativeExpressAdvieW.loadRequest(request)
            
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let boardID = boardList[indexPath.row].name as String!
        
        cell.textLabel!.text = boardID
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if boardList[indexPath.row].name == "ADMOBNATIVE" {
            
            return 80
        }
        
        
        return UITableViewAutomaticDimension
    }
    



    

}

