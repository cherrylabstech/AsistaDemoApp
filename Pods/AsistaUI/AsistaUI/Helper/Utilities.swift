//
//  Utilities.swift
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
import AsistaCore
import AVFoundation
import Photos

class Helper {
    
    class func ticketIcon(condition: Int) -> String {
        switch (condition) {
        case 1 :
            return "web"
        case 2 :
            return "mail"
        case 3 :
            return "fb"
        case 4 :
            return "twitter"
        case 5 :
            return "mobile"
        case 6 :
            return "cross_app"
        default :
            return "web"
        }
    }
    
    class func attachmentIcon(for Extension: String) -> String {
        switch (Extension) {
        case "jpg", "jpeg", "png", "bmp" :
            return "img"
        case "aac" :
            return "aud"
        case "txt" :
            return "txt"
        case "doc", "docx" :
            return "doc_att"
        case "pdf" :
            return "pdf_att"
        case "csv" :
            return "csv"
        case "xls", "xlsx" :
            return "exl"
        case "ppt", "pptx" :
            return "ppt"
        case "zip", "rar" :
            return "zip"
        default :
            return "file"
        }
    }
    
    class func loadImage(name: String) -> UIImage? {
        let podBundle = Bundle(for: self)
        if let url = podBundle.url(forResource: "AsistaUI", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return UIImage(named: name, in: bundle, compatibleWith: nil)
        }
        return nil
    }

    
    /// Returns whether the string url is valid or not
    ///
    /// - Parameter string: url provided by the user.
    /// - Returns: Bool value as the validity of url text
    class func canOpenURL(_ string: String?) -> Bool {
        guard let urlString = string,
            let url = URL(string: urlString)
            else { return false }
        
        if !UIApplication.shared.canOpenURL(url) { return false }
        
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
    
    
    class func isValidPassword(testStr: String?) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", AsistaCore.passwordRegx)
        return passwordTest.evaluate(with: testStr)
    }
    
    class func isCameraPermissionAuthorized(completionHandler:  @escaping (Bool) -> Void) {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            return completionHandler(true)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (status: Bool) in
                return completionHandler(status)
            })
        }
    }
    
    class func isPhotosPermissionAuthorized(completionHandler:  @escaping (Bool) -> Void) {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .authorized {
            completionHandler(true)
        }
        else if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    completionHandler(true)
                }
                else {
                    completionHandler(false)
                }
            })
        }
    }
}
