//
//  ViewModelsTest.swift
//  FlickerSearchAppTests
//
//  Created by Priye Saurabh on 20/08/18.
//  Copyright © 2018 Priye Saurabh. All rights reserved.
//


import XCTest
@testable import FlickerSearchApp

class ViewModelTest : XCTestCase {
    
    private var viewModel:ListPageViewModel!
    override func setUp() {
        super.setUp()
        viewModel = ListPageViewModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(viewModel.downloadManager)
        XCTAssertNotNil(viewModel.recordList)
        XCTAssertNotNil(viewModel.resultInformation)
    }

    func testFetchRcordInformationWithTextChange() {
        let expectation = self.expectation(description: "FlickerSearchAPI")
        viewModel.fetchRecords(text: "photo", isTextChange: true) { (value) in
            if (value) {
                XCTAssertTrue(self.viewModel.recordList.count == self.viewModel.nuberOfRowsInSection())
            } else {
                print("No response is coming for search")
            }
            expectation.fulfill()

        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    func testFetchRcordInformationWithoutTextChange() {
        viewModel.recordList = [Record(dictionary: dummyDictionaryForRecord())]
        let expectation = self.expectation(description: "FlickerSearchAPI")
        viewModel.fetchRecords(text: "photo", isTextChange: false) { (value) in
            if (value) {
                if (self.viewModel.recordList.count < 2) {
                    XCTFail("Not getting proper server response")
                }
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func dummyDictionaryForRecord() -> Dictionary<String, AnyObject> {
        return ["farm" : 2 as AnyObject,"id" : "43254078745" as AnyObject , "server" : "1850" as AnyObject, "secret" : "15e9d2b283" as AnyObject, "title" : "Donald John Trump Appeal for donations for Emma and Hugo : Our children will die before the time" as AnyObject]
    }
}

