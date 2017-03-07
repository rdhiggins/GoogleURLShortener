//
// GoogleURL.swift
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

class GoogleURLTests: XCTestCase {
    fileprivate let defaultURL = "unknown"

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testGoogleURL_DefaultInitialization_ShouldCreateDefaults() {
        _ = GoogleURL()
    }

    func testGoogleURL_DefaultInitialization_LongURLShouldDefaultToUnknown() {
        let gu = GoogleURL()

        XCTAssert(gu.longURL == defaultURL)
    }

    func testGoogleURL_DefaultInitialization_ShortURLShouldDefaultToUnknown() {
        let gu = GoogleURL()

        XCTAssert(gu.shortURL == defaultURL)
    }

    func testGoogleURL_InitializationLongURL_ShouldTakeLongURLOnInitialization() {
        let longURL = "http://www.google.com"
        _ = GoogleURL(longURL: longURL)
    }

    func testGoogleURL_InitializationLongURL_LongURLShouldHaveValuePassedToInitializer() {
        let longURL = "http://www.google.com"
        let gu = GoogleURL(longURL: longURL)

        XCTAssert(gu.longURL == longURL)
    }

    func testGoogleURL_InitializationLongURL_ShortURLShouldDefaultToUnknown() {
        let longURL = "http://www.google.com"
        let gu = GoogleURL(longURL: longURL)

        XCTAssert(gu.shortURL == defaultURL)
    }

    func testGoogleURL_InitializationShortURL_ShouldTakeShortURLOnInitialization() {
        let shortURL = "http://www.short.com"
        _ = GoogleURL(shortURL: shortURL)
    }

    func testGoogleURL_InitializationShortURL_ShortURLShouldHaveValuePassedToInitializer() {
        let shortURL = "http://www.short.com"
        let gu = GoogleURL(shortURL: shortURL)

        XCTAssert(gu.shortURL == shortURL)
    }

    func testGoogleURL_InitializationShortURL_LongURLShouldDefaultToUnknown() {
        let shortURL = "http://www.short.com"
        let gu = GoogleURL(shortURL: shortURL)

        XCTAssert(gu.longURL == defaultURL)
    }

    func testGoogleURL_InitializationLongAndShortURLS_ShouldTakeBothLongAndShortURLs() {
        let longURL = "http://www.long.com"
        let shortURL = "http://www.short.com"

        _ = GoogleURL(longURL: longURL, shortURL: shortURL)
    }

    func testGoogleURL_InitializationLongAndShortURLS_BothValuesPassedFromInitializer() {
        let longURL = "http://www.long.com"
        let shortURL = "http://www.short.com"

        let gu = GoogleURL(longURL: longURL, shortURL: shortURL)

        XCTAssert(gu.longURL == longURL)
        XCTAssert(gu.shortURL == shortURL)
    }

    func testGoogleURL_LongURL_ShouldBeSettable() {
        let expectedURL = "http://www.yahoo.com"
        var gu = GoogleURL(longURL: "http://www.google.com")

        gu.longURL = expectedURL

        XCTAssert(gu.longURL == expectedURL)
    }

    func testGoogleURL_ShortURL_ShouldBeSettable() {
        let expectedURL = "http://www.yahoo.com"
        var gu = GoogleURL(shortURL: "http://www.google.com")

        gu.shortURL = expectedURL

        XCTAssert(gu.shortURL == expectedURL)
    }

    func testGoogleURL_ShortURLValid_ShouldBeValidWhenProperURL() {
        let gu = GoogleURL(shortURL: "http://www.google.com")

        XCTAssertTrue(gu.isShortURLValid)
    }

    func testGoogleURL_ShortURLValid_ShouldNotBeValidWhenImproperURL() {
        let gu = GoogleURL(shortURL: "not a valid url")

        XCTAssertFalse(gu.isShortURLValid)
    }

    func testGoogleURL_LongURLValid_ShouldBeValidWhenProperURL() {
        let gu = GoogleURL(longURL: "http://www.google.com")

        XCTAssertTrue(gu.isLongURLValid)
    }

    func testGoogleURL_LongURLValid_ShouldNotBeValidWhenImproperURL() {
        let gu = GoogleURL(longURL: "not a valid url")

        XCTAssertFalse(gu.isLongURLValid)
    }
}
