//
// GoogleURLShortenerRouter.swift
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
enum GoogleURLShortenerRouter {
    static let basePath  = "https://www.googleapis.com/urlshortener/v1/url"
    static var apiKey: String = ""

    case shorten(longURL: String)       // Shorten a long URL
    case lookup(shortURL: String)       // Lookup the short version of a long URL
    
    /// property that gives the url
    var url: URL? {
        switch self {
        case .shorten:
            return URL(string: GoogleURLShortenerRouter.basePath + queryString())
        case let .lookup(url):
            return URL(string: GoogleURLShortenerRouter.basePath + queryString(["shortUrl": url]))
        }
    }
    
    /// Function that generates the query parameter portion of the URL.
    /// Always encodes the API Key into the string.  Then optionally includes
    /// any passed parameters.
    ///
    /// - parameter queryParameters: A [String: String]? dictionary of
    /// query parameters to encode into the url
    /// - returns: a url represented as a String
    func queryString(_ queryParameters: [String: String]? = nil) -> String {
        var qs: String = "?key=\(GoogleURLShortenerRouter.apiKey)"

        if let p = queryParameters {
            for (k, value) in p {
                if let encodedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                    qs += "&\(k)=\(encodedValue)"
                }
            }
        }

        return qs
    }
}




extension GoogleURLShortenerRouter: WebAPIRouter {

    /// WebAPIRouter protocol property that returns a NSMutableURLRequest
    var request: URLRequest? {
        var request: URLRequest?
        
        if let url = self.url {
            request = URLRequest(url: url)
            
            switch self {
            case .shorten:
                request?.httpMethod = "POST"
                request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
            case .lookup:
                request?.httpMethod = "GET"
            }
        }
        
        return request
    }
    
    /// WebRouter protocol property that returns the WebAPIOperations that
    /// is required for the requested operation
    var method: WebAPIOperations {
        switch self {
        case let .shorten(longURL):
            var data: Data?
            
            do {
                data = try JSONSerialization.data(withJSONObject: ["longUrl": longURL], options: JSONSerialization.WritingOptions())
            }
            catch _ {}
            
            return WebAPIOperations.post(data: data!)
        case .lookup:
            return .get
        }
    }
}
