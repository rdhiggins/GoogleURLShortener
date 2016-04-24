//
// GoogleURLShortenerRouterTests.swift
// MIT License
//
// Copyright (c) 2016 Spazstik Software, LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
