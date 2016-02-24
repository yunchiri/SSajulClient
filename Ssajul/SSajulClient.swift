//
//  SSajulClient.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 2. 23..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import Foundation

import Alamofire

class SSajulClient  {
    static let sharedInstance = SSajulClient()
    
    let urlMEndpoint = "http://m.soccerline.co.kr/"
    let urlEndpoint = "http://soccerline.co.kr/"
    
    func getBoardList() -> Array<Board>{
        
        

        return         [Board(name: "간호사근무편성", boardID: "soccerboard"), Board(name: "전공의근무편성", boardID: "locker")]
    }
    
    func getItemList(board : Board, page : Int , completionHandler : (SSajulClient?, NSError?) -> Void) {
        
        
        let url = "http://m.soccerline.co.kr/bbs/soccerboard/list.html"

        Alamofire.request(.GET, url)
                .responseString(encoding: NSUTF8StringEncoding) { response in
                    if let error = response.result.error{
                        completionHandler(nil, error)
                    }
                    print(response.result.value)
                    
                    completionHandler(response.result.value, nil)
                    
                    
        }
        
//        private class func getSpeciesAtPath(path: String, completionHandler: (SpeciesWrapper?, NSError?) -> Void) {
//            Alamofire.request(.GET, path)
//                .responseSpeciesArray { response in
//                    if let error = response.result.error
//                    {
//                        completionHandler(nil, error)
//                        return
//                    }
//                    completionHandler(response.result.value, nil)
//            }
//        }
   

    }
//    
//    func getItemList(board : Board, page : Int) -> String{
//        
//        //        guard board == nil else{
//        //            return
//        //        }
//        
//        
//        let url = "http://m.soccerline.co.kr/bbs/soccerboard/list.html"
//        
//        //        Alamofire.request(.GET, url)
//        //        .responseData { (response) -> Void in
//        //            print(response.request)
//        //            print(response.response)
//        //            print(response.data)
//        //        }
//        
//        //        Alamofire.request(.GET, url)
//        //            .responseString(completionHandler: { response in
//        //                print(response.request)
//        //                print(response.response)
//        //
//        //                print(response.description)
//        //            })
//        
//        
//        
//        Alamofire.request(.GET, url)
//            .responseString(encoding: NSUTF8StringEncoding) { response in
//                print(response.description)
//        }
//        
//        private class func getSpeciesAtPath(path: String, completionHandler: (SpeciesWrapper?, NSError?) -> Void) {
//            Alamofire.request(.GET, path)
//                .responseSpeciesArray { response in
//                    if let error = response.result.error
//                    {
//                        completionHandler(nil, error)
//                        return
//                    }
//                    completionHandler(response.result.value, nil)
//            }
//        }
//        
//        
//        
//        return ""
//    }
    
    func getItem(board : Board, itemID : String) -> String{
        
        return ""
    }
    
    func login() {
        
    }
    
    func logout() {
        
    }

    
}