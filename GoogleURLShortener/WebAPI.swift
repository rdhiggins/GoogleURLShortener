//
// WebAPI.swift
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




/// used for returning results from WebAPI calls
enum WebAPIResult<A, Error> {
    case Success(A)
    case Failure(Error)
}

enum WebAPIOperation {
    case Get
    case Post(data: NSData)
}


/// Protocol used for a WebAPI router component
protocol WebAPIRouter {
    var request: NSMutableURLRequest? { get }
    var method: WebAPIOperation { get }
}



struct WebAPI {
    static func request(router: WebAPIRouter, handler: (WebAPIResult<NSData, WebAPIErrors>) -> Void) {
        if let request = router.request {
            var task: NSURLSessionTask?
            
            switch router.method {
            case .Get:
                task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
                    handler(parseResponse(data, response: response, error: error))
                }
            case let .Post(data):
                task = NSURLSession.sharedSession().uploadTaskWithRequest(request, fromData: data) { (data, response, error) in
                    handler(parseResponse(data, response: response, error: error))
                }
            }
            
            task?.resume()
        } else {
            handler(WebAPIResult.Failure(.NoRequest))
        }
    }
    
    private static func parseResponse(data: NSData?, response: NSURLResponse?, error: NSError?) -> WebAPIResult<NSData, WebAPIErrors> {
        var r: WebAPIResult<NSData, WebAPIErrors>?
        
        if error != nil {
            r = WebAPIResult.Failure(.BadRequest)
        } else if let rsp = response as? NSHTTPURLResponse where 200...299 ~= rsp.statusCode {
            if let d = data {
                r = WebAPIResult.Success(d)
            } else {
                r = WebAPIResult.Failure(.NoData)
            }
        } else if let rsp = response as? NSHTTPURLResponse {
            r = WebAPIResult.Failure(.BadStatusCode(rsp.statusCode))
        } else {
            r = WebAPIResult.Failure(.NoResponse)
        }
        
        return r!
    }
    
    
    static func parseJSON(data: NSData) -> [String: AnyObject]? {
        var json: [String: AnyObject]?
        
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject]
        } catch _ {}
        
        return json
    }
}
