//
//  CommentWriteCell.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 4. 13..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
import Alamofire

class CommentWriteCell: UITableViewCell , UITextViewDelegate  {

    
    @IBOutlet weak var commentLengthInfoView: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentWriteButton: UIButton!
    
    var delegate : CommentWriteCellDelegate?
    var isPosting : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.commentTextView.delegate = self
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    
    @IBAction func writeComment(_ sender: AnyObject) {
    
        if commentTextView.text.characters.count > 255 {
            return
        }
        
        addcomment()
        
        
        
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        commentLengthInfoView.text = "(" + String( commentTextView.text.characters.count) + "/255)"
    }
    
    
    func addTargetUser(_ userNickName : String){
        
        commentTextView.insertText( " @" + userNickName + " ")
//        commentTextView.text.append( "@" + userNickName)
    }

    func addcomment() {
        
//        guard isPosting == false else {
//            return
//        }
//        
//        isPosting = true
//        
//        self.setUIDisable()
//        
//        var parameters = SSajulClient.sharedInstance.ParametersForComment()
//        parameters["comment"] = commentTextView.text
//        
//
//        
//        var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
//        defaultHeaders["Content-Type"] = "application/x-www-form-urlencoded"
//        
////        SSajulClient.sharedInstance.showCookies()
//        
//        let configuration = URLSessionConfiguration.default
//        configuration.HTTPAdditionalHeaders = defaultHeaders;
//        let _ = Alamofire.Manager(configuration: configuration)
//        
//
//        let encodingClosure: (URLRequestConvertible, [String: AnyObject]?) -> (NSMutableURLRequest, NSError?) = { URLRequest, parameters in
//            guard let parameters = parameters else { return (URLRequest.URLRequest, nil) }
//            
//            let bodyString = (parameters.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
//            
//            let mutableURLRequest = URLRequest.URLRequest
//            mutableURLRequest.URL = NSURL(string: SSajulClient.sharedInstance.urlForCommentWrite())!
//            mutableURLRequest.HTTPBody = bodyString.dataUsingEncoding( CFStringConvertEncodingToNSStringEncoding( 0x0422 ))
//            return (mutableURLRequest, nil)
//        }
//        
//        
////        let _ = Alamofire.request(.POST, SSajulClient.sharedInstance.urlForCommentWrite(), parameters: parameters, encoding: .Custom(encodingClosure))
//        let _ = Alamofire.request(SSajulClient.sharedInstance.urlForCommentWrite(), method: .post, parameters: parameters, encoding: head, headers: [:])
//            .responseString { response in
//                
//                if response.result.isSuccess == true {
//                    
//                    if response.description.containsString("history.back();"){
//                        
//                        self.delegate!.needLogin()
//                        
//                        self.setUIEnable()
//                        self.isPosting = false
//                        return
//                    }
//                    self.delegate!.commentDidPost()
//                    self.setUIReset()
//                    self.setUIEnable()
//                    self.isPosting = false
//                }
//        }
//        
//
//        
//        
    }
    
    func setUIDisable(){
        
        commentWriteButton.isEnabled = false
        commentTextView.isEditable = false
    }
    func setUIEnable(){
        
        commentWriteButton.isEnabled = true
        commentTextView.isEditable = true
    }
    
    func setUIReset(){
        self.commentTextView.text.removeAll()
        self.textViewDidChange(self.commentTextView)
    }
    
}
