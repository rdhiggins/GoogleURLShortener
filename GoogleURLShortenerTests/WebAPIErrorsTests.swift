//
//  WebAPIErrorsTests.swift
//  GoogleURLShortener
//
//  Created by Rodger Higgins on 4/23/16.
//  Copyright © 2016 Spazstik Software. All rights reserved.
//

import XCTest
@testable import GoogleURLShortener

class WebAPIErrorsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testWebPIErrors_Errors_SupportsBadRequests() {
        _ = WebAPIErrors.BadRequest
    }

    func testWebPIErrors_Errors_SupportsBadStatusCode() {
        _ = WebAPIErrors.BadStatusCode(34)
    }

    func testWebPIErrors_Errors_SupportsNoData() {
        _ = WebAPIErrors.NoData
    }

    func testWebPIErrors_Errors_SupportsNoResponse() {
        _ = WebAPIErrors.NoResponse
    }

    func testWebPIErrors_Errors_SupportsNoRequest() {
        _ = WebAPIErrors.NoRequest
    }
}
