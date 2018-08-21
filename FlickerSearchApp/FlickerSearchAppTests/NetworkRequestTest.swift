//
//  NetworkRequestTest.swift
//  FlickerSearchAppTests
//
//  Created by Priye Saurabh on 21/08/18.
//  Copyright © 2018 Priye Saurabh. All rights reserved.
//

import XCTest
@testable import FlickerSearchApp

class NetworkRequestTest: XCTestCase {
    private var requestObj:NetworkRequest!

    override func setUp() {
        super.setUp()
        requestObj = NetworkRequest(component: "www.google.com", reqType: RequestType.GET)

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        requestObj = nil
        super.tearDown()
    }
    
    func testInitialization() {
        if (requestObj.requestType != RequestType.GET || requestObj.urlPathComponent !=  "www.google.com") {
            XCTFail("Request Object not properly initialized")
        }
    }
    
}
