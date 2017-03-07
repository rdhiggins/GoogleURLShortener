//
// GoogleURLShortenerViewControllerTests.swift
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

class GoogleURLShortenerViewControllerTests: XCTestCase {
    var mut: GoogleURLShortenerViewController!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        mut = storyboard.instantiateViewController(withIdentifier: "GoogleURLShortener") as! GoogleURLShortenerViewController

        _ = mut.view                    // Trigger ViewDidLoad
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLongTextField_Initialization_SetAfterViewDidLoad() {
        XCTAssertNotNil(mut.longURLField)
    }

    func testLongURLLabel_Initialization_HasLabelAfterViewDidLoad() {
        XCTAssertNotNil(mut.longURLLabel)
    }

    func testShortURLTextField_Initialization_SetAfterViewDidLoad() {
        XCTAssertNotNil(mut.shortURLField)
    }

    func testShortURLLabel_Initialization_SetAfterViewDidLoad() {
        XCTAssertNotNil(mut.shortURLField)
    }

    func testShortenURLButton_Initialization_SetAfterViewDidLoad() {
        XCTAssertNotNil(mut.shortenURLButton)
    }

    func testShortenURLButton_Initialization_DisabledAfterViewDidLoad() {
        XCTAssertFalse(mut.shortenURLButton.isEnabled)
    }

    func testLookupURLButton_Initialization_SetAfterViewDidLoad() {
        XCTAssertNotNil(mut.lookupURLButton)
    }

    func testLookupURLButton_Initialization_DisabledAfterViewDidLoad() {
        XCTAssertFalse(mut.lookupURLButton.isEnabled)
    }

    func testSetFields_MethodForSettingFields_LongURLFieldShouldHaveValueFromGoogleURLStruct() {
        let expectedLongURL = "http://www.google.com"
        let googleURL = GoogleURL(longURL: expectedLongURL)

        mut.googleURL = googleURL

        XCTAssertEqual(mut.longURLField.text, expectedLongURL)
    }

    func testSetFields_MethodForSettingFields_ShortURLFieldShouldHaveValueFromGoogleURLString() {
        let expectedShortURL = "http://www.google.com"
        let googleURL = GoogleURL(shortURL: expectedShortURL)

        mut.googleURL = googleURL

        XCTAssertEqual(mut.shortURLField.text, expectedShortURL)
    }

    func testShorternerButton_EnabledDisabled_EnabledWhenValidURLInLongURL() {
        let googleURL = GoogleURL(longURL: "http://www.google.com")

        mut.shortenURLButton.isEnabled = false
        mut.googleURL = googleURL

        XCTAssertTrue(mut.shortenURLButton.isEnabled)
    }

    func testShorternerButton_EnabledDisabled_DisabledWhenInvalidURLInLongURL() {
        let googleURL = GoogleURL(longURL: "not an url")

        mut.shortenURLButton.isEnabled = true
        mut.googleURL = googleURL

        XCTAssertFalse(mut.shortenURLButton.isEnabled)
    }

    func testLookupButton_EnabledDisabled_EnabledWhenValidURLInLongURL() {
        let googleURL = GoogleURL(shortURL: "http://www.google.com")

        mut.lookupURLButton.isEnabled = false
        mut.googleURL = googleURL

        XCTAssertTrue(mut.lookupURLButton.isEnabled)
    }

    func testLookupButton_EnabledDisabled_DisabledWhenInvalidURLInLongURL() {
        let googleURL = GoogleURL(shortURL: "not an url")

        mut.lookupURLButton.isEnabled = true
        mut.googleURL = googleURL

        XCTAssertFalse(mut.lookupURLButton.isEnabled)
    }
}
