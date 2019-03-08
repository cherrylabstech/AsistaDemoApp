//
//  Networking.swift
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

import Alamofire
import Foundation

class Networking {
    
    static let shared = Networking()
    
    var AFManager = Alamofire.SessionManager()
    init() {
        AFManager = {
            let trustPolicies: [String: ServerTrustPolicy] = ["dev.asista.in": .disableEvaluation,
                                                              "m1.asista.in": .disableEvaluation,
                                                              "assist.asista.in": .disableEvaluation]
            let AFConfig = URLSessionConfiguration.default
            AFConfig.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
            let manager = Alamofire.SessionManager( configuration: URLSessionConfiguration.default, serverTrustPolicyManager: ServerTrustPolicyManager(policies: trustPolicies) )
            return manager
        }()
    }
    
    var isReachable: Bool {
        return NetworkReachabilityManager()!.isReachableOnEthernetOrWiFi
    }
    
    
    /// Performs http request with the server
    ///
    /// - Parameters:
    ///   - request: The `request` object which conforms to `RequestModel`
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    func performRequest<T: RequestModel>(_ request: T, completionHandler: @escaping (ResultModel<DataResponse<Any>, AsistaError>) -> Void) {
        guard isReachable else {
            completionHandler(.failed(.noNetworkReachability))
            return
        }
        
        let adapterRequest = request.buildURLRequest()
        AFManager.request(adapterRequest)
            .responseJSON { (response) in
                
                let statusCode = response.response?.statusCode ?? -1
                
                switch statusCode {
                case 200...299:
                    completionHandler(.success(response))
                case 499:
                    AuthService.tokenRefresh(completionHandler: { ( _) in })
                case 401:
                    completionHandler(.failed(.invalidPassword(statusCode)))
                case 451:
                    completionHandler(.failed(.userNotRegistered(statusCode)))
                case 452:
                    completionHandler(.failed(.userSuspended(statusCode)))
                case 457:
                    completionHandler(.failed(.userNotExist(statusCode)))
                case 458:
                    completionHandler(.failed(.userNotVerified(statusCode)))
                case 465:
                    completionHandler(.failed(.changePassword(statusCode)))
                case 472:
                    completionHandler(.failed(.resetPassword(statusCode)))
                default:
                    if let result = response.result.value as? [String: String] {
                        if let message = result["message"] {
                            completionHandler(.failed(.unexpectedResponse(message)))
                        }
                        else if let response = result["response"] {
                            completionHandler(.failed(.unexpectedResponse(response)))
                        }
                        else {
                            completionHandler(.failed(.unexpectedResponse(result)))
                        }
                    }
                    else {
                        completionHandler(.failed(.unexpectedResponse("Unexpected Response")))
                    }
                }
        }
    }
    
    
    /// Peforms file download with the server
    ///
    /// - Parameters:
    ///   - url: The `url` in which file to be downloded
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    func performFileDownload(url: String, completionHandler: @escaping (ResultModel<DownloadResponse<Data>, AsistaError>) -> Void) {
        guard isReachable else {
            completionHandler(.failed(AsistaError.noNetworkReachability))
            return
        }
        
        let fileUrl = AsistaCore.shared.tenantURL + url
        let destinationDirectory = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        AFManager.download(fileUrl, to: destinationDirectory)
            .responseData { (downloadResponse) in
             
                switch downloadResponse.result {
                case .success(_):
                    completionHandler(.success(downloadResponse))
                    return
                case .failure(let error):
                    if downloadResponse.destinationURL != nil {
                        completionHandler(.success(downloadResponse))
                        return
                    }
                    else {
                        completionHandler(.failed(.unexpectedResponse(error)))
                        return
                    }
                }
        }
    }
    
    
    /// Peforms file upload with the server
    ///
    /// - Parameters:
    ///   - request: The `request` object which conforms to `RequestModel`
    ///   - file: Attributes of file. constains file in `data` format, filename and its mimetype
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    func performFileUpload<T: RequestModel>(_ request: T, file: FileParameters, completionHandler: @escaping (ResultModel<DataResponse<Data>, AsistaError>) -> Void) {
        guard isReachable else {
            completionHandler(.failed(AsistaError.noNetworkReachability))
            return
        }
        
        AFManager.upload(multipartFormData: { (MultipartFormData) in
            MultipartFormData.append(file.data, withName: "file", fileName: file.name, mimeType: file.mimeType)
        }, with: request.buildURLRequest()) { (encodingResult) in
            switch encodingResult {
                
            case .success(let upload, _, _):
                upload.responseData { response in
                    completionHandler(.success(response))
                    return
                }
            case .failure(let error):
                completionHandler(.failed(.unexpectedResponse(error)))
                return
            }
        }
    }
}
