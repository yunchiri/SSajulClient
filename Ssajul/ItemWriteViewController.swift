//
//  ItemWriteViewController.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 4. 16..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
//import KMPlaceholderTextView
import Alamofire
import RealmSwift
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


class ItemWriteViewController: UIViewController {
    var isPosting :Bool = false
    
    @IBOutlet weak var placeholderTextView: UITextView!
    @IBOutlet weak var subjectTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func keyboardWasShown(_ notification: Notification)
    {
        let info = notification.userInfo
        var kbRect = (info![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        kbRect = view.convert(kbRect!, from: nil)
        
        var contentInsets = placeholderTextView.contentInset
        contentInsets.bottom = (kbRect?.size.height)! + 30
        placeholderTextView.contentInset = contentInsets
        placeholderTextView.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWillBeHidden(_ notification: Notification)
    {
        var contentInsets = placeholderTextView.contentInset
        contentInsets.bottom = 0.0
        placeholderTextView.contentInset = contentInsets
        placeholderTextView.scrollIndicatorInsets = contentInsets
    }
    
    
    
    

    @IBAction func postContent(_ sender: AnyObject) {
        if valideCheck() == false {
            return
        }
        
        writeContent()
    }
    
    
    
    
    func valideCheck() -> Bool{
        if subjectTextField.text?.characters.count < 3 {

            let alertController = UIAlertController(title: "제목 2글자 이상 넣어요", message: " -from 호두짱 메시새가슴-", preferredStyle: UIAlertControllerStyle.alert)

            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                print("OK")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
            
        }
        
        if placeholderTextView.text.characters.count == 0 {
            let alertController = UIAlertController(title: "엌...ㄷㄷㄷ 본문글이 없는디염", message: " -from XX펠리오-", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                print("OK")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
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
        
        Alamofire.upload(multipartFormData: { multipartFormData in
        
            multipartFormData.append("1".data(using: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding( 0x0422 )))!, withName :"nickname")
            
            multipartFormData.append("1".data(using: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding( 0x0422 )))!, withName :"comment_yn")

            multipartFormData.append( (SSajulClient.sharedInstance.selectedBoard?.boardID.data(using: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding( 0x0422 )))!)!, withName :"code")
                
            multipartFormData.append(self.subjectTextField.text!.data(using: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding( 0x0422 )))!, withName :"subject")
//
            
            multipartFormData.append(self.placeholderTextView.text.data(using: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(0x0422)))!, withName: "comment")
            
//            multipartFormData.append( self.placeholderTextView.text.data(using:CFStringConvertEncodingToNSStringEncoding( 0x0422 )  , withName: "comment")
            
        }, to: SSajulClient.sharedInstance.urlForContentWrite()
            , encodingCompletion :   { encodingResult in
            
                switch encodingResult {
                    case .success(let upload, _, _):
                    upload.responseString { response in
                    
                    if response.description.contains("도배"){
                    
                    let alertController = UIAlertController(title: "산성넘기 실패", message: "도배 가능성이 있답니다.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    print("OK")
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                    self.setUIEnable()
                    self.isPosting = false
                    return
                    }
                    
                    if response.description.contains("금지어"){
                
                        let alertController = UIAlertController(title: "금지어 좀 적지마요", message: "청정지역 싸줄", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        print("OK")
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                        self.setUIEnable()
                        self.isPosting = false
                        return
                    }
                    
                    if response.description.contains("제목은 반드시"){
                
                        let alertController = UIAlertController(title: "제목은 2글자", message: "이상되야되요", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        print("OK")
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                        self.setUIEnable()
                        self.isPosting = false
                        return
                    }
                    
                    
                    if response.description.contains("history.back();"){
                
                        self.needLogin()
                        self.setUIEnable()
                        self.isPosting = false
                        return
                    }
                    
                    
                    self.setUIReset()
                    self.setUIEnable()
                    self.isPosting = false
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    }
                    case .failure(let encodingError):
                    print (encodingError)
                    
                    let alertController = UIAlertController(title: "엌...ㄷㄷㄷ 에러 나중에 다시좀...", message: " - 왜죠?-", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    print("OK")
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    self.setUIEnable()
                    self.isPosting = false
                }
            }
        )
    }
        
        
        
//        Alamofire.upload(
//            .POST,
//            SSajulClient.sharedInstance.urlForContentWrite() ,
//            multipartFormData: { multipartFormData in
//            
//                multipartFormData.appendBodyPart(data: "1".dataUsingEncoding(CFStringConvertEncodingToNSStringEncoding( 0x0422 ), allowLossyConversion: false)!, name :"nickname")
//                multipartFormData.appendBodyPart(data: "1".dataUsingEncoding(CFStringConvertEncodingToNSStringEncoding( 0x0422 ), allowLossyConversion: false)!, name :"comment_yn")
//                multipartFormData.appendBodyPart(data: (SSajulClient.sharedInstance.selectedBoard?.boardID.dataUsingEncoding(CFStringConvertEncodingToNSStringEncoding( 0x0422 ), allowLossyConversion: false)!)!, name :"code")
//                multipartFormData.appendBodyPart(data:self.subjectTextField.text!.dataUsingEncoding(CFStringConvertEncodingToNSStringEncoding( 0x0422 ), allowLossyConversion: false)!, name :"subject")
//                multipartFormData.appendBodyPart(data:self.placeholderTextView.text.dataUsingEncoding(CFStringConvertEncodingToNSStringEncoding( 0x0422 ), allowLossyConversion: false)!, name :"comment")
//            },
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .Success(let upload, _, _):
//                    upload.responseString { response in
//
//                        if response.description.containsString("도배"){
//                            
//                            let alertController = UIAlertController(title: "산성넘기 실패", message: "도배 가능성이 있답니다.", preferredStyle: UIAlertControllerStyle.Alert)
//                            
//                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
//                                print("OK")
//                            }
//                            alertController.addAction(okAction)
//                            self.presentViewController(alertController, animated: true, completion: nil)
//                            
//                            
//                            self.setUIEnable()
//                            self.isPosting = false
//                            return
//                        }
//                        
//                        if response.description.containsString("금지어"){
//                            
//                            let alertController = UIAlertController(title: "금지어 좀 적지마요", message: "청정지역 싸줄", preferredStyle: UIAlertControllerStyle.Alert)
//                            
//                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
//                                print("OK")
//                            }
//                            alertController.addAction(okAction)
//                            self.presentViewController(alertController, animated: true, completion: nil)
//                            
//                            
//                            self.setUIEnable()
//                            self.isPosting = false
//                            return
//                        }
//     
//                        if response.description.containsString("제목은 반드시"){
//                            
//                            let alertController = UIAlertController(title: "제목은 2글자", message: "이상되야되요", preferredStyle: UIAlertControllerStyle.Alert)
//                            
//                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
//                                print("OK")
//                            }
//                            alertController.addAction(okAction)
//                            self.presentViewController(alertController, animated: true, completion: nil)
//                            
//                            
//                            self.setUIEnable()
//                            self.isPosting = false
//                            return
//                        }
//
//                        
//                        if response.description.containsString("history.back();"){
//                            
//                            self.needLogin()
//                            self.setUIEnable()
//                            self.isPosting = false
//                            return
//                        }
//                        
//
//                        self.setUIReset()
//                        self.setUIEnable()
//                        self.isPosting = false
//                        
//                        self.dismissViewControllerAnimated(true, completion: nil)
//                        
//                    }
//                case .Failure(let encodingError):
//                    print (encodingError)
//                    
//                    let alertController = UIAlertController(title: "엌...ㄷㄷㄷ 에러 나중에 다시좀...", message: " - 왜죠?-", preferredStyle: UIAlertControllerStyle.Alert)
//                    
//                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
//                        print("OK")
//                    }
//                    alertController.addAction(okAction)
//                    self.presentViewController(alertController, animated: true, completion: nil)
//                    self.setUIEnable()
//                    self.isPosting = false
//                    
//                }
//            }
//        )

    
    
    @IBAction func close(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    func setUIDisable(){
        
        placeholderTextView.isEditable = false
        subjectTextField.isEnabled = false
    }
    func setUIEnable(){
        
        placeholderTextView.isEditable = true
        subjectTextField.isEnabled = true
    }
    
    func setUIReset(){
        self.placeholderTextView.text.removeAll()
        self.subjectTextField.text?.removeAll()
    }
    
    
    func needLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        
        
        self.present(loginViewController, animated: true, completion: nil)
        
    }
    

    @IBAction func insertMultimedia(_ sender: AnyObject) {
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "링크추가", message: "무슨 링크 추가할래요?", preferredStyle: .actionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "주영", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let insertImageAction: UIAlertAction = UIAlertAction(title: "이미지링크", style: .default)
        { action -> Void in
            
//            self.performSegueWithIdentifier("segue_setup_customer", sender: self)
            self.showInputMultimediaLink("img")
            
        }
        actionSheetController.addAction(insertImageAction)
        
        let insertYoutubeAction: UIAlertAction = UIAlertAction(title: "Youtube", style: .default)
        { action -> Void in
            
            //            self.performSegueWithIdentifier("segue_setup_customer", sender: self)
            self.showInputMultimediaLink("youtube")
            
        }
        
        actionSheetController.addAction(insertYoutubeAction)
        
        
        //Create and add a second option action
        let insertMultimedia: UIAlertAction = UIAlertAction(title: "멀티미디어링크", style: .default)
        { action -> Void in
            
            //self.performSegueWithIdentifier("segue_setup_provider", sender: self)
            self.showInputMultimediaLink("multi")
            
        }
        actionSheetController.addAction(insertMultimedia)
        present(actionSheetController, animated: true, completion: nil)
        //We need to provide a popover sourceView when using it on iPad
    }
    
    func showInputMultimediaLink(_ type : String){
        //Present the AlertController
        
        //<img src="http://ddd" width=20 border=0>
        //<EMBED SRC="http://dd" autostart="false">

        let alert=UIAlertController(title: "링크추가", message: "", preferredStyle: UIAlertControllerStyle.alert);
        //default input textField (no configuration...)
        alert.addTextField(configurationHandler: nil);
        //no event handler (just close dialog box)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            
            let inputString = ((alert.textFields![0] as UITextField).text)!
            var linkString = ""
            if type == "img" {
                
                let width : CGFloat = 600;
                
                linkString = "<img src=\"" + inputString + "\" width=" + String(describing: width) + " border=0>"
            }
            
            if type == "youtube"{
                
                let fixInputString = inputString.replacingOccurrences(of: "youtu.be", with: "youtube.com/embed")
                //<embed width="480" height="320" src="https://www.youtube.com/embed/k87VvXQ8M0o" frameborder="0" allowfullscreen></embed>
                linkString = "<embed width=\"480\" height=\"320\" src=\"" + fixInputString + "\"  frameborder=\"0\" allowfullscreen></embed>"
            }
            if type == "multi"{
                linkString = "<EMBED SRC=\"" + inputString + "\" autostart=\"false\">"
            }
            
            self.placeholderTextView.insertText( linkString)
        }));
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil));
        //event handler with closure

        present(alert, animated: true, completion: nil);

    }
    
    
    
    
}
