//
//  ResponseError.swift
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


/// Used to represent the type of error occured during the network call.
///
public enum AsistaError: Error {
    case unacceptableStatusCode(Int)
    
    case invalidPassword(Int)
    case userNotRegistered(Int)
    case userSuspended(Int)
    case userNotExist(Int)
    case userNotVerified(Int)
    case changePassword(Int)
    case resetPassword(Int)
    
    case unexpectedResponse(Any?)
    case invalidAuthCredentials(Any)
    case invalidData(Any)
    case nullDataFound(Any)
    case nullResponse(Any)
    case noNetworkReachability
}


extension AsistaError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unacceptableStatusCode:
            return "Invalid status code"
        case .invalidPassword:
            return "Invalid Password"
        case .userNotRegistered:
            return "User not registered"
        case .userSuspended:
            return "User suspended"
        case .userNotExist:
            return "User not exist"
        case .userNotVerified:
            return "User not verified"
        case .changePassword:
            return "Change password"
        case .resetPassword:
            return "Reset Password"
        case .unexpectedResponse(let result):
            return "Error : \(String(describing: result))"
        case .invalidAuthCredentials:
            return "Invalid auth credentials"
        case .invalidData:
            return "Invalid data"
        case .nullDataFound:
            return "Null data found"
        case .noNetworkReachability:
            return "No network reachability"
        default:
            return "Invalid resposnse"
        }
    }
}
