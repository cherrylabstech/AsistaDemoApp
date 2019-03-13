//
//  TicketService.swift
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

public class TicketService {
    
    var ticketCount: Int = 0
    var isFirstLoad: Bool = true
    
    /// Returns the tota; ticket count
    ///
    /// - Parameter completionHandler: The closure called when the `ResultModel` encoding is complete.
    private func fetchTicketCount(completionHandler: @escaping (ResultModel<TicketCount, AsistaError>) -> Void) {
        let request = GetTicketCount()
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(GetTicketCount.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    private func getTicketCount(completionHandler: @escaping (Int) -> Void ) {
        fetchTicketCount { (result) in
            if case .success(let response) = result {
                completionHandler(response.requestCount)
                return
            }
            completionHandler(0)
        }
    }
    
    /// Returns the list of ticket between the range
    ///
    /// - Parameters:
    ///   - from: Range starting from
    ///   - to: Range ending to
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func fetchUserTickets(from: Int? = 0, to: Int? = 20, completionHandler: @escaping (ResultModel<TicketList, AsistaError>) -> Void) {
        let request = GetTicketList(from: from!, to: to!)
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    var result = try decoder.decode(GetTicketList.Response.self, from: response.data!)
                    if self.isFirstLoad {
                        self.getTicketCount(completionHandler: { (count) in
                            result.ticketCount = count
                            self.isFirstLoad = false
                            completionHandler(.success(result))
                        })
                    }
                    else {
                        result.ticketCount = self.ticketCount
                        completionHandler(.success(result))
                    }
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    
    /// Search ticket on the server based on the user's query
    ///
    /// - Parameters:
    ///   - query: quesry string provided by the user on ticket searching
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func searchTicket(query: String, completionHandler: @escaping (ResultModel<[TicketPayload], AsistaError>) -> Void) {
        let request = SearchTicket(query: query)
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(SearchTicket.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    
    /// Returns the details of the ticket based on the `requestId`
    ///
    /// - Parameters:
    ///   - requestId: Represents the unique `id` provided to a ticket
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func fetchTicketDetails(requestId: Int, completionHandler: @escaping (ResultModel<TicketDetail, AsistaError>) -> Void) {
        let request = GetTicketDetail(requestId: requestId)
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(GetTicketDetail.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    
    /// Returns the list of fields with their attributes to display in create ticket form
    ///
    /// - Parameter completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func fetchTicketFields(completionHandler: @escaping (ResultModel<[CreateTicketForm], AsistaError>) -> Void) {
        let request = GetFormData()
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(GetFormData.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    
    /// Performs ticket creation
    ///
    /// - Parameters:
    ///   - parameters: Dictionary value contains the data of ticket
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func createTicket(with parameters: Dictionary<String, Any>, completionHandler: @escaping (ResultModel<MsgResponse, AsistaError>) -> Void) {
        let request = CreateTicket(parameters: parameters)
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(CreateTicket.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    
    /// Returns the list of categories for a ticket
    ///
    /// - Parameter completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func fetchCategoryList(completionHandler: @escaping (ResultModel<[Category], AsistaError>) -> Void) {
        let request = GetCategoryList()
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(GetCategoryList.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    
    /// Add comment on the ticket
    ///
    /// - Parameters:
    ///   - parameters: Dictionary value contains the data of a comment
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func addComment(with parameters: Dictionary<String, Any>, completionHandler: @escaping (ResultModel<Bool, AsistaError>) -> Void) {
        let request = CommentTicket(parameters: parameters)
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success( _):
               completionHandler(.success(true))
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    
    /// Performs file upload with the server.
    ///
    /// - Parameters:
    ///   - url: url path of the file
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func uploadAttachment(url: URL, completionHandler: @escaping (ResultModel<UploadResponse, AsistaError>) -> Void) {
        let request = UploadAttachment()
        
        let data = try! Data(contentsOf: url.absoluteURL)
        let name = url.lastPathComponent
        let mimeType = url.path.getMimeType()
        
        let file = FileParameters(data: data, name: name, mimeType: mimeType)
        Networking.shared.performFileUpload(request, file: file) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(UploadAttachment.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    
    /// Performs file upload with the server.
    ///
    /// - Parameters:
    ///   - data: Attachment in data format
    ///   - name: Name of attachment
    ///   - mimeType: Attachment type
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func uploadAttachment(data: Data, name: String, mimeType: String, completionHandler: @escaping (ResultModel<UploadResponse, AsistaError>) -> Void) {
        let request = UploadAttachment()
        
        let file = FileParameters(data: data, name: name, mimeType: mimeType)
        Networking.shared.performFileUpload(request, file: file) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(UploadAttachment.Response.self, from: response.data!)
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
