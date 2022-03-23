//
//  myTableVC.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/11.
//

import UIKit
import FirebaseDatabase
import GoogleSignIn

class MyPagePartTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let chattingName = ["최진아", "이예준", "마석재", "김성빈", "크랑이", "크라", "CRA", "최진아", "이예준", "마석재", "김성빈", "크랑이", "크라", "CRA", "최진아", "이예준", "마석재", "김성빈", "크랑이", "크라", "CRA"]
    let chattingContent = ["오늘 2시에 괜찮으신가요?","네 이따가 봅시다!", "안녕하세요", "이거는 그 문제 같은데요..? 블라블라 블라블라", "소라에서 볼까요?", "넵", "거의 다 도착했습니다!", "오늘 2시에 괜찮으신가요?","네 이따가 봅시다!", "안녕하세요", "이거는 그 문제 같은데요..? 블라블라 블라블라", "소라에서 볼까요?", "넵", "거의 다 도착했습니다!", "오늘 2시에 괜찮으신가요?","네 이따가 봅시다!", "안녕하세요", "이거는 그 문제 같은데요..? 블라블라 블라블라", "소라에서 볼까요?", "넵", "거의 다 도착했습니다!"]

    var ref: DatabaseReference!
    var observe: UInt?
    var roomArray: [RoomData] = []
    var chatArray: [ChatModel] = []
    var users: [String: AnyObject]?
    var listOfPartRoomId: [Int?] = []
    var EnterIndex: Int?
                                                 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initRefresh()
        ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        
        // 유저 정보 가져오기
        let userRef = ref.child("userList")
        userRef.observeSingleEvent(of: DataEventType.value, with: {(datasnapshot) in
            self.users = datasnapshot.value as! [String: AnyObject]
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchListOfPartRoomId()
        updateData()
        updateChat()
    }
    
    func initRefresh() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
        //refresh.attributedTitle = NSAttributedString(string: "새로고침")
        
        tableView.addSubview(refresh)
    }
    
    // 유저가 참여하는 방 번호 가져오기
    func fetchListOfPartRoomId() {
        let myUid: Int! = Int((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)
        let userListRef = ref.child("userList")
        userListRef.child(String(myUid)).getData(completion: {error, snapshot in
            let value = snapshot.value as? NSDictionary
            self.listOfPartRoomId = value?["listOfPartRoom"] as? Array ?? []
        })
    }
    
    func updateData() {
        let refRoom = ref.child("roomList")
        refRoom.observe(DataEventType.value, with:  { (snapshot) in
            self.roomArray.removeAll()

            for item in snapshot.children.allObjects as! [DataSnapshot] {
                let roomList = RoomData(dic: item.value as! [String:Any])
                if self.listOfPartRoomId.contains(roomList.roomId) {    // 유저가 참여하는 방만 가져오기
                    self.roomArray.append(roomList)
                
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func updateChat() {
        let refChatrooms = ref.child("chatRooms")
        observe = refChatrooms.observe(DataEventType.value, with: { (datasnapshot) in
            self.chatArray.removeAll()
            
            for item in datasnapshot.children.allObjects as! [DataSnapshot] {
                
                if let chatroomdic = item.value as? [String:AnyObject] {
                    let chatModel = ChatModel(JSON: chatroomdic)
                    
                    if self.listOfPartRoomId.contains(chatModel?.roomId) {
                        self.chatArray.append(chatModel!)
                    }
                }
                
            }
            self.tableView.reloadData()
            
        })
    }
    

    
    @objc
    func updateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        updateData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.appDelegate.roomList.count
        return self.roomArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*guard*/ let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageTableCell", for: indexPath) as! MyPageTableCell /*else {
             return UITableViewCell()
         }*/
        
        let item = self.roomArray[indexPath.row]
        
        cell.roomId = item.roomId
        cell.roomTitle.text = item.title
        cell.participants.text = String(item.listOfPartUser?.count ?? -1) + "/" + String(item.numberOfMax!)
        
        
        // 채팅방에 채팅 없을 때
        if(self.chatArray.isEmpty) {
            cell.chatsContent.text = ""
            cell.chatsName.text = ""
        } else {
            let lastMessageKey = self.chatArray[indexPath.row].comments.keys.sorted(){$0>$1}
            // 마지막 채팅메세지 가져오기
            cell.chatsContent.text =  self.chatArray[indexPath.row].comments[lastMessageKey[0]]?.message

            // 마지막 채팅친 사람 가져오기
            let lastUid = self.chatArray[indexPath.row].comments[lastMessageKey[0]]?.uid
            
            if lastUid == "CRA" {
                cell.chatsName.text = ""
            } else {
                let destinationUser = self.users![lastUid!]
                cell.chatsName.text = destinationUser!["name"] as! String
            }
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyPagePartToChat" {
            let vc = segue.destination as? ChatRoomVC
            let cell = sender as! MyPageTableCell
            vc?.roomId = cell.roomId // 클릭한 룸 아이디 데이터를 가져 옴
        }
    }
    
}

