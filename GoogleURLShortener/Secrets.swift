//
// Secrets.swift
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

import Foundation


struct Secrets {
    private let filename: String!
    private var dictionary: NSDictionary?
    
    init(filename: String) {
        self.filename = filename
        
        // Load the dictionary from the secrets file
        guard let filePath = NSBundle.mainBundle().pathForResource(filename, ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath) else {
            print("There appears to be no Secrets file, or the Secrets file does not contain a dictionary")
            fatalError()
        }
        
        self.dictionary = plist
    }
    
    var googleAPIKey: String? {
        get {
            guard let key = dictionary?["GoogleAPIKey"] as? String else {
                return nil
            }
            return key
        }
    }
}