//
//  LoginViewController.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 4. 4..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit

import Alamofire
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class LoginViewController: UIViewController {

    
    @IBOutlet weak var uiLoginID: UITextField!
    @IBOutlet weak var uiPassword: UITextField!
    
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

    @IBAction func uiClose(_ sender: AnyObject) {
        dismiss(animated: false, completion: nil);
    }
 
    
    @IBAction func uiLogin(_ sender: AnyObject) {
        
//        print("enter login")
        
        guard valideCheck() == true else {
            let alertController = UIAlertController(title: "아이디/비번 입력이 잘못된듯...", message: " - 호짱메돈 -", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                print("OK")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url = SSajulClient.sharedInstance.urlForLogin()
        
        
        var parameters = [ "login_id" : "" ,"login_pwd" : ""]
        
        parameters["login_id"] = uiLoginID.text
        parameters["login_pwd"] = uiPassword.text
        
        //let _ = Alamofire.request(.POST, url, parameters: parameters)
//        let _ = Alamofire.request(url, parameters: parameters)
        let _ = Alamofire.request(url, method: .post, parameters: parameters, headers: [:])
            .responseString { response in

                if response.result.isFailure == true{
                    return
                }
                
                if response.result.isSuccess == true {
                    
                    if response.description.contains( "history" ) {
                        let alertController = UIAlertController(title: "이건 뭔가 잘못됬다", message: " - 반할 -", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                            print("OK")
                        }
                        alertController.addAction(okAction)
                        //self.presentViewController(alertController, animated: true, completion: nil)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                    
                    self.uiClose(self)
                    //00UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    SSajulClient.sharedInstance.login(self.uiLoginID.text!,  loingPwd: self.uiPassword.text!)
                    
//                    SSajulClient.sharedInstance.showCookies()
 

                } else {
                    let alertController = UIAlertController(title: "엌...ㄷㄷㄷ 에러 나중에 다시좀...", message: " - 원인 : 나도모름 -", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        print("OK")
                    }
                    alertController.addAction(okAction)
                    
                    //self.presentViewController(alertController, animated: true, completion: nil)
                    self.present(alertController, animated: true, completion: nil)
                }
        }
                
    }
    
    
    func valideCheck()-> Bool{
        if uiLoginID.text?.characters.count == 0 {
            return false
        }
        
        if uiPassword.text?.characters.count == 0 {
            return false
        }
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.uiLoginID.text = UserDefaults.standard.object(forKey: "login_id") as? String
        self.uiPassword.text = UserDefaults.standard.object(forKey: "login_pwd") as? String
        
        guard self.uiLoginID.text?.characters.count > 0 , self.uiPassword.text?.characters.count > 0 else {
            return
        }
        
        self.uiLogin("" as AnyObject)
    }
  
    
}
