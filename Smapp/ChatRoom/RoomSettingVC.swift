//
//  RoomSettingVC.swift
//  Smapp
//
//  Created by 마석재 on 2022/02/16.
//

import UIKit
import FirebaseDatabase
import GoogleSignIn

class RoomSettingVC: UIViewController {
    var ref: DatabaseReference!
    var refChatrooms: DatabaseReference?
    var refUsers: DatabaseReference?
    var refComments: DatabaseReference?
    
    
    @IBOutlet weak var RoomTableView: UITableView!
    let RoomMenu = ["스터디룸 수정", "방 나가기"]
    var chatRoomId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
    }
    
    func roomOut() {
        let myUid: Int! = Int((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)
                // 경고창
                let alert = UIAlertController(title: "방 나가기", message: "방을 나가겠습니까?", preferredStyle: UIAlertController.Style.alert)
        
                let ok = UIAlertAction(title: "확인", style: .destructive) { (action) in
                    let roomListRef = self.ref.child("roomList")
                    let userListRef = self.ref.child("userList")
                    let chatListRef = self.ref.child("chatRooms")
        
                    // 만약 인원이 1명있는 방이라면 방 폭파 + 채팅 모두 삭제
                    // 아니라면 해당 유저 정보, 방 정보, 채팅 정보 각각 지우기
                    // roomList의 listOfPartUser에 유저 삭제
                    roomListRef.child(String(self.chatRoomId!)).getData(completion: {error, snapshot in
                        let value = snapshot.value as? NSDictionary
                        let listOfPartUser = value?["listOfPartUser"] as? NSMutableArray ?? []
                        
                        print("------------room Setting listOfpartUser: \(listOfPartUser)")
        
                        if(listOfPartUser.count == 1) {
                            roomListRef.child(String(self.chatRoomId!)).removeValue()
                        } else {
                            if listOfPartUser.contains(Int(myUid)) {
                                print("------------myUID: \(myUid)")
                                listOfPartUser.remove(Int(myUid))
                                print("------------listOfpartUser: \(listOfPartUser)")
                            }
                           roomListRef.child(String(self.chatRoomId!)).child("listOfPartUser").setValue(listOfPartUser)
                        }
                    })
        
        
                    // userList의 listOfPartRoom에 입장하는 방 번호 삭제
                    userListRef.child(String(myUid)).getData(completion: {error, snapshot in
                        let value = snapshot.value as? NSDictionary
                        let listOfPartRoom = value?["listOfPartRoom"] as? NSMutableArray ?? []
        
                        if listOfPartRoom.contains(self.chatRoomId!) {
                            listOfPartRoom.remove(self.chatRoomId)
                        }
                       userListRef.child(String(myUid)).child("listOfPartRoom").setValue(listOfPartRoom)
                    })
        
                    // chatroom 에 참여하는 user false로
                    chatListRef.child(String(self.chatRoomId!)).child("users").updateChildValues([String(myUid!):false])
        
                    _ = self.navigationController?.popViewController(animated: true)
                    _ = self.navigationController?.popViewController(animated: true)
                }
                let cancle = UIAlertAction(title: "취소", style: .default, handler: nil)
        
                alert.addAction(cancle)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
    }
    
}

extension RoomSettingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.RoomMenu.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "RoomFix", sender: nil)
        case 1:
            roomOut()
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RoomSettingTableCell", for: indexPath) as? RoomSettingTableCell else {
             return UITableViewCell()
         }
        cell.roomMenus.text = RoomMenu[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
