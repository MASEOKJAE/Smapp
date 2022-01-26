//
//  PeopleViewVC.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/25.
//

import UIKit
import Firebase
import FirebaseDatabase

class PeopleViewVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var array: [UserModel] = []
    var ref: DatabaseReference!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
    }
    
    func snapshotfunc() {
        let userListRef = ref.child("userList")
    
        
        userListRef.observe(DataEventType.value) { (snapshot) in
            self.array.removeAll()

            for child in snapshot.children {
                let fchild = child as! DataSnapshot
                let userModel = UserModel()
                userModel.setValuesForKeys(fchild.value as! [String : Any])
                self.array.append(userModel)
                print("usermodel: ", userModel)
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleViewTableCell", for: indexPath) as? PeopleViewTableCell else {
             return UITableViewCell()
         }
        
        cell.label_username.text = array[indexPath.row].name
        cell.label_email.text = array[indexPath.row].email
        
        
        return cell
    }
    
}
