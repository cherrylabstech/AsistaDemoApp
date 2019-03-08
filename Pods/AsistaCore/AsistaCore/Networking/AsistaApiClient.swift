//
//  AsistaApiClient.swift
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

/// Returns the instace of service classes
public class AsistaApiClient {
    
    /// Returns the instance of `KBService` class
    public func getKbService() -> KbService {
        return KbService()
    }
    
    /// Returns the instance of `AuthService` class
    public func getAuthService() -> AuthService {
        return AuthService()
    }
    
    /// Returns the instance of `TicketService` class
    public func getTicketService() -> TicketService {
        return TicketService()
    }
    
    /// Returns the instance of `UserProfileService` class
    public func getUserService() -> UserProfileService {
        return UserProfileService()
    }
    
    /// Returns the instance of `AssetService` class
    public func getAssetService() -> AssetService {
        return AssetService()
    }
    
    /// Returns the instance of `AttachmentService` class
    public func getAttachmentService() -> AttachmentService {
        return AttachmentService()
    }
    
    /// Returns the instance of `StateService` class
    public func getStateService() -> StateService {
        return StateService()
    }
    
    /// Returns the instance of `PriorityService` class
    public func getPriorityService() -> PriorityService {
        return PriorityService()
    }
    
    public init() {
        /// Retrieves the `attachment properties` of the the tenant.
        ///
        AttachmentService().fetchAttachmentProperties { (result) in
            if case .success(let attachment) = result {
                /// Storing `attachmentSize` and `attachmentTypes` in App constants.
                AsistaCore.attachmentSize = attachment.fileSize
                AsistaCore.attachmentTypes = attachment.fileType
            }
        }
       
        /// Retrieves the theme content of the selected tenant.
        ///
        UserProfileService().fetchTheme { (result) in
            if case .success(let theme) = result {
                /// Storing `passwordRegx` and `password policy` in App constants.
                AsistaCore.passwordRegx = theme.passwordRegex!
                AsistaCore.passwordPolicy = theme.passwordPolicy!.trimmingCharacters(in: .whitespaces)
            }
        }
    }
}

