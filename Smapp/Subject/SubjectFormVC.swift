//
//  SubjectFormVC.swift
//  Smapp
//
//  Created by 이예준 on 2022/01/14.
//

import UIKit

class SubjectFormVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var roomTitle: UITextField!
    @IBOutlet weak var contents: UITextField!
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var professor: UITextField!
    @IBOutlet weak var major: UITextField!
    @IBOutlet weak var numberOfMax: UITextField!
    @IBOutlet weak var dueDate: UITextField!
    
    
    @IBAction func save(_ sender: Any) {
        guard self.subject.text?.isEmpty == false else {
            let alert = UIAlertController(title: nil, message: "내용을 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        let data = RoomData()
        
        data.title = self.roomTitle.text
        data.contents = self.contents.text
        data.subject = self.subject.text
        data.professor = self.professor.text
        data.major = ""
        data.numberOfPart = 1
        data.numberOfMax = Int(self.numberOfMax.text!)
        data.openDate = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        data.dueDate = formatter.date(from: self.dueDate.text!)
        
        data.isOnce = false
        data.isClosed = false
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.roomList.append(data)
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        self.contents.delegate = self
        
        createDatePickerView()
    }
    
    let datePicker = UIDatePicker()
    func createDatePickerView() {
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
            toolbar.setItems([doneButton], animated: true)
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.datePickerMode = .date
            
            dueDate.inputAccessoryView = toolbar
            dueDate.inputView = datePicker
        }
        
        @objc func donePressed() {
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateFormat = "yyyy-MM-dd"
            
            dueDate.text = formatter.string(from: datePicker.date)
            self.view.endEditing(true)
        }
}
