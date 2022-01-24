//
//  DB_UserListVC.swift
//  Smapp
//
//  Created by 이예준 on 2022/01/22.
//

import UIKit
import Firebase
import FirebaseDatabase

class DB_TestVC: UIViewController {
    var ref: DatabaseReference!
    
    var childCount = 0
    
    @IBAction func clearData(_ sender: Any) {
        let userListRef = ref.child("userList_test")
        
        userListRef.removeValue()
        
        self.showToast(message: "초기화 완료", font: .systemFont(ofSize: 12.0))
    }
    
    @IBOutlet weak var createTextField: UITextField!
    @IBAction func createData(_ sender: Any) {
        let userListRef = ref.child("userList_test")
        
        userListRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            self.childCount = Int(snapshot.childrenCount)
        })
        
        let inputData = [
            "userId" : childCount,
            "email" : "cra.smapp@gmail.com",
            "studentId" : 22100001 + childCount,
            "name" : "스맵\(childCount)",
            "likeMajor" : 0,
            "listOfPartRoom" : [],
            "listOfLikeRoom" : []
        ] as [String : Any]
        
        userListRef.child(createTextField.text!).setValue(inputData)
        
        self.showToast(message: "생성 완료", font: .systemFont(ofSize: 12.0))
    }
    
    @IBOutlet weak var deleteTextField: UITextField!
    @IBAction func deleteData(_ sender: Any) {
        let userListRef = ref.child("userList_test")
        
        userListRef.child(deleteTextField.text!).removeValue()
        
        self.showToast(message: "삭제 완료", font: .systemFont(ofSize: 12.0))
    }
    
    @IBOutlet weak var updateTextField: UITextField!
    @IBAction func updateData(_ sender: Any) {
        // 사실 create와 코드 똑같음 ㅋㅋ
        let userListRef = ref.child("userList_test")
        
        userListRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            self.childCount = Int(snapshot.childrenCount)
        })
        
        let inputData = [
            "userId" : childCount,
            "email" : "cra.smapp@gmail.com",
            "studentId" : 22100001 + childCount,
            "name" : "스맵\(childCount)",
            "likeMajor" : 0,
            "listOfPartRoom" : [],
            "listOfLikeRoom" : []
        ] as [String : Any]

        userListRef.child(updateTextField.text!).setValue(inputData)
        
        self.showToast(message: "수정 완료", font: .systemFont(ofSize: 12.0))
    }
    
    @IBOutlet weak var readTextField: UITextField!
    @IBAction func readData(_ sender: Any) {
        let userListRef = ref.child("userList_test")
        
        userListRef.child(readTextField.text!).getData(completion: {error, snapshot in
            let value = snapshot.value as? NSDictionary
            let userId = value?["userId"] as? Int ?? -1
            let email = value?["email"] as? String ?? "Error!"
            let studentId = value?["studentId"] as? Int ?? -1
            let name = value?["name"] as? String ?? "Error!"
            let likeMajor = value?["likeMajor"] as? Int ?? -1
            let listOfPartRoom = value?["listOfPartRoom"] as? NSArray ?? []
            let listOfLikeRoom = value?["listOfLikeRoom"] as? NSArray ?? []
            
            print("userId : \(userId)")
            print("email : " + email)
            print("studentId : \(studentId)")
            print("name : " + name)
            print("likeMajor : \(likeMajor)")
        })
        
        self.showToast(message: "읽기(print) 완료", font: .systemFont(ofSize: 12.0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
    }
}

extension DB_TestVC {
    //toast 메세지
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 60))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations:
        {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
