//
//  BoardViewcontroller
//  Ssajul
//
//  Created by yunchiri on 2016. 2. 1..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit

class BoardViewcontroller: UITableViewController {

    @IBOutlet weak var uiLogin: UIBarButtonItem!
    
    var itemListViewConroller : ItemListViewConroller? = nil
    var itemViewController: ItemViewController? = nil




    
    
    
    var boardList = SSajulClient.sharedInstance.getBoardList()
    
    //[Board(name: "간호사근무편성", boardID: "soccerboard"), Board(name: "전공의근무편성", boardID: "locker")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
//        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "itemListSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedBoard = boardList[indexPath.row] as Board!
                
                let controller = segue.destinationViewController as! ItemListViewConroller
                
                controller.selectedBoard = selectedBoard
                
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let boardID = boardList[indexPath.row].name as String!
        
        cell.textLabel!.text = boardID
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            objects.removeAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
//    }


}

