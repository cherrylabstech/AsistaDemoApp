//
//  Requestable.swift
//
//  Copyright (c) 2019 Cherrylabs Technologies (http://cherrylabs.com/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

protocol RequestModel {
    
    // The response of `RequestModel` expects either JSON object or empty.
    associatedtype Response: Encodable
    
    // The base of URL.
    var baseURL: URL { get }
    
    // The path of URL.
    var path: String { get }
    
    // The header field of HTTP.
    var headerField: [String: String] { get }
    
    // If the request needs Token authorization, this will set `true`. The default value is `false`.
    var isAuthorizedRequest: Bool { get }
    
    // The http method. e.g. `.get`
    var httpMethod: HTTP { get }
    
    // The http body parameter, The default value is `nil`.
    var httpBody: Data? { get }
    
    // Additional query paramters for URL, The default value is `[:]`.
    var queryParameters: [String: Any] { get }
    
    // If the response is empty, this should be true.
    var isNoContent: Bool { get }
    
    // If the request need to disable cache, this will set `true`. The default value is `false`.
    var disableCache: Bool { get }
}


