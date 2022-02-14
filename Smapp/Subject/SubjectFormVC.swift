//
//  SubjectFormVC.swift
//  Smapp
//
//  Created by 이예준 on 2022/01/14.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseDatabase

class SubjectFormVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    var ref: DatabaseReference!
    var childCount: Int = 0
    let datePicker = UIDatePicker()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var roomTitle: UITextField!
    @IBOutlet weak var contents: UITextField!
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var professor: UITextField!
    @IBOutlet weak var major: UITextField!
    @IBOutlet weak var majorDropdown: UIPickerView!
    @IBOutlet weak var numberOfMax: UITextField!
    @IBOutlet weak var maxDropdown: UIPickerView!
    @IBOutlet weak var dueDate: UITextField!
    @IBOutlet weak var isOnce: UISegmentedControl!
    
    //labels
    @IBOutlet weak var roomTitleLabel: UILabel!
    
    override func viewDidLoad() {
        //uiconstraints
//        roomTitleLabel.adjustsFontSizeToFitWidth  = true
//        roomTitleLabel.minimumScaleFactor = 1.0
        
        ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        
        let userListRef = ref.child("userList")
        
        userListRef.child(String((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)).getData(completion: {error, snapshot in
            let value = snapshot.value as? NSDictionary
            
            self.major.text = value?["likeMajor"] as? String ?? "Error"
        })
        
        self.contents.delegate = self
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dueDate.placeholder = formatter.string(from: Date())
        
        createDatePicker()
    }
    
    
    func childCountUpdate() {
        let roomListRef = ref.child("roomList")
        
        roomListRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let values = snapshot.value!
            let dic = values as? [Any] ?? []
            for index in dic {
                if let idx = index as? [String: Any] {
                    if (self.childCount <= (idx["roomId"] as! Int)){
                        self.childCount = (idx["roomId"] as! Int + 1)
                    }
                }
            }
        })
    }
    
    @IBAction func save(_ sender: Any) {
        guard (self.roomTitle.text?.isEmpty == false && self.contents.text?.isEmpty == false && self.subject.text?.isEmpty == false && self.professor.text?.isEmpty == false && self.numberOfMax.text?.isEmpty == false && self.dueDate.text?.isEmpty == false) else {
            let alert = UIAlertController(title: nil, message: "모든 내용을 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        let roomListRef = ref.child("roomList")
//        let userListRef = ref.child("userList")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let inputData = [
            "roomId" : self.childCount,
            "title" : self.roomTitle.text!,
            "contents" : self.contents.text!,
            "subject" : self.subject.text!,
            "professor" : self.professor.text!,
            "major" : self.major.text!,
            "numberOfMax" : Int(self.numberOfMax.text!)!,
            "openDate" : formatter.string(from: Date()),
            "dueDate" : self.dueDate.text!,
            "isOnce" : isOnce.selectedSegmentIndex == 0 ? true : false,
            "isClosed" : false,
            "listOfPartUser" : [Int((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)],
            "king" : Int((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!),
        ] as [String : Any]
        
        roomListRef.child(String(childCount)).setValue(inputData)
        
        
        // userList의 listOfPartRoom에 입장하는 방 번호 추가
        let userListRef = ref.child("userList")
        userListRef.child(String((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)).getData(completion: {error, snapshot in
            let value = snapshot.value as? NSDictionary
            var listOfPartRoom = value?["listOfPartRoom"] as? NSMutableArray ?? []
            
            listOfPartRoom.add(self.childCount)
            
           userListRef.child(String((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)).child("listOfPartRoom").setValue(listOfPartRoom)
        })
        
        _ = self.navigationController?.popViewController(animated: true)
        
        print("\n\n\n\n\n\(childCount)\n\n\n\n\n\n\n")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        childCountUpdate()
    }
}

extension SubjectFormVC {
    func createDatePicker() {
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

extension SubjectFormVC: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{

        return self.appDelegate.majorList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        self.view.endEditing(true)
        return self.appDelegate.majorList[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        self.major.text = self.appDelegate.majorList[row]
        self.majorDropdown.isHidden = true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.major {
            self.majorDropdown.isHidden = false
            self.majorDropdown.layer.opacity = 0.8

            textField.endEditing(true)
        }
    }
}
