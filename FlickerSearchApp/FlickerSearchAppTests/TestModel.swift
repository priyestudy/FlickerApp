//
//  TestModel.swift
//  FlickerSearchAppTests
//
//  Created by B0207468 on 21/08/18.
//  Copyright © 2018 Priye Saurabh. All rights reserved.
//

import XCTest
@testable import FlickerSearchApp

class TestModel: XCTestCase {
    private var model:Record!

    override func setUp() {
        
        super.setUp()
        model = Record(dictionary: dummyDictionaryForRecord())
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        model = nil
        super.tearDown()
    }
    
    func testModelParsing() {
        if (model.localUrlName != "4325407874515e9d2b283") {
            print("local url is not properly parsed")
        }
        if model.url != "https://farm2.staticflickr.com/1850/43254078745_15e9d2b283.jpg" {
            print(" url is not properly parsed")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func dummyDictionaryForRecord() -> Dictionary<String, AnyObject> {
        return ["farm" : 2 as AnyObject,"id" : "43254078745" as AnyObject , "server" : "1850" as AnyObject, "secret" : "15e9d2b283" as AnyObject, "title" : "Donald John Trump Appeal for donations for Emma and Hugo : Our children will die before the time" as AnyObject]
    }

    
    
}
