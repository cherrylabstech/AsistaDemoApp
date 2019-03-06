//
//  RegisterVC.swift
//  AsistaUI_Example
//
//  Created by Cherrylabs on 19/02/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import AsistaCore

class RegisterVC: UIViewController {

    /// Unique ID provided for Asista SDK login
    let appKey = "P4rmDf04Mpa9A0QlEFN5yg"
    
    /// Unique key provided for Asista SDK login
    let appSecret = "RNxvszjmTJ7vrrPIyaFnyiWSAnIFHXunoKs8CO6g"
    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var userIdText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        /// Mandatory check for firstName, username and phone
        guard
            let firstName = firstNameText.text, !firstName.isEmpty,
            let userId = userIdText.text, !userId.isEmpty,
            let phone = phoneText.text, !phone.isEmpty
            else {
                self.presentAlert(title: "Alert", message: "Enter mandatory fileds!!")
                return
        }
        
        let user = RegisterUser(appKey: appKey, appSecret: appSecret)
        user.firstName = firstName
        user.lastName = lastNameText.text
        user.email = emailText.text
        user.phone = phone
        user.userId = userId
        
        /// Register user with param credentials
        /// - Parameter user: Object of `RegisterUser` contains the creadentials for user registration
        try! AsistaCore.getInstance().getAuthService().register(user) { (result) in
            switch result {
            case .success( _):
                self.clearTextField()
                UIAlertController.presentAlert(on: self, title: "Registration Success", message: "")
            case .failed(let error):
                UIAlertController.presentAlert(on: self, title: "Alert", message: error.localizedDescription)
            }
        }
    }
    
    private func clearTextField() {
        firstNameText.text = ""
        lastNameText.text = ""
        emailText.text = ""
        userIdText.text = ""
        phoneText.text = ""
    }
    
    /// Presenting alert on demo app
    ///
    /// - Parameters:
    ///   - title: Title of the alert
    ///   - message: Description message
    private func presentAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        alert.preferredAction = okAction
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}


// MARK: - UITextFieldDelegate

extension RegisterVC: UITextFieldDelegate {
    
    /// Mapping the responder object when textfield end editing.
    ///
    /// - Parameter textField: Collection of textfields on View.
    /// - Returns: Bool value after end editing.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
