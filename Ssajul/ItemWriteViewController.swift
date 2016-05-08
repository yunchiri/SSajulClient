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
import RealmSwift

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
                multipartFormData.appendBodyPart(data: "1".dataUsingEncoding(CFStringConvertEncodingToNSStringEncoding( 0x0422 ), allowLossyConversion: false)!, name :"comment_yn")                
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
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
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
    

    @IBAction func insertMultimedia(sender: AnyObject) {
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "링크추가", message: "무슨 링크 추가할래요?", preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "주영", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let insertImageAction: UIAlertAction = UIAlertAction(title: "이미지링크", style: .Default)
        { action -> Void in
            
//            self.performSegueWithIdentifier("segue_setup_customer", sender: self)
            self.showInputMultimediaLink("img")
            
        }
        actionSheetController.addAction(insertImageAction)
        
        let insertYoutubeAction: UIAlertAction = UIAlertAction(title: "Youtube", style: .Default)
        { action -> Void in
            
            //            self.performSegueWithIdentifier("segue_setup_customer", sender: self)
            self.showInputMultimediaLink("youtube")
            
        }
        
        actionSheetController.addAction(insertYoutubeAction)
        
        
        //Create and add a second option action
        let insertMultimedia: UIAlertAction = UIAlertAction(title: "멀티미디어링크", style: .Default)
        { action -> Void in
            
            //self.performSegueWithIdentifier("segue_setup_provider", sender: self)
            self.showInputMultimediaLink("multi")
            
        }
        actionSheetController.addAction(insertMultimedia)
        presentViewController(actionSheetController, animated: true, completion: nil)
        //We need to provide a popover sourceView when using it on iPad
    }
    
    func showInputMultimediaLink(type : String){
        //Present the AlertController
        
        //<img src="http://ddd" width=20 border=0>
        //<EMBED SRC="http://dd" autostart="false">

        let alert=UIAlertController(title: "링크추가", message: "", preferredStyle: UIAlertControllerStyle.Alert);
        //default input textField (no configuration...)
        alert.addTextFieldWithConfigurationHandler(nil);
        //no event handler (just close dialog box)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) in
            
            let inputString = ((alert.textFields![0] as UITextField).text)!
            var linkString = ""
            if type == "img" {
                
                let data = NSData.init(contentsOfURL: NSURL.init(string:  inputString)!)
                let image = UIImage.init(data: data!)
                let width : CGFloat = (image?.size.width)!;
                
                linkString = "<img src=\"" + inputString + "\" width=" + String(width) + " border=0>"
            }
            
            if type == "youtube"{
                
                let fixInputString = inputString.stringByReplacingOccurrencesOfString("youtu.be", withString: "youtube.com/embed")
                //<embed width="480" height="320" src="https://www.youtube.com/embed/k87VvXQ8M0o" frameborder="0" allowfullscreen></embed>
                linkString = "<embed width=\"480\" height=\"320\" src=\"" + fixInputString + "\"  frameborder=\"0\" allowfullscreen></embed>"
            }
            if type == "multi"{
                linkString = "<EMBED SRC=\"" + inputString + "\" autostart=\"false\">"
            }
            
            self.placeholderTextView.insertText( linkString)
        }));
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil));
        //event handler with closure

        presentViewController(alert, animated: true, completion: nil);

    }
    
    
    
    
}
