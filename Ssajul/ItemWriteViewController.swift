//
//  ItemWriteViewController.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 4. 16..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import Alamofire


class ItemWriteViewController: UIViewController {
    var isPosting :Bool = false
    
    @IBOutlet weak var placeholderTextView: KMPlaceholderTextView!
    @IBOutlet weak var subjectTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification)
    {
        let info = notification.userInfo
        var kbRect = info![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        kbRect = view.convertRect(kbRect, fromView: nil)
        
        var contentInsets = placeholderTextView.contentInset
        contentInsets.bottom = kbRect.size.height + 30
        placeholderTextView.contentInset = contentInsets
        placeholderTextView.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        var contentInsets = placeholderTextView.contentInset
        contentInsets.bottom = 0.0
        placeholderTextView.contentInset = contentInsets
        placeholderTextView.scrollIndicatorInsets = contentInsets
    }
    

    @IBAction func postContent(sender: AnyObject) {
        if valideCheck() == false {
            return
        }
        
        writeContent()
    }
    
    func valideCheck() -> Bool{
        if subjectTextField.text?.characters.count < 3 {

            let alertController = UIAlertController(title: "제목 2글자 이상 넣어요", message: " -from 호두짱 메시새가슴-", preferredStyle: UIAlertControllerStyle.Alert)

            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                print("OK")
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return false
            
        }
        
        if placeholderTextView.text.characters.count == 0 {
            let alertController = UIAlertController(title: "엌...ㄷㄷㄷ 본문글이 없는디염", message: " -from XX펠리오-", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                print("OK")
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    func writeContent() {
        
        guard isPosting == false else {
            return
        }
        
        isPosting = true
        setUIDisable()
        
        Alamofire.upload(
            .POST,
            SSajulClient.sharedInstance.urlForContentWrite() ,
            multipartFormData: { multipartFormData in
                
                multipartFormData.appendBodyPart(data: "1".dataUsingEncoding(CFStringConvertEncodingToNSStringEncoding( 0x0422 ), allowLossyConversion: false)!, name :"nickname")
                multipartFormData.appendBodyPart(data: (SSajulClient.sharedInstance.selectedBoard?.boardID.dataUsingEncoding(CFStringConvertEncodingToNSStringEncoding( 0x0422 ), allowLossyConversion: false)!)!, name :"code")
                multipartFormData.appendBodyPart(data:self.subjectTextField.text!.dataUsingEncoding(CFStringConvertEncodingToNSStringEncoding( 0x0422 ), allowLossyConversion: false)!, name :"subject")
                multipartFormData.appendBodyPart(data:self.placeholderTextView.text.dataUsingEncoding(CFStringConvertEncodingToNSStringEncoding( 0x0422 ), allowLossyConversion: false)!, name :"comment")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseString { response in

                        if response.description.containsString("도배"){
                            
                            let alertController = UIAlertController(title: "산성넘기 실패", message: "도배 가능성이 있답니다.", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                                print("OK")
                            }
                            alertController.addAction(okAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                            
                            
                            self.setUIEnable()
                            self.isPosting = false
                            return
                        }
                        
                        if response.description.containsString("금지어"){
                            
                            let alertController = UIAlertController(title: "금지어 좀 적지마요", message: "청정지역 싸줄", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                                print("OK")
                            }
                            alertController.addAction(okAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                            
                            
                            self.setUIEnable()
                            self.isPosting = false
                            return
                        }
                        

                        
                        if response.description.containsString("history.back();"){
                            
                            self.needLogin()
                            self.setUIEnable()
                            self.isPosting = false
                            return
                        }
                        

                        
                        
                        
                        self.setUIReset()
                        self.setUIEnable()
                        self.isPosting = false
                        
                        self.navigationController?.popViewControllerAnimated(true)
                        
                    }
                case .Failure(let encodingError):
                    print (encodingError)
                    
                    let alertController = UIAlertController(title: "엌...ㄷㄷㄷ 에러 나중에 다시좀...", message: " - 왜죠?-", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                        print("OK")
                    }
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    self.setUIEnable()
                    self.isPosting = false
                    
                }
            }
        )
    }
    
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func setUIDisable(){
        
        placeholderTextView.editable = false
        subjectTextField.enabled = false
    }
    func setUIEnable(){
        
        placeholderTextView.editable = true
        subjectTextField.enabled = true
    }
    
    func setUIReset(){
        self.placeholderTextView.text.removeAll()
        self.subjectTextField.text?.removeAll()
    }
    
    
    func needLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController = storyboard.instantiateViewControllerWithIdentifier("loginVC") as! LoginViewController
        
        
        self.presentViewController(loginViewController, animated: true, completion: nil)
        
    }
    
}
