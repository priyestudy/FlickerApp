//
//  NetworkManagerTest.swift
//  FlickerSearchAppTests
//
//  Created by Priye Saurabh on 21/08/18.
//  Copyright © 2018 Priye Saurabh. All rights reserved.
//

import Foundation

import XCTest
@testable import FlickerSearchApp

class NetworkManagerTest: XCTestCase {
    private var networkManager:NetworkManager!
    
    override func setUp() {
        super.setUp()
        networkManager = NetworkManager(information: NetworkRequest(component: "www.google.com", reqType: RequestType.GET))
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(networkManager.requestInformation)
        let requestObj = networkManager.requestInformation
        if (requestObj.requestType != RequestType.GET || requestObj.urlPathComponent !=  "www.google.com") {
            XCTFail("Request Object not properly initialized")
        }
    }
}
