//
//  UserProfileService.swift
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

public class UserProfileService {
    
    /// Returns the theme details of the tenant. Provides daat on both anonymous and non-anonymous requests
    ///
    /// - Parameter completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func fetchTheme(completionHandler: @escaping (ResultModel<Theme, AsistaError>) -> Void) {
        let request = GetTheme()
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(GetTheme.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    
    /// Returns the profile details of the logined user
    ///
    /// - Parameter completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func fetchProfile(completionHandler: @escaping (ResultModel<Profile, AsistaError>) -> Void) {
        let request = GetProfile()
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(GetProfile.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    
    /// Returns the detailed profile data of the logined user
    ///
    /// - Parameter completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func fetchDetailedProfile(completionHandler: @escaping (ResultModel<ProfileDetail, AsistaError>) -> Void) {
        let request = GetProfileDetails()
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(GetProfileDetails.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    
    /// Performs user profile updation
    ///
    /// - Parameters:
    ///   - parameters: Dictionary value contains update data.
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func updateProfile(parameters: Dictionary<String, Any>, completionHandler: @escaping (ResultModel<ProfileResponse, AsistaError>) -> Void) {
        let request = UpdateProfile(parameters: parameters)
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(UpdateProfile.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    
    /// Returns the list of timezones of tenant
    ///
    /// - Parameter completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func fetchTimezoneList(completionHandler: @escaping (ResultModel<[Zone], AsistaError>) -> Void) {
        let request = GetTimeZoneList()
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(GetTimeZoneList.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    
    /// Updates the current timezone of the user
    ///
    /// - Parameters:
    ///   - zoneId: Unique id for each timezones
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func updateTimezone(zoneId: Int, completionHandler: @escaping (ResultModel<MsgResponse, AsistaError>) -> Void) {
        let request = UpdateTimeZone(zoneID: zoneId)
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(UpdateTimeZone.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    
    /// Upload and update profile picture of the user.
    ///
    /// - Parameters:
    ///   - fileParameters: Attributes of image. constains image in `data` format, filename and its mime type
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func updateProfileImage(url: URL, completionHandler: @escaping (ResultModel<MsgResponse, AsistaError>) -> Void) {
        let request = UpdateProfileImage()
        
        let data = try! Data(contentsOf: url.absoluteURL)
        let name = url.lastPathComponent
        let mimeType = url.path.getMimeType()
        let file = FileParameters(data: data, name: name, mimeType: mimeType)
        
        Networking.shared.performFileUpload(request, file: file) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(UpdateProfileImage.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
}
