//
//  BoardAdViewController.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 11. 21..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit

class BoardAdViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, AdamAdViewDelegate{



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBOutlet weak var uiLogin: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var adView: UIView!
    
    
    var itemListViewConroller : ItemListAdViewConroller? = nil
    //    var itemViewController: ItemViewController? = nil
    
    
    var boardList = SSajulClient.sharedInstance.getBoardList()
    var extraBoardList = SSajulClient.sharedInstance.getExtraBoardList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
        
        
        loginButtonChanger()
        
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if self.tableView.indexPathForSelectedRow?.section == 1 {
            let indexPath = self.tableView.indexPathForSelectedRow
            let selectedBoard = extraBoardList[indexPath!.row] as Board!
            let extraSiteUrl : URL = URL(string:   selectedBoard!.boardID)!
            UIApplication.shared.openURL(extraSiteUrl)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tabbarSergue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedBoard = boardList[indexPath.row] as Board!
                SSajulClient.sharedInstance.selectedBoard = selectedBoard
                
            }
        }
        
        
        
        
    }
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return boardList.count
            
        }
        
        if section == 1 {
            return extraBoardList.count
            
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            let boardID = extraBoardList[indexPath.row].name as String!
            
            cell.textLabel!.text = boardID
            return cell
        }
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let boardID = boardList[indexPath.row].name as String!
        
        cell.textLabel!.text = boardID
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        
        return UITableViewAutomaticDimension
    }
}


