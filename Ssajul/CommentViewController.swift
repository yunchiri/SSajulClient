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
        
        let url = "http://www.soccerline.co.kr/login/index.php"
        
        let parameters = [ "login_id" : "z5000" ,"login_pwd" : "z0007"]
        
        
        Alamofire.request(.POST, url, parameters: parameters)
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
                }
        }
        
        
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
