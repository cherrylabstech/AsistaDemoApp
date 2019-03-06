//
//  Theme.swift
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

/// Used to store `Theme` data associated with a decoded response.
public struct Theme: Codable, Equatable {
    public let name: String?
    public let id: Int
    public let isAnonymous: Bool
    public let passwordRegex: String?
    public let logo: String?
    public let rc: Bool
    public let emailRegex: String?
    public let colour: String?
    public let displayTitle: Bool
    public let isPickTicket: Bool
    public let clientLocationFilter: Bool
    public let signUp: Bool
    public let footerOnOff: Bool
    public let rcTabName: String?
    public let searchTitle: String?
    public let passwordPolicy: String?
    public let captcha: Bool
    
    public init() {
        self.name = nil
        self.id = 0
        self.isAnonymous = false
        self.passwordRegex = nil
        self.logo = nil
        self.rc = false
        self.emailRegex = nil
        self.colour = nil
        self.displayTitle = false
        self.isPickTicket = false
        self.clientLocationFilter = false
        self.signUp = false
        self.footerOnOff = false
        self.rcTabName = nil
        self.searchTitle = nil
        self.passwordPolicy = nil
        self.captcha = false
    }
}
