//
//  LoginViewController.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 4. 4..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit

import Alamofire

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func uiClose(sender: AnyObject) {
        dismissViewControllerAnimated(false, completion: nil);
    }
 
    
    @IBAction func uiLogin(sender: AnyObject) {
        
        print("enter login")

        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let url = SSajulClient.sharedInstance.urlForLogin()
        
        
        let parameters = [ "login_id" : "z5000" ,"login_pwd" : "z007"]
        
        
        let _ = Alamofire.request(.POST, url, parameters: parameters)
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
//                print("Response String: \(response.result.value)")
                if let httpError = response.result.error {
                    let statusCode = httpError.code
                    print(statusCode)
                }
                
                if response.result.isSuccess == true {
                    self.uiClose(self)
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    SSajulClient.sharedInstance.login()
                    
                    print("enter success login")
                    
//                    SSajulClient.sharedInstance.showCookies()
                    
//                    self.addcomment()
                }
        }
        
//        debugPrint(request)
        
                
    }
  
    
    func addcomment() {
        
        
        let url = SSajulClient.sharedInstance.urlForComment()
        
        let parameters = [ "code" : "soccerboard"
            ,"tbl_name" : "soccerboard"
            ,"comment_board_name" : "7"
            ,"nickname" : "a"
            ,"page" : "7"
            , "key" : ""
            , "keyfield" : ""
            , "period" : ""
            , "uid" : "1987159662"
            , "mode" : "W"
            , "comment" : "aaaa333"
        ]
//        
        var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["Content-Type"] = "application/x-www-form-urlencoded"

        let _ = Alamofire.request(.POST, url, parameters: parameters)
            .responseString { response in
                
                if response.result.isSuccess == true {
                    self.uiClose(self)
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    SSajulClient.sharedInstance.login()
                }
        }
        
//        debugPrint(request)
        
        
    }
    
}
