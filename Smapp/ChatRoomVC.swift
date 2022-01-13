//
//  ChatRoomVC.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/13.
//

import UIKit


class ChatRoomVC: UIViewController, UITextViewDelegate {
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet var chatText: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var inputViewBottomMargin: NSLayoutConstraint!
    
    var keyHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatText.layer.borderWidth = 0.5
        chatText.layer.borderColor = UIColor.gray.cgColor
        chatText.layer.cornerRadius = 10
        
        chatText.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       
    }
    
    @objc
    func keyboardWillShow(_ sender: Notification) {

        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
                let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                keyHeight = keyboardHeight

                self.view.frame.size.height -= keyboardHeight
    }

    @objc
    func keyboardWillHide(_ sender: Notification) {
        self.view.frame.size.height += keyHeight!
    }
    
    
    @IBAction func tapSendButton(_sender: Any) {
        chatText.resignFirstResponder()
    }

    
    

}

