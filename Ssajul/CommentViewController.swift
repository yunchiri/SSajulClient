//
//  CommentViewController.swift
//  Ssajul
//
//  Created by 서 홍원 on 2016. 4. 6..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
import Alamofire

class CommentViewController: UIViewController {
    
    @IBOutlet weak var uiComment: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addcomment(sender: AnyObject) {
        
        
        let url = "https://www.soccerline.co.kr/slboard/comment_write.php"
        
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
        
        var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["Content-Type"] = "application/x-www-form-urlencoded"
        
        showCookies()
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = defaultHeaders;
        let manager = Alamofire.Manager(configuration: configuration)
   
        let request = Alamofire.request(.POST, url, parameters: parameters)
            .responseString { response in
                
                if response.result.isSuccess == true {
                    self.uiClose(self)
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    SSajulClient.sharedInstance.login()
                }
        }
        
        debugPrint(request)
        
        
    }
    
    func showCookies() {
        
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        //println("policy: \(cookieStorage.cookieAcceptPolicy.rawValue)")
        
        let cookies = cookieStorage.cookies! as [NSHTTPCookie]
        
        print("Cookies.count: \(cookies.count)")
        
        for cookie in cookies {
            print("ORGcookie: \(cookie)")
        }
    }
    
    func deleteCookies() {
        let storage : NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in storage.cookies!  as [NSHTTPCookie]
        {
            storage.deleteCookie(cookie)
        }
        NSUserDefaults.standardUserDefaults()
    }
    
    
    @IBAction func uiClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
