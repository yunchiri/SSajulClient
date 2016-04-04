//
//  LoginViewController.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 4. 4..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit


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
        
    }
}
