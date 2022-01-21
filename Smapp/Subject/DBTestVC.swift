//
//  DBTestVC.swift
//  Smapp
//
//  Created by 이예준 on 2022/01/21.
//

import UIKit
import Firebase
import FirebaseDatabase

class DBTestVC: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var ref: DatabaseReference!
    
    @IBAction func Push(_ sender: Any) {
        let itemRef = self.ref.child("roomList")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        var inputlist = [Dictionary<String, Any>]()
        for item in self.appDelegate.roomList {
            let inputData = [
                "roomId" : item.roomId!,
                "major" : item.major!,
                "subject" : item.subject!,
                "professor" : item.professor!,
                "title" : item.title!,
                "contents" : item.contents!,
                "numberOfPart" : item.numberOfPart!,
                "numberOfMax" : item.numberOfMax!,
                "openDate" : formatter.string(from: item.openDate!),
                "dueDate" : formatter.string(from: item.dueDate!),
                "isOnce" : item.isOnce!,
                "isClosed" : item.isClosed!,
                "listOfPartUser" : item.listOfPartUser!
            ] as [String : Any]
            inputlist.append(inputData)
        }
        
        itemRef.setValue(inputlist)
        
        self.showToast(message: "데이터 입력 완료", font: .systemFont(ofSize: 15.0))
    }
    
    @IBAction func Pull(_ sender: Any) {
        var count = 0
        ref.child("roomList").observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                let dataSnapshot = child as? DataSnapshot
                let item = dataSnapshot?.value as? NSDictionary
                
                print("\(count)번째 item")
                print("Subject : " + (item?["subject"] as? String ?? "Error!"))
                print("Title : " + (item?["title"] as? String ?? "Error!"))
                print("Contents : " + (item?["contents"] as? String ?? "Error!"))
                print("NumberOfMax : " + String(item?["numberOfMax"] as? Int ?? -1) + "\n")
                
                count += 1
            }
        })
        
        self.showToast(message: "데이터 가져오기 완료", font: .systemFont(ofSize: 15.0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
    }
    
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
