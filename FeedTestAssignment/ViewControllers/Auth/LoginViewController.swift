//
//  LoginViewController.swift
//  PostTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Actions
    @IBAction func loginAction() {
        
        guard let email = emailField.text,
            let pass = passwordField.text else {
                UIAlertController.show(error: NSLocalizedString("EmptyEmailOrPassword", comment: ""), from: self)
                return
        }
        
        ProgressHUD.show()
        
        let requestModel = LoginRequestModel(email: email, password: pass)
        NetworkManager.instance.execute(requestModel: requestModel, completion: { [weak self] (model: LoginResponseModel?) in
            
            ProgressHUD.dismiss()
            guard let response = model else {
                UIAlertController.show(error: NSLocalizedString("SomethingWrong", comment: ""), from: self)
                return
            }
            
            CurrentUser.token = response.token
            CurrentUser.userID = response.userID
            CurrentUser.userName = response.userName
            DispatchQueue.main.async {
                UIManager.showStartScreen()
            }
        }) { (error) in
            
            ProgressHUD.dismiss()
            let message = (error as NSError).localizedDescription
            UIAlertController.show(error: message, from: self)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else {
            loginAction()
            textField.resignFirstResponder()
        }
        
        return false
    }
}
