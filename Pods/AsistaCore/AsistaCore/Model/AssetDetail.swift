//
//  AssetDetail.swift
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

/// Used to store `AssetDetail` data associated with a decoded response.
public struct AssetDetail: Codable {
    public let header: AssetDetailHeader
    public let payload: AssetDetailPayload
}

public struct AssetDetailHeader: Codable {
    public let state: String
    public let startDate: String
    public let endDate: String
    public let model: String
    public let item: String
    public let category: String
    public let itemDec: String
    public let defaultGrouped: Bool
    public let team: String
}

public struct AssetDetailPayload: Codable {
    public let state: String
    public let startDate: Double
    public let endDate: Double
    public let customFields: [CustomField]
    public let model: String
    public let item: String
    public let category: String
    public let itemDec: String
    public let itemId: Int
    public let team: String
}

public struct CustomField: Codable {
    public let name: String
    public let type: String
    public let data: String
    public let label: String
}
