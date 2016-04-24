//
//  GoogleURLShortenerRouterTests.swift
//  GoogleURLShortener
//
//  Created by Rodger Higgins on 4/23/16.
//  Copyright © 2016 Spazstik Software. All rights reserved.
//

import XCTest
@testable import GoogleURLShortener

class GoogleURLShortenerRouterTests: XCTestCase {
    let apiKey = "ExampleKey"

    override func setUp() {
        super.setUp()

        GoogleURLShortenerRouter.apiKey = self.apiKey
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testQueryString_QueryString_ShouldStartWithQuestionMark() {
        let gr = GoogleURLShortenerRouter.Shorten(longURL: "http://www.long.com")

        XCTAssert(gr.queryString().hasPrefix("?"))
    }

    func testQueryString_WithoutQueryParameters_ShouldOnlyReturnAPIKey() {
        let gr = GoogleURLShortenerRouter.Shorten(longURL: "http://www.long.com")

        XCTAssert(gr.queryString() == "?key=\(apiKey)")
    }

    func testQueryString_APIKeyValue_CanBeChanged() {
        let customKey = "New API Key"
        GoogleURLShortenerRouter.apiKey = customKey
        let gr = GoogleURLShortenerRouter.Shorten(longURL: "http://www.google.com")

        XCTAssert(gr.queryString().hasPrefix("?key=\(customKey)"))
    }

    func testQueryString_WithQueryParameters_ShouldReturnApiKeyAndQueryParameter() {
        let params = ["query":"value"]
        let gr = GoogleURLShortenerRouter.Shorten(longURL: "http://www.long.com")

        XCTAssert(gr.queryString(params) == "?key=\(apiKey)&query=\(params["query"]!)")
    }
}
