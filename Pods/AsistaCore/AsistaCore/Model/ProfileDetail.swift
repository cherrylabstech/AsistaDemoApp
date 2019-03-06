//
//  ProfileDetail.swift
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

/// Used to store `ProfileDetail` data associated with a decoded response.
public struct ProfileDetail: Codable {
    public let language: String?
    public let state: String?
    public let country: String?
    public let email: String
    public let phone: String
    public let userID: Int
    public let company: String?
    public let city: String?
    public let notificationEmail: String
    public let designation: String?
    public let firstName: String
    public let lastName: String?
    public let addressLine1: String?
    public let addressLine2: String?
    public let postalCode: String?
    public let altPhone: String?
    public let timezoneID: Int
    public let teamAgent: String?
    public let teamSupervisor: String?
    public let activityDetails: [ActivityDetail]
    public let image: String
    
    enum CodingKeys: String, CodingKey {
        case language = "language"
        case state = "state"
        case country = "country"
        case email = "email"
        case phone = "phone"
        case userID = "userId"
        case company = "company"
        case city = "city"
        case notificationEmail = "notification_email"
        case designation = "designation"
        case firstName = "first_name"
        case lastName = "last_name"
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case postalCode = "postal_code"
        case altPhone = "alt_phone"
        case timezoneID = "timezone_id"
        case teamAgent = "teamAgent"
        case teamSupervisor = "teamSupervisor"
        case activityDetails = "activityDetails"
        case image = "image"
    }
}

public struct ActivityDetail: Codable {
    public let id: Int
    public let clientActivity: String
    public let activityTime: Int
}
