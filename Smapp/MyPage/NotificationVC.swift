//
//  Notification.swift
//  Smapp
//
//  Created by 이예준 on 2022/02/11.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseDatabase

class NotificationVC: UIViewController {
    var ref: DatabaseReference!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    var nowNoti = 1
    let uid = GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8)
    
    
    @IBAction func switchValueChanged(_ sender: Any) {
        let userListRef = self.ref.child("userList")
        
        self.nowNoti = self.notificationSwitch.isOn ? 1 : 0
        userListRef.child(String(uid!)).updateChildValues(["notification": self.nowNoti])
    }
    
    
    override func viewDidLoad() {
        ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        
        let userListRef = ref.child("userList")
        
        userListRef.child(String(uid!)).observeSingleEvent(of: DataEventType.value, with:  { (snapshot) in
            let values = snapshot.value! as! Dictionary<String, Any>
            self.nowNoti = values["notification"] as! Int
            self.notificationSwitch.isOn = self.nowNoti == 1 ? true : false
        })
        
        super.viewDidLoad()
    }
    
//    @objc func onClickSwitch(sender: UISwitch) {
//        var text: String!
//        var color: UIColor!
//
//        if sender.isOn {
//            text = "On"
//            color = UIColor.gray
//        } else {
//            text = "Off"
//            color = UIColor.orange
//        }
//
////        self.label.text = text
////        self.label.backgroundColor = color
//    }
}
