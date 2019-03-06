//
//  AsistaCore.swift
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

/// Initialise the Asista SDK and returns the instance of `AsistaApiClient` class
public class AsistaCore {
    
    /// Returns the singleton instance of `AsistaCore` Class.
    public static var shared = AsistaCore()
    
    /// Token for accessing Asista API methods
    var accessToken: String
    
    /// Token for refreshing access token
    var refreshToken: String
    
    /// The current tenant that API is connected to.
    var tenantURL: String
    
    /// Secret key used to connect Asista SDK with Application
    var clientSecret: String
    
    /// App unique ID
    var appId: String
    
    /// Password Regex to validate user provided password
    public static var passwordRegx: String = ""
    
    /// Password policy string to display to the user
    public static var passwordPolicy: String = ""
    
    /// Timezone ofset of a tenant from UTC
    public static var timeZoneOffset: Double = 0
    
    /// `id` of the logined user
    public static var userId: Int = 0
    
    /// Permissible maximum size of attachment
    public static var attachmentSize: Int = 0
    
    /// List of attachment types permitted
    public static var attachmentTypes: [String] = []
    
    // MARK: Initialization
   
    /// Creates a `AsistaCore` instance using the credentials.
    ///
    /// - Parameters:
    ///   - accessToken: Token for accessing Asista API methods
    ///   - tenantUrl: The current tenant that API is connected to.
    ///   - clientSecret: Secret key used to connect Asista SDK with Application
    ///   - appId: App unique ID
    public init(tenantUrl: String? = nil, clientSecret: String? = nil, appId: String? = nil) {
        self.accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        self.refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
        
        if let url = tenantUrl, let secret = clientSecret, let appId = appId {
            self.tenantURL = url
            self.clientSecret = secret
            self.appId = appId
        }
        else if let asista = Bundle.main.infoDictionary?["Asista"] as? [String: String] {
            self.tenantURL = asista["tenantUrl"] ?? ""
            self.clientSecret = asista["clientSecret"] ?? ""
            self.appId = asista["appId"] ?? ""
        }
        else {
            self.tenantURL = ""
            self.clientSecret = ""
            self.appId = ""
        }
    }
    
    /// Returns instance of `AsistaApiClient` class
    public static func getInstance() throws -> AsistaApiClient {
        if AsistaCore.shared.tenantURL.isEmpty || AsistaCore.shared.clientSecret.isEmpty || AsistaCore.shared.appId.isEmpty {
            throw AsistaError.invalidAuthCredentials("Asista Core initialization failed. Check your init variables")
        }
        return AsistaApiClient()
    }
}
