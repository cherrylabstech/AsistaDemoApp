//
//  AuthenticationVC.swift
//  AsistaUI_Example
//
//  Created by Cherrylabs on 12/02/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import AsistaCore

class LoginVC: UIViewController {

    @IBOutlet weak var userIdText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        /// Mandatory check for username
        guard let userId = userIdText.text, !userId.isEmpty else {
            UIAlertController.presentAlert(on: self, title: "Alert", message: "Enter User ID")
            return
        }

        /// Authenticating login with asiata SDK
        /// - Parameters:
        ///   - appKey: Unique ID provided for Asista SDK login
        ///   - appSecret: Unique key provided for Asista SDK login
        ///   - userId: UserId of registered user.
        try! AsistaCore.getInstance().getAuthService().authenticate(userId: userId) { (result) in
            switch result {
            case .success( _):
                self.userIdText.text = ""
                self.performSegue(withIdentifier: "toMenu", sender: self)
            case .failed(let error):
                UIAlertController.presentAlert(on: self, title: "Alert", message: error.localizedDescription)
            }
        }
    }
}


extension UIAlertController {
    /// Alert controller with message title and message string
    ///
    /// - Parameters:
    ///   - title: Title of the alert
    ///   - message: Description message
    static func presentAlert(on vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        alert.preferredAction = okAction
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }
}

