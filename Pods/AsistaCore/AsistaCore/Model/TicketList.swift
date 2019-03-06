//
//  TicketList.swift
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

/// Used to store `TicketList` data associated with a decoded response.
public struct TicketList: Codable {
    public let header: TicketHeader
    public let payload: [TicketPayload]
    public var ticketCount: Int?
    
    public init() {
        self.header = TicketHeader()
        self.payload = [TicketPayload]()
        self.ticketCount = nil
    }
    
}

public struct TicketHeader: Codable {
    public let priority: String?
    public let state: String?
    public let source: String?
    public let subject: String?
    public let requestNo: String?
    public let company: String?
    public let createdTime: String?
    public let modifiedTime: String?
    public let assets: String?
    public let technician: String?
    
    public init() {
        self.priority = nil
        self.state = nil
        self.technician = nil
        self.assets = nil
        self.modifiedTime = nil
        self.source = nil
        self.subject = nil
        self.requestNo = nil
        self.company = nil
        self.createdTime = nil
    }
}

public struct TicketPayload: Codable {
    public let priority: String
    public let state: String
    public let createdBy: String
    public let subject: String
    public let source: Int
    public let tech: String
    public let requestSlaTagFriendlyName: String?
    public let requestId: Int
    public let created: String
    public let requestNo: String
    public let createTime: Int
    public let priorityId: Int?
    public let requestSlaTagName: String?
    public let requestSlaTagColor: String?
    public let modifiedTime: Int
    public let requestSlaTagId: Int?
    public let stateId: Int
    public let notesTransfer: String?
    
    
    enum CodingKeys: String, CodingKey {
        case priority
        case state
        case createdBy
        case createTime
        case source
        case subject
        case created
        case requestNo
        case tech
        case requestId
        case priorityId
        case requestSlaTagFriendlyName
        case requestSlaTagName
        case requestSlaTagColor
        case modifiedTime
        case requestSlaTagId
        case stateId = "state_id"
        case notesTransfer
    }
}
