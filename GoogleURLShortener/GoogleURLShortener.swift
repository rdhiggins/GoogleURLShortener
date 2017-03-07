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
    case success(A)
    case failedParse
    case failure(Error)
}

typealias GUSResult = GoogleURLShortenerResults<GoogleURL,WebAPIErrors>

struct GoogleURLShortener {
    
    static func requestShorten(_ longURL: String, handler: @escaping (GUSResult) -> Void) {
        
        WebAPI.request(GoogleURLShortenerRouter.shorten(longURL: longURL)) { result in
            callHandler(parseResponse(result), handler: handler)
        }
    }
    
    
    static func requestLookup(_ shortURL: String, handler: @escaping (GUSResult) -> Void) {
        
        WebAPI.request(GoogleURLShortenerRouter.lookup(shortURL: shortURL)) { result in
            callHandler(parseResponse(result), handler: handler)
        }
    }
    
    
    fileprivate static func callHandler(_ result: GUSResult, handler: @escaping (GUSResult) -> Void) {
        DispatchQueue.main.async {
            handler(result)
        }
    }
    
    fileprivate static func parseResponse(_ result: WebAPIResult<Data, WebAPIErrors>) -> GUSResult {
        var r: GUSResult?
        
        switch result {
        case let .failure(error):
            r = GUSResult.failure(error)
        case let .success(data):
            if let gu = parseJSONData(data) {
                r = GUSResult.success(gu)
            } else {
                r = GUSResult.failedParse
            }
        }

        return r!
    }
    
    fileprivate static func parseJSONData(_ data: Data) -> GoogleURL? {
        
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
