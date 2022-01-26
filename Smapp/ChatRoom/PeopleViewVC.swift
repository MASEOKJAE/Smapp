//
//  PeopleViewVC.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/25.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleSignIn

class PeopleViewVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var array: [UserModel] = []
    var ref: DatabaseReference!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        let refUser = ref.child("userList")
           refUser.observe(DataEventType.value, with:  { (snapshot) in
               self.array.removeAll()
               
               let myUid = String((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)
               
               for child in snapshot.children {
                   let fchild = child as! DataSnapshot
                   let userModel = UserModel()
                   userModel.setValuesForKeys(fchild.value as! [String : Any])
                   
                   // 내 목록은 안보이게
                   if(userModel.studentId?.stringValue == myUid) {
                       continue
                   }
                   
                   self.array.append(userModel)
               }

               DispatchQueue.main.async {
                   self.tableView.reloadData()
               }
           })
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "peopleToChat" {
                let vc = segue.destination as? ChatRoomVC
                let selectedIndex = tableView.indexPathForSelectedRow
                vc?.destinationUid = self.array[Int((selectedIndex?.row)!)].studentId?.stringValue
            }
        }
    
}
