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

/// WebAPI structure.  Mostly a placeholder for the static methods that
/// that the API provides.
struct WebAPI {
    
    /// Method that invokes the required http operation.
    ///
    /// - parameter router: A WebAPIRouter object
    /// - parameter handler: A block that is called when the operation is 
    /// complete.
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

    /// Method that converts NSData to a JSON dictionary
    ///
    /// - parameter data: The NSData that needs to be converted
    /// - returns: A [String: AnyObject] on success that contains the JSON
    /// data.  Else nil if there was an error
    static func parseJSON(data: NSData) -> [String: AnyObject]? {
        var json: [String: AnyObject]?
        
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject]
        } catch _ {}
        
        return json
    }
    
    /// A private method used to parse the http response received.
    ///
    /// - parameter data: optional NSData parameter
    /// - parameter response: optional NSURLResponse
    /// - parameter error: optional NSError
    ///
    /// - returns: WebAPIResult<NSData, WebAPIErrors> that contains the decoded
    /// results of the operation
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
}
