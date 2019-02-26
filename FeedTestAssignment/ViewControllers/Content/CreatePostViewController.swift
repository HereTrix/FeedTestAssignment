//
//  CreatePostViewController.swift
//  PostTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    // MARK: - Actions
    @IBAction func postAction() {
        
        guard let text = textView.text,
            text.count > 0 else {
                UIAlertController.show(error: NSLocalizedString("EnterText", comment: ""), from: self)
                return
        }
        
        let requestModel = PostRequestModel()
        requestModel.text = text
        
        ProgressHUD.show()
        NetworkManager.instance.execute(requestModel: requestModel, completion: { (response: PostResponseModel?) in
            
            ProgressHUD.dismiss()
            guard let model = response else {
                UIAlertController.show(error: NSLocalizedString("SomethingWrong", comment: ""), from: self)
                return
            }
            CoreDataManager.shared.saveOwn(post: model)
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
            
        }) { (error) in
            ProgressHUD.dismiss()
            let message = (error as NSError).localizedDescription
            UIAlertController.show(error: message, from: self)
        }
    }
    
    // MARK: - Keyboard handling
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSizeValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardSizeValue.cgRectValue.height
        var inset = textView.contentInset
        inset.bottom = keyboardHeight
        textView.contentInset = inset
    }
    
    @objc func keyboardDidHide(notification: NSNotification) {
        textView.contentInset = .zero
    }
}

extension CreatePostViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        
        let nsString = textView.text as NSString?
        if let newText = nsString?.replacingCharacters(in: range, with: text),
            newText.count >= Post.messageLimit {
            
            let message = NSLocalizedString("IncorrectPostLength", comment: "")
            UIAlertController.show(error: message, from: self)
            
            return false
        }
        return true
    }
}
