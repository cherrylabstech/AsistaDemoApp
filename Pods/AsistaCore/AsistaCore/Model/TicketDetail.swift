//
//  TicketDetail.swift
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

/// Used to store `TicketDetail` data associated with a decoded response.
public struct TicketDetail: Codable {
    public let header: TicketDetailHeader
    public let payload: TicketDetailPayload
    
    public init() {
        self.header = TicketDetailHeader()
        self.payload = TicketDetailPayload()
    }
}

public struct TicketDetailHeader: Codable {
    public let priority: String
    public let state: String
    public let source: String
    public let subject: String
    public let requestNo: String
    public let company: String
    public let createdTime: String
    public let modifiedTime: String
    public let assets: String
    public let technician: String
    
    public init() {
        self.priority = ""
        self.state = ""
        self.createdTime = ""
        self.requestNo = ""
        self.company = ""
        self.subject = ""
        self.source = ""
        self.modifiedTime = ""
        self.assets = ""
        self.technician = ""
    }
}

public struct TicketDetailPayload: Codable {
    public let priority: String
    public let state: String
    public let createdBy: String
    public let categoryId: Int
    public let parentId: String?
    public let createTime: Int
    public let userStateLabel: String
    public let created: String
    public let stateId: Int
    public let childTicket: Bool
    public let requestNo: String
    public let company: String?
    public let requestSlaTagFriendlyName: String?
    public let team: String
    public let tech: String
    public let notes: [Note]
    public let clientId: Int
    public let contentType: String
    public let item: String
    public let subject: String
    public let description: String
    public let source: Int
    public let attachment: [Attachment]
    public let category: String
    public let slaId: Int
    public let requestId: Int
    public let sla: String
    public let priorityId: Int
    public let branch: String?
    public let requestSlaTagName: String?
    public let requestSlaTagColor: String?
    public let modifiedTime: Int
    public let customFields: [DetailCustomField]
    public let userCategoryLabel: String
    public let isAsisted: Bool
    public let requesterTenant: String?
    public let requestSlaTagId: Int
    public let clientEmail: String?
    
    public init() {
        self.priority = ""
        self.state = ""
        self.createdBy = ""
        self.categoryId = 0
        self.parentId = nil
        self.createTime = 0
        self.userStateLabel = ""
        self.created = ""
        self.stateId = 0
        self.childTicket = false
        self.requestNo = ""
        self.company = nil
        self.requestSlaTagFriendlyName = ""
        self.team = ""
        self.tech = ""
        self.notes = [Note]()
        self.clientId = 0
        self.contentType = ""
        self.item = ""
        self.subject = ""
        self.description = ""
        self.source = 0
        self.attachment = [Attachment]()
        self.category = ""
        self.slaId = 0
        self.requestId = 0
        self.sla = ""
        self.priorityId = 0
        self.branch = ""
        self.requestSlaTagName = nil
        self.requestSlaTagColor = nil
        self.modifiedTime = 0
        self.customFields = [DetailCustomField]()
        self.userCategoryLabel = ""
        self.isAsisted = false
        self.requesterTenant = nil
        self.requestSlaTagId = 0
        self.clientEmail = ""
    }
}

public struct Attachment: Codable {
    public let url: String
}

public struct Note: Codable {
    public let userId: Int
    public let image: String?
    public let createTime: String
    public let contentType: String
    public let subject: String
    public let attachment: [Attachment]
    public let noteId: Int
    public let technicianId: String
    public let isPrivate: Bool
    
    
    enum CodingKeys: String, CodingKey {
        case userId, image, createTime, contentType, subject, attachment, noteId, technicianId
        case isPrivate = "is_private"
    }
}

public struct DetailCustomField: Codable {
    public let name: String?
    public let type: String?
    public let data: String?
    public let label: String?
}
