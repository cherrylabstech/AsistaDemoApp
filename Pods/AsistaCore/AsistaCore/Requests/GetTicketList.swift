//
//  GetTicketList.swift
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

final class GetTicketList: RequestModel {
    
    typealias Response = TicketList
    
    var path: String {
        return "/servicedesk/api/v1/requests/1"
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        return header as! [String : String]
    }
    
    var queryParameters: [String : Any] {
        var q: [String: Any] = [:]
        q.appendingQueryParameter(key: "state", value: "")
        q.appendingQueryParameter(key: "from", value: from)
        q.appendingQueryParameter(key: "to", value: to)
        q.appendingQueryParameter(key: "originated", value: "false")
        q.appendingQueryParameter(key: "order", value: "desc")
        q.appendingQueryParameter(key: "sortBy", value: "UPDATE-TIME")
        
        return q
    }
    
    var isAuthorizedRequest: Bool {
        return AsistaCore.shared.accessToken.isEmpty ? false : true
    }
    
    var httpMethod: HTTP {
        return .get
    }
    
    private let from: Int
    
    private let to: Int
    
    init(from: Int, to: Int) {
        self.from = from
        self.to = to
    }
}
