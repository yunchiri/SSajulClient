//
//  SsajulTests.swift
//  SsajulTests
//
//  Created by yunchiri on 2016. 2. 1..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import XCTest
@testable import Ssajul

import Alamofire
import Kanna

class SsajulTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let url = "http://www.soccerline.co.kr/slboard/list.php?page=1&code=locker&keyfield=&key=&period=&"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        updateBoardList()
        
//         print("test gogo!!")
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func updateBoardList(){
        let url = "http://www.soccerline.co.kr/slboard/list.php?page=1&code=locker&keyfield=&key=&period=&"
        


        
        Alamofire.request(.GET, url)
            .responseString(encoding:CFStringConvertEncodingToNSStringEncoding( 0x0422 ) ) { response in
                //print(response.description)
                //                if let doc = Kanna.HTML(html: response.result.value!, encoding: CFStringConvertEncodingToNSStringEncoding( 0x0422 ) ){
                print("test start")
                if let doc = Kanna.HTML(html: response.description, encoding: NSUTF8StringEncoding){
                    
//                    let element : XMLElement? = doc.xpath(xpathString)
                    
                    let element : XMLElement? = doc.css("table.te2").first
                    
                    print((element as XMLElement?)!.css("tr").count)
                    
                    
                    for xxx in  (element as XMLElement?)!.css("tr"){
                        print(xxx.text)
                        print(xxx["href"])
                    }
                    
//                    for var item in   doc.xpath(xpathString)
//                    {
//                        print (item)
//                    }

                }
                
        }
    }

}
