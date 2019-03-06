//
//  LoginUser.swift
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

final class LoginUser: RequestModel {
    
    typealias Response = Token
    
    var path: String {
        return "/Oauth/rest/oauthApps/userToken"
    }
    
    var queryParameters: [String : Any] {
        var q: [String: Any] = [:]
        q.appendingQueryParameter(key: "domain", value: domain)
        
        return q
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        return header as! [String : String]
    }
    
    var httpBody: Data? {
        var body: [String: Any] = [:]
        body.appendingQueryParameter(key: "userName", value: userId)
        body.appendingQueryParameter(key: "appKey", value: appKey)
        body.appendingQueryParameter(key: "appSecret", value: appSecret)
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        return jsonData
    }
    
    var httpMethod: HTTP {
        return .post
    }
    
    private let domain: String
    
    private let appKey: String
    
    private let appSecret: String
    
    private let userId: String
    
    init(appKey: String, appSecret: String, userId: String) {
        self.domain = AsistaCore.shared.tenantURL.deletePrefix("https://")
        self.appKey = appKey
        self.appSecret = appSecret
        self.userId = userId
    }
}
