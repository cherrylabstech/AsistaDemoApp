//
//  KBService.swift
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

public class KbService {
    
    /// Performs Api call for fetching KB Topics from Asista
    ///
    /// - Parameter completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func fetchKbTopics(completionHandler: @escaping (ResultModel<[KBTopic], AsistaError>) -> Void) {
        let request = GetKBTopics()
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(GetKBTopics.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    /// Performs Api call for fetching KB Articles from Asista
    ///
    /// - Parameters:
    ///   - topicId: Int value respresents the `id` of topic
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func fetchKbArticles(with topicId: Int, completionHandler: @escaping (ResultModel<KBArticle, AsistaError>) -> Void) {
        let request = GetKBArticles(topicId: topicId)
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(GetKBArticles.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    /// Performs Api call for seaching in KB Articles from Asista
    ///
    /// - Parameters:
    ///   - query: String value represents the text to search in Article list
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func searchKBArticles(query: String, completionHandler: @escaping (ResultModel<[KBArticleSearch], AsistaError>) -> Void) {
        let request = SearchArticle(query: query)
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(SearchArticle.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    /// Performs Api call for fetching KB Contents from Asista
    ///
    /// - Parameters:
    ///   - articleId: Int value respresents the `id` of article
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func fetchArticleContents(with articleId: Int, completionHandler: @escaping (ResultModel<KBContent, AsistaError>) -> Void) {
        let request = GetKBContents(articleId: articleId)
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(GetKBContents.Response.self, from: response.data!)
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
