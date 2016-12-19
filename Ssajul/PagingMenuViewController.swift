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


class PagingMenuViewController: UIViewController ,AdamAdViewDelegate{
    
    var isEditingMode = false

    @IBOutlet weak var adView: UIView!
    
    @IBAction func editingTableView(_ sender: AnyObject) {
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
        
        
        //pagingMenuController.currentViewController.setEditing(!isEditingMode, animated: true)
        
        pagingMenuController.presentedViewController?.setEditing(!isEditingMode, animated: true)
        
        isEditingMode = !isEditingMode
        
        if isEditingMode == true {
            removeAllDataButton.isEnabled = true
        }else{
            removeAllDataButton.isEnabled = false
        }
        
    }
    
    @IBOutlet weak var removeAllDataButton: UIBarButtonItem!
    
    @IBAction func removeAllData(_ sender: AnyObject) {
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController

        //(pagingMenuController.currentViewController as! HistoryTableViewBase).removeAllItem()
        (pagingMenuController.pagingViewController?.currentViewController as! HistoryTableViewBase).removeAllItem()
        
        removeAllDataButton.isEnabled = false
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
        
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        


        
        struct PagingMenuuOptions : PagingMenuControllerCustomizable{
            var componentType: ComponentType{
                let readVC = HistoryOfReadController.instantiateFromStoryboard()
                let favoriteVC = HistoryOfFavoriteController.instantiateFromStoryboard()
                let commentVC = HistoryOfCommentController.instantiateFromStoryboard()

                
                struct readMenu : MenuItemViewCustomizable{
                    var displayMode: MenuItemDisplayMode{
                        return .text(title: MenuItemText(text:"읽은글") )
                    }
                }
                struct favoriteMenu : MenuItemViewCustomizable{
                    var displayMode: MenuItemDisplayMode{
                        return .text(title: MenuItemText(text:"관심글") )
                    }
                }
                struct commentMenu : MenuItemViewCustomizable{
                    var displayMode: MenuItemDisplayMode{
                        return .text(title: MenuItemText(text:"댓글단글") )
                    }
                }
                
                struct MenuOptions : MenuViewCustomizable{
                    var itemsOptions : [MenuItemViewCustomizable]{
                        return [readMenu(), favoriteMenu(), commentMenu()]
                    }
                    
                    
//                    var selectedItemCenter = false

                    var focusMode = MenuFocusMode.underline(height: 2, color: UIColor.init(red: 0.11, green: 0.6, blue: 0.39, alpha: 1), horizontalPadding: 1, verticalPadding: 1)
                    

                }
                
                
                return .all(menuOptions: MenuOptions(), pagingControllers: [readVC, favoriteVC, commentVC])
            }
            
            
        }
        
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
        
        
        pagingMenuController.onMove = { state in
            switch state {
            case let .didMoveController(menuController, previousMenuController):
                previousMenuController.setEditing(false, animated: false)
                self.isEditingMode = false
                self.removeAllDataButton.isEnabled = false
            default : break
            }
        }
 
        pagingMenuController.setup( PagingMenuuOptions())
        
        //usersViewController.menuItemDescription = menuItemDescription
//
//        let viewControllers = [readVC,favoriteVC,commentVC]
//        
//        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
//        pagingMenuController.delegate = self
//        
//        
////        options.backgroundColor = FlatYellow()
////        options.selectedBackgroundColor = FlatYellow()
////        options.textColor = FlatWhite()
////        options.selectedTextColor = FlatBlackDark()
//        
//        struct PagingMenuOptions: PagingMenuControllerCustomizable {
//            var componentType: ComponentType {
//                return .all(menuOptions: MenuOptions(), pagingControllers: [readVC, favoriteVC, commentVC])
//            }
//        }
        
    
        
//        options.menuPosition = .Bottom
//        
//        
//        options.menuItemMode = .Underline(height: 4, color: FlatLime(), horizontalPadding: 0, verticalPadding: 0)
//        
//        switch options.menuComponentType {
//        case .All, .MenuController:
//            pagingMenuController.setup(viewControllers, options: options)
//        case .MenuView:
//            pagingMenuController.setup(viewControllers.map { $0.title! }, options: options)
//
//        }
        
//        setUpAdmob()
    }
    

}

