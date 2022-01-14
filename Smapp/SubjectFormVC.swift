//
//  SubjectFormVC.swift
//  Smapp
//
//  Created by 이예준 on 2022/01/14.
//

import UIKit

class SubjectFormVC: UIViewController, UITextViewDelegate {
    @IBOutlet weak var subject: UITextView!
    @IBOutlet weak var contents: UITextView!
    
    
    @IBAction func save(_ sender: Any) {
        guard self.subject.text?.isEmpty == false else {
            let alert = UIAlertController(title: nil, message: "내용을 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        let data = SubjectData()
        
        data.subject = self.subject.text
        data.contents = self.contents.text
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.subjectList.append(data)
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        self.contents.delegate = self
    }
}
