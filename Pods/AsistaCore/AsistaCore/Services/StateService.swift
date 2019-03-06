//
//  StateService.swift
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

public class StateService {
    
    
    /// Returns the list of tickets
    ///
    /// - Parameter completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func fetchStateList(completionHandler: @escaping (ResultModel<[State], AsistaError>) -> Void) {
        let request = GetStateList()
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(GetStateList.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    
    /// Returns the upcomming list of states of a ticket
    ///
    /// - Parameters:
    ///   - requestId: represents the unique `id` provided to a ticket
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func fetchWorkflowStates(requestId: Int, completionHandler: @escaping (ResultModel<[State], AsistaError>) -> Void) {
        let request = GetWorkflowStates(requestId: requestId)
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(GetWorkflowStates.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    
    /// Perform ticket state updation on server
    ///
    /// - Parameters:
    ///   - parameters: Dictionary value contains the data of new state
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func updateTicketState(parameters: Dictionary<String, Any>, completionHandler: @escaping (ResultModel<MsgResponse, AsistaError>) -> Void) {
        let request = UpdateTicketState(parameters: parameters)
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(UpdateTicketState.Response.self, from: response.data!)
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
