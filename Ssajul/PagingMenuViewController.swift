 //
//  PagingMenuViewController.swift
//  PagingMenuControllerDemo
//
//  Created by Yusuke Kita on 5/17/16.
//  Copyright © 2016 kitasuke. All rights reserved.
//

import UIKit
import PagingMenuController
import ChameleonFramework
import GoogleMobileAds

class PagingMenuViewController: UIViewController {
    var options = PagingMenuOptions()
    var isEditingMode = false
    
    @IBOutlet weak var nativeExpressAdvieW: GADNativeExpressAdView?
    
    @IBAction func editingTableView(sender: AnyObject) {
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
        
        
        pagingMenuController.currentViewController.setEditing(!isEditingMode, animated: true)
        
        isEditingMode = !isEditingMode
        
        if isEditingMode == true {
            removeAllDataButton.enabled = true
        }else{
            removeAllDataButton.enabled = false
        }
        
    }
    
    @IBOutlet weak var removeAllDataButton: UIBarButtonItem!
    
    @IBAction func removeAllData(sender: AnyObject) {
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController

        (pagingMenuController.currentViewController as! HistoryTableViewBase).removeAllItem()
        removeAllDataButton.enabled = false
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let readVC = HistoryOfReadController.instantiateFromStoryboard()
        let favoriteVC = HistoryOfFavoriteController.instantiateFromStoryboard()
        let commentVC = HistoryOfCommentController.instantiateFromStoryboard()
        //usersViewController.menuItemDescription = menuItemDescription
        
        let viewControllers = [readVC,favoriteVC,commentVC]
        
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
        pagingMenuController.delegate = self
        
        
//        options.backgroundColor = FlatYellow()
//        options.selectedBackgroundColor = FlatYellow()
//        options.textColor = FlatWhite()
//        options.selectedTextColor = FlatBlackDark()
        options.menuPosition = .Bottom
        
        
        options.menuItemMode = .Underline(height: 4, color: FlatLime(), horizontalPadding: 0, verticalPadding: 0)
        
        switch options.menuComponentType {
        case .All, .MenuController:
            pagingMenuController.setup(viewControllers, options: options)
        case .MenuView:
            pagingMenuController.setup(viewControllers.map { $0.title! }, options: options)
        

        }
        
        setUpAdmob()
    }
    
    func setUpAdmob(){

        nativeExpressAdvieW!.adUnitID = "ca-app-pub-8030062085508715/2596335385"
        nativeExpressAdvieW!.rootViewController = self
        
        let request = GADRequest()
        //request.testDevices = [kGADSimulatorID]
        nativeExpressAdvieW!.loadRequest(request)

        
    }
}

extension PagingMenuViewController: PagingMenuControllerDelegate {
    // MARK: - PagingMenuControllerDelegate

    func willMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {
        
        
    }

    func didMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {
        
        previousMenuController.setEditing(false, animated: false)
        isEditingMode = false
        removeAllDataButton.enabled = false
    }
}