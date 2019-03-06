//
//  AssetService.swift
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

public class AssetService {
    
    var assetCount: Int = 0
    var isFirstLoad: Bool = true
    
    /// Returns the list of asset categories
    ///
    /// - Parameter completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func fetchAssetCategories(completionHandler: @escaping (ResultModel<[AssetCategory], AsistaError>) -> Void) {
        let request = GetAssetCategories()
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(GetAssetCategories.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    /// Returns the list of asset Types
    ///
    /// - Parameters:
    ///   - categoryId: `Id` of the category in which asset types are listed
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func fetchAssetTypes(categoryId: Int? = nil, completionHandler: @escaping (ResultModel<[AssetType], AsistaError>) -> Void) {
        let request = GetAssetTypes(categoryId: categoryId)
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(GetAssetTypes.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    /// Returns the list of asset count
    ///
    /// - Parameter completionHandler: The closure called when the `ResultModel` encoding is complete.
    private func fetchAssetCount(completionHandler: @escaping (ResultModel<AssetCount, AsistaError>) -> Void) {
        let request = GetAssetCount()
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(GetAssetCount.Response.self, from: response.data!)
                    completionHandler(.success(result))
                    
                } catch let error {
                    completionHandler(.failed(.unexpectedResponse(error)))
                }
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    private func getAssetCount(completionHandler: @escaping (Int) -> Void ) {
        fetchAssetCount { (result) in
            if case .success(let response) = result {
                completionHandler(response.assetCount)
                return
            }
            completionHandler(0)
        }
    }
    
    /// Returns the list of assets
    ///
    /// - Parameters:
    ///   - categoryId: `Id` of the category in which asset is listed
    ///   - modelId: `Id` of the model in which asset is listed
    ///   - from: Range starting from
    ///   - to: Range ending to
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func fetchAssetList(categoryId: Int? = nil, modelId: Int? = nil, from: Int? = 0, to: Int? = 20, completionHandler: @escaping (ResultModel<AssetList, AsistaError>) -> Void) {
        
        let request = GetAssetList(categoryId: categoryId, modelId: modelId, from: from!, to: to!)
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    var result = try decoder.decode(GetAssetList.Response.self, from: response.data!)
                    if self.isFirstLoad {
                        self.getAssetCount(completionHandler: { (count) in
                            result.assetCount = count
                            completionHandler(.success(result))
                        })
                    }
                    else {
                        result.assetCount = self.assetCount
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
    
    
    /// Returns details of an asset from `assetId`
    ///
    /// - Parameters:
    ///   - assetId: Unique `id` provided to each asset item
    ///   - completionHandler: The closure called when the `ResultModel` encoding is complete.
    public func fetchAssetDetails(assetId: Int, completionHandler: @escaping (ResultModel<AssetDetail, AsistaError>) -> Void) {
        let request = GetAssetDetails(assetId: assetId)
        
        Networking.shared.performRequest(request) { (response) in
            switch response {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(GetAssetDetails.Response.self, from: response.data!)
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
