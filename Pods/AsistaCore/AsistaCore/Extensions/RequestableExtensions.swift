//
//  RequestableExtensions.swift
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

extension RequestModel {
    
    var baseURL: URL {
        return URL(string: AsistaCore.shared.tenantURL)!
    }
    
    var queryParameters: [String: Any] {
        return [:]
    }
    
    var headerField: [String: String] {
        return [:]
    }
    
    var isAuthorizedRequest: Bool {
        return false
    }
    
    var httpBody: Data? {
        return nil
    }
    
    var isNoContent: Bool {
        return false
    }
    
    var disableCache: Bool {
        return false
    }
    
    func buildURLRequest() -> URLRequest {
        
        let url = baseURL.appendingPathComponent(path)
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = httpMethod.rawValue
        
        urlRequest.timeoutInterval = 10
        
        if disableCache {
            urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        }
        
        var header = headerField
        header["device-type"] = "mobile"
        if isAuthorizedRequest {
            header["X-Auth-Token"] = AsistaCore.shared.accessToken
        }
        
        header.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        if let body = httpBody {
            urlRequest.httpBody = body
        }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return urlRequest
        }
        
        urlComponents.query = queryParameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        urlRequest.url = urlComponents.url
        return urlRequest
    }
}
