//
//  CommentWriteCell.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 4. 13..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
import Alamofire

class CommentWriteCell: UITableViewCell , UITextViewDelegate {

 
    
    
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

    
    @IBOutlet weak var commentLengthInfoView: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentWriteButton: UIButton!
    
    @IBAction func writeComment(sender: AnyObject) {
    
        if commentTextView.text.characters.count > 255 {
            return
        }
        
        addcomment()
        
        
        
    }
    
    
    
    func textViewDidChange(textView: UITextView) {
        commentLengthInfoView.text = "(" + String( commentTextView.text.characters.count) + "/255)"
    }
    
    
    func addTargetUser(userNickName : String){
        
        commentTextView.insertText( "@" + userNickName)
//        commentTextView.text.append( "@" + userNickName)
    }

    func addcomment() {
        
        self.setUIEnable()
        
//        var parameters = [ "code" : "soccerboard"
//            ,"tbl_name" : "soccerboard"
//            ,"comment_board_name" : "7"
//            ,"nickname" : "a"
//            ,"page" : ""
//            , "key" : ""
//            , "keyfield" : ""
//            , "period" : ""
//            , "uid" : "1987159662"
//            , "mode" : "W"
//            , "comment" : ""
//        ]
//        
        var parameters = SSajulClient.sharedInstance.ParametersForComment()
        parameters["comment"] = commentTextView.text
        

        
        var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["Content-Type"] = "application/x-www-form-urlencoded"
        
//        SSajulClient.sharedInstance.showCookies()
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = defaultHeaders;
        let _ = Alamofire.Manager(configuration: configuration)
        

        let encodingClosure: (URLRequestConvertible, [String: AnyObject]?) -> (NSMutableURLRequest, NSError?) = { URLRequest, parameters in
            guard let parameters = parameters else { return (URLRequest.URLRequest, nil) }
            
            let bodyString = (parameters.map { "\($0)=\($1)" } as [String]).joinWithSeparator("&")
            
            let mutableURLRequest = URLRequest.URLRequest
            mutableURLRequest.URL = NSURL(string: SSajulClient.sharedInstance.urlForCommentWrite())!
            mutableURLRequest.HTTPBody = bodyString.dataUsingEncoding( CFStringConvertEncodingToNSStringEncoding( 0x0422 ))
            return (mutableURLRequest, nil)
        }
        

        let _ = Alamofire.request(.POST, SSajulClient.sharedInstance.urlForCommentWrite(), parameters: parameters, encoding: .Custom(encodingClosure))
            .responseString { response in
                
                if response.result.isSuccess == true {
                    self.setUIDisable()
                    self.commentTextView.text.removeAll()
                    self.textViewDidChange(self.commentTextView)
                }
        }
        
//        debugPrint(request)
        
        
    }
    
    func setUIEnable(){
        
        commentWriteButton.enabled = false
        commentTextView.editable = false
    }
    func setUIDisable(){
        
        commentWriteButton.enabled = true
        commentTextView.editable = true
        
    }
    
}
