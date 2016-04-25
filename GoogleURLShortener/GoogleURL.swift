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

import UIKit

private let urlRegEx = "^(http(s)?://.)?(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]*)$"

struct GoogleURL {
    private static let defaultURLString = "unknown"
    var longURL: String
    var shortURL: String

    /// Returns true when the contents of the shortURL property is a valid URL
    var isShortURLValid: Bool {
        return isURLValid(shortURL)
    }

    /// Returns true when the contents of the longURL property is a valid URL
    var isLongURLValid: Bool {
        return isURLValid(longURL)
    }

    init(longURL: String, shortURL: String = GoogleURL.defaultURLString) {
        self.longURL = longURL
        self.shortURL = shortURL
    }

    init(shortURL: String, longURL: String = GoogleURL.defaultURLString) {
        self.shortURL = shortURL
        self.longURL = longURL
    }

    init() {
        self.longURL = GoogleURL.defaultURLString
        self.shortURL = GoogleURL.defaultURLString
    }


    /// Private function used to test the validity of a string as a URL
    private func isURLValid(path: String) -> Bool {
        if let regex =
            try? NSRegularExpression(pattern: urlRegEx,
                                     options: NSRegularExpressionOptions.CaseInsensitive) {
            
            
            let match = regex.numberOfMatchesInString(path,
                                options: .ReportCompletion, range:
                                NSRange(location: 0, length: path.characters.count))
            
            if match > 0 {
                return true
            }
        }

        return false
    }
}
