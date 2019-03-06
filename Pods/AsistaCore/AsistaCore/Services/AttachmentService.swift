//
//  AttachmentService.swift
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

public class AttachmentService {
    
    
    /// Returns the properties of attachment that uploading to the server
    ///
    /// - Parameter completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func fetchAttachmentProperties(completionHandler: @escaping (ResultModel<AttachmentProperties, AsistaError>) -> Void) {
        let request = GetAttachmentProperties()
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(GetAttachmentProperties.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    
    /// Returns the image in `data` format when calls with the url of the image
    ///
    /// - Parameters:
    ///   - url: url path in which image is situated.
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func fetchImage(url: String, completionHandler: @escaping (ResultModel<Data, AsistaError>) -> Void) {
        
        let request = GetImage(imagePath: url)
            
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                completionHandler(.success(response.data!))
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    
    /// Download file to internal storage od the device and returns its filepath
    ///
    /// - Parameters:
    ///   - fileUrl: `url` in which file is situated.
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func downloadFile(fileUrl: String, completionHandler: @escaping (ResultModel<URL, AsistaError>) -> Void) {
        Networking.shared.performFileDownload(url: fileUrl) { (response) in
            switch response {
            case .success(let response):
                completionHandler(.success(response.destinationURL!))
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
}
