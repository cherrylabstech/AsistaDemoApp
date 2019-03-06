//
//  AuthService.swift
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

public class AuthService {
   
    /// Performs user authentication by `appKey`, `appSecret` and `userId`
    ///
    /// - Parameters:
    ///   - parameters: Dictionary value representing the  login credentials.
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func authenticate(appKey: String, appSecret: String, userId: String, completionHandler: @escaping (ResultModel<Bool, AsistaError>) -> Void) {
        let request = LoginUser(appKey: appKey, appSecret: appSecret, userId: userId)
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(LoginUser.Response.self, from: response.data!)
                    AuthService.saveTokens(with: result)
                    completionHandler(.success(true))
                    
                } catch let error {
                    completionHandler(.failed(.invalidData(error.localizedDescription)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    /// Performs user registration from client App
    ///
    /// - Parameters:
    ///   - user: Object of RegisterUser model which contains the credentials for registering user
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func register(_ user: RegisterUser, completionHandler: @escaping (ResultModel<Bool, AsistaError>) -> Void) {
        let request = user
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success( _):
                completionHandler(.success(true))
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    /// Performs `AccessToken` refresh from server
    ///
    /// - Parameter completionHandler: The closure called when the `ResultModel` encoding is complete.
    class func tokenRefresh(completionHandler: @escaping (ResultModel<Token, AsistaError>) -> Void) {
        let request = RefreshTokens()
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(RefreshTokens.Response.self, from: response.data!)
                    AuthService.saveTokens(with: result)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    /// Requests a password reset with the Asista server
    ///
    /// - Parameters:
    ///   - email: email connected to the requesting account.
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func requestPasswordReset(email: String, completionHandler: @escaping (ResultModel<PasswordResetResponse, AsistaError>) -> Void) {
        let request = RequestPasswordReset(email: email)
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(RequestPasswordReset.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    
    
    
    /// Performs password change for logined users
    ///
    /// - Parameters:
    ///   - oldPassword: old password of the user
    ///   - newPassword: new password of the user
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func changePassword(oldPassword: String, newPassword: String, completionHandler: @escaping (ResultModel<MsgResponse, AsistaError>) -> Void) {
        let request = ChangePassword(old: oldPassword, new: newPassword)
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(ChangePassword.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                   completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    
    /// Reset password of non-logined user
    ///
    /// - Parameters:
    ///   - otp: `otp` received on external channels during password reset request
    ///   - newPassword: new password of the user
    ///   - tempId: unique `id` received during password reset request
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func resetPassword(otp: String, newPassword: String, tempId: String, completionHandler: @escaping (ResultModel<ResponseMsg, AsistaError>) -> Void) {
        let request = ResetPassword(key: otp, newPass: newPassword, tempID: tempId)
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(ResetPassword.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    
    /// Sign out the user from the logined session and invalidate token
    ///
    /// - Parameter completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func signOut(completionHandler: @escaping (_ status: Bool) -> Void) {
        let request = SignOut()
        AuthService.clearTokens()
        completionHandler(true)
        Networking.shared.performRequest(request) { (response) in }
    }
    
    class func saveTokens(with token: Token) {
        UserDefaults.standard.set(token.accessToken, forKey: "accessToken")
        UserDefaults.standard.set(token.refreshToken, forKey: "refreshToken")
        UserDefaults.standard.synchronize()
        
        AsistaCore.shared.accessToken =  token.accessToken!
        AsistaCore.shared.refreshToken =  token.refreshToken!
    }
    
    
    class func clearTokens() {
        UserDefaults.standard.set("", forKey: "accessToken")
        UserDefaults.standard.set("", forKey: "refreshToken")
        UserDefaults.standard.synchronize()
        
        AsistaCore.shared.accessToken = ""
        AsistaCore.shared.refreshToken = ""
    }
    
}
