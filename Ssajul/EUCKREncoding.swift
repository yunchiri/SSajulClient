//
//  EUCKREncoding.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 11. 19..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import Alamofire

struct EUCKREncoding: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        
        //                let bodyString = (parameters.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
        let bodyString = parameters?.map({ element -> String in
            "\(element.key)=\(element.value)"
        }).joined(separator: "&")
        
        var mutableURLRequest = try urlRequest.asURLRequest()
        
        do {
            
            mutableURLRequest.url = NSURL(string: SSajulClient.sharedInstance.urlForCommentWrite())! as URL
            //            mutableURLRequest?.httpBody = bodyString.dataUsingEncoding( encoding: String.Encoding.init(rawValue: 0x0422 ) )
            
            let data = bodyString?.data(using: String.Encoding.init(rawValue: CFStringConvertEncodingToNSStringEncoding(0x0422) ));
            
            mutableURLRequest.httpBody = data
            
        } catch {
            throw AFError.parameterEncodingFailed(reason: .propertyListEncodingFailed(error: error))
        }
        
        
        
        return mutableURLRequest
        
    }
}
