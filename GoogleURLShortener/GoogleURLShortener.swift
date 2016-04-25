//
// GoogleURLShortener.swift
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

/// Returns the results of a GoogleURLShortener request
enum GoogleURLShortenerResults<A, Error> {
    case Success(A)
    case FailedParse
    case Failure(Error)
}

typealias GUSResult = GoogleURLShortenerResults<GoogleURL,WebAPIErrors>

struct GoogleURLShortener {
    
    static func requestShorten(longURL: String, handler: (GUSResult) -> Void) {
        
        WebAPI.request(GoogleURLShortenerRouter.Shorten(longURL: longURL)) { result in
            var r: GUSResult?
            
            switch result {
            case let .Failure(error):
                r = GUSResult.Failure(error)
            case let .Success(data):
                if let gu = parseJSONData(data) {
                    r = GUSResult.Success(gu)
                } else {
                    r = GUSResult.FailedParse
                }
            }
            
            callHandler(r!, handler: handler)
        }
    }
    
    
    static func requestLookup(shortURL: String, handler: (GUSResult) -> Void) {
        
        WebAPI.request(GoogleURLShortenerRouter.Lookup(shortURL: shortURL)) { result in
            var r: GUSResult?
            
            switch result {
            case let .Failure(error):
                r = GUSResult.Failure(error)
            case let .Success(data):
                if let gu = parseJSONData(data) {
                    r = GUSResult.Success(gu)
                } else {
                    r = GUSResult.FailedParse
                }
            }
            
            callHandler(r!, handler: handler)
        }
    }
    
    
    private static func callHandler(result: GUSResult, handler: (GUSResult) -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            handler(result)
        }
    }
    
    private static func parseJSONData(data: NSData) -> GoogleURL? {
        
        if let json = WebAPI.parseJSON(data) {
            if let shortURL = json["id"] as? String {
                if let longURL = json["longUrl"] as? String {
                    return GoogleURL(longURL: longURL, shortURL: shortURL)
                }
            }
        }
        
        return nil
    }
}