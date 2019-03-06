//
//  AssetList.swift
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

/// Used to store `AssetList` data associated with a decoded response.
public struct AssetList: Codable, Equatable {
    public let header: AssetHeader
    public let payload: [AssetPayload]
    public var assetCount: Int?
  
    public init() {
        self.header = AssetHeader()
        self.payload = [AssetPayload]()
        self.assetCount = nil
    }
    
    public static func == (lhs: AssetList, rhs: AssetList) -> Bool {
        return lhs.header == rhs.header
            && lhs.payload == rhs.payload
    }
}


public struct AssetHeader: Codable, Equatable {
    public let state: String?
    public let itemDec: String?
    public let model: String?
    public let item: String?
    public let category: String?
    public let startDate: String?
    public let endDate: String?
    public let defaultGrouped: Bool?
    public let team: String?
    
    public init() {
        self.state = nil
        self.itemDec = nil
        self.model = nil
        self.item = nil
        self.category = nil
        self.startDate = nil
        self.endDate = nil
        self.defaultGrouped = nil
        self.team = nil
    }
}

public struct AssetPayload: Codable, Equatable {
     public let id: Int
     public let state: String
     public let itemDec: String
     public let isAnonymous: Bool
     public let model, item: String
     public let category: String
     public let startDate, endDate: Int?
     public let isAuthenticOnly: Bool
     public let companyId: Int?
     public let teamId: Int?
     public let isSharedTeam: Bool
     public let isSharedCompany: Bool
     public let team: String
     public let friendlyName: String?
     public let primaryOwnerEmail: String?
     public let primaryOwnerName: String?
     public let secondaryOwnerName: String?
     public let secondaryOwnerEmail: String?
}
