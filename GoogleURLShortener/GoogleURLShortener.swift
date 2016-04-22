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

/// WebAPIRouter for the Google URL Shortener API
enum GoogleURLShortenerRouter: WebAPIRouter {
    static let basePath  = "https://www.googleapis.com/urlshortener/v1/url"
    
    case Shorten(longURL: String)
    case Lookup(shortURL: String)
    
    var url: NSURL? {
        switch self {
        case .Shorten:
            return NSURL(string: GoogleURLShortenerRouter.basePath + queryString())
        case let .Lookup(url):
            return NSURL(string: GoogleURLShortenerRouter.basePath + queryString(["shortUrl": url]))
        }
    }
    
    var request: NSMutableURLRequest? {
        var request: NSMutableURLRequest?
        
        if let url = self.url {
            request = NSMutableURLRequest(URL: url)
            
            switch self {
            case .Shorten:
                request?.HTTPMethod = "POST"
                request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
            case .Lookup:
                request?.HTTPMethod = "GET"
            }
        }
        
        return request
    }
    
    var method: WebAPIOperation {
        switch self {
        case let .Shorten(longURL):
            var data: NSData?
            
            do {
                data = try NSJSONSerialization.dataWithJSONObject(["longUrl": longURL], options: NSJSONWritingOptions())
            }
            catch _ {}
            
            return WebAPIOperation.Post(data: data!)
        case .Lookup:
            return .Get
        }
    }
    
    
    /// Function that generates the query parameter portion of the URL.
    /// Always encodes the API Key into the string.  Then optionally includes
    /// any passed parameters.
    private func queryString(queryParameters: [String: String]? = nil) -> String {
        if let apiKey = sharedSecrets.googleAPIKey {
            var qs: String = "?key=\(apiKey)"
            
            if let p = queryParameters {
                for (k, value) in p {
                    if let encodedValue = value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
                        qs += "&\(k)=\(encodedValue)"
                    }
                }
            }
            
            return qs
        }
        
        return ""
    }
    
}
