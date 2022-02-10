//
//  ChatRoomVC.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/13.
//

import UIKit
import MobileCoreServices
import Firebase
import FirebaseDatabase
import GoogleSignIn

class ChatRoomVC: UIViewController, UITextViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var willDisplayData = [RoomData]()
    var uid: String?
    var roomId: Int?    //  방 id
    var comments : [ChatModel.Comment] = []
    var userModel: UserModel?
    var ref: DatabaseReference!
    var refChatrooms: DatabaseReference?
    var refUsers: DatabaseReference?
    var refComments: DatabaseReference?
    var observe: UInt?
    var numOfPartUsers: Int?
    var prof: String?
    var subject: String?
    var users: [String: AnyObject]?
    
    @IBOutlet weak var roomOutButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var chatText: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var cameraMenu: UIButton!
    @IBOutlet weak var albumMenu: UIButton!
    @IBOutlet weak var fileMenu: UIButton!
    
    @IBOutlet weak var chatRoomTitle: UILabel!
    @IBOutlet weak var chatSubtitle: UILabel!
    
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var roomIndex: Int?
    
    let imagePicker = UIImagePickerController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        chatText.delegate = self
        
        self.ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
                
        uid =  String((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)
        
        // 유저 정보 가져오기
        let userRef = ref.child("userList")
        userRef.observeSingleEvent(of: DataEventType.value, with: {(datasnapshot) in
            self.users = datasnapshot.value as! [String: AnyObject]
        })
        
        updateRoomInfo()
        
        getMessageList()
        
        // 채팅 텍스트 박스 꾸미기
        chatText.layer.borderWidth = 0.5
        chatText.layer.borderColor = UIColor.gray.cgColor
        chatText.layer.cornerRadius = 10
        
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        self.tabBarController?.tabBar.isHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // 방 정보 가져와서 띄우기
    func updateRoomInfo() {
        let roomid = String(roomId!)
        let roomListRef = ref.child("roomList").child(roomid)
        
        roomListRef.observe(DataEventType.value, with: { (snapshot) in
            for child in snapshot.children {
                let title = child as! DataSnapshot
                let titlekey = title.key
                let titlevalue = title.value!
                
                if titlekey == "title" {
                    self.chatRoomTitle.text = titlevalue as? String
                } else if titlekey == "professor" {
                    self.prof = titlevalue as! String
                } else if titlekey == "subject" {
                    self.subject = titlevalue as! String + "-"
                    self.chatSubtitle.text = self.subject! + self.prof!
                }
            }
            
        })
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self)
//        self.tabBarController?.tabBar.isHidden = false
//        refComments?.removeObserver(withHandle: observe!)
//    }
    
    // 메세지 보내기
    @objc
    func sendMessage() {
        let value: Dictionary<String, Any> = [
            "uid": uid!,
            "message": self.chatText.text!,
            "timestamp": ServerValue.timestamp()
        ]
        
        let chatListRef = ref.child("chatroomTest")
        
        // 메세지 보내면 텍스트필드 초기화
        chatListRef.child(String(self.roomId!)).child("comments").childByAutoId().setValue(value) { (err, ref) in
            self.chatText.text = ""
        }
    }

    
    //메세지 가져오기
    func getMessageList() {
        refComments = ref.child("chatroomTest").child(String(roomId!)).child("comments")
        observe = refComments?.observe(DataEventType.value, with: { (datasnapshot) in
            self.comments.removeAll()
            var readUserDic : Dictionary<String, AnyObject> = [:]
            for item in datasnapshot.children.allObjects as! [DataSnapshot] {
                let key = item.key as String
                let comment = ChatModel.Comment(JSON: item.value as! [String:AnyObject])
                let comment_forReadUsers = ChatModel.Comment(JSON: item.value as! [String:AnyObject])
                comment_forReadUsers?.readUsers[self.uid!] = true
                readUserDic[key] = comment_forReadUsers?.toJSON() as! NSDictionary
                self.comments.append(comment!)
            }
            let nsDic = readUserDic as NSDictionary
    
    
            if(self.comments.last?.readUsers.keys == nil) {     // 처음 시작할 때 메세지 없을 경우 코드 동작하지 않도록
                return
            }
    
            if(!(self.comments.last?.readUsers.keys.contains(self.uid!))!) { // 내 uid가 없으면 서버에 보고
                datasnapshot.ref.updateChildValues(nsDic as! [AnyHashable : Any], withCompletionBlock: {(err, ref) in
                    self.tableView.reloadData()

                     let count = self.comments.count - 1
                     if self.comments.count > 0 {
                         self.tableView.scrollToRow(at: IndexPath(item:count, section:0), at: UITableView.ScrollPosition.bottom, animated: true)
                    }
                })
            } else {    // 있으면 그냥 메세지만 출력
                self.tableView.reloadData()

                 let count = self.comments.count - 1
                 if self.comments.count > 0 {
                     self.tableView.scrollToRow(at: IndexPath(item:count, section:0), at: UITableView.ScrollPosition.bottom, animated: true)
                }
            }
        })
    }
    
    // 읽은 인원수 확인
    func setReadCount(label: UILabel?, position: Int?) {
        let readCount = self.comments[position!].readUsers.count
            refChatrooms = ref.child("chatroomTest")
            refChatrooms?.child(String(self.roomId!)).child("users").observe(DataEventType.value, with:  { (datasnapshot) in
                let dic = datasnapshot.value as! [String: Bool]
                self.numOfPartUsers = dic.count
                
                // 읽지 않은 인원 수 세기
                let noReadCount = self.numOfPartUsers! - readCount
                if(noReadCount > 0) {   // 만 약 읽지 않은 인원이 있다면
                    label?.isHidden = false
                    label?.text = String(noReadCount)
                } else {    // 다 읽었다면
                    label?.isHidden = true
                }
            })
    }
    
    // 화면 누르면 키보드 내려감
    @objc
    func dissmissKeyboard() {
        self.view.endEditing(true)
    }
    
    func openLibrary(){
      imagePicker.sourceType = .photoLibrary
      present(imagePicker, animated: false, completion: nil)
    }
    func openCamera(){
      imagePicker.sourceType = .camera
      present(imagePicker, animated: false, completion: nil)
    }
    
    func openFile() {
        if presentedViewController == nil {
            let fileMenu = UIDocumentPickerViewController(documentTypes: [kUTTypeItem as String], in: .import)
//            let fileMenu = UIDocumentPickerViewController(forOpeningContentTypes: [kUTTypeItem], asCopy: true)
            fileMenu.delegate = self
            fileMenu.allowsMultipleSelection = true
            present(fileMenu, animated: true, completion: nil)
        }
    }

    
    @objc
    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraint.constant = keyboardSize.height
        }
        
        UIView.animate(withDuration: 0, animations: {
            self.view.layoutIfNeeded()
        }, completion: {
            (complete) in
            let count = self.comments.count - 1
            if self.comments.count > 0 {
                self.tableView.scrollToRow(at: IndexPath(item:count, section:0), at: UITableView.ScrollPosition.bottom, animated: true)
            }
        })
    }
    
    @objc
    func keyboardWillHide(notification: Notification) {
        self.bottomConstraint.constant = 20
        self.view.layoutIfNeeded()
    }
    
    
    // 메뉴 버튼 누르면 세부 메뉴 뜨기
    @IBAction func tapMenuButton(_ sender: Any) {
        self.menuView.isHidden.toggle()
    }
    
    @IBAction func tapCameraButton(_ sender: Any) {
        self.openCamera()
    }
    
    @IBAction func tapAlbumButton(_ sender: Any) {
        self.openLibrary()
    }
    
    @IBAction func tapFileButton(_ sender: Any) {
        self.openFile()
    }
    
    @IBAction func tapSendButton(_sender: Any) {
        //createRoom()
    }
    
    @IBAction func tapOutButton(_ sender: Any) {
        let myUid: Int! = Int((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)
        // 경고창
        let alert = UIAlertController(title: "방 나가기", message: "방을 나가겠습니까?", preferredStyle: UIAlertController.Style.alert)
        
        let ok = UIAlertAction(title: "확인", style: .destructive) { (action) in
            // 유저 정보, 방 정보, 채팅 정보 각각 지우기
            // roomList의 listOfPartUser에 유저 삭제
            let roomListRef = self.ref.child("roomList")
            roomListRef.child(String(self.roomId!)).getData(completion: {error, snapshot in
                let value = snapshot.value as? NSDictionary
                let listOfPartUser = value?["listOfPartUser"] as? NSMutableArray ?? []
                
                if listOfPartUser.contains(Int(myUid)) {
                    listOfPartUser.remove(Int(myUid))
                }

               roomListRef.child(String(self.roomId!)).child("listOfPartUser").setValue(listOfPartUser)
            })

            
            // userList의 listOfPartRoom에 입장하는 방 번호 삭제
            let userListRef = self.ref.child("userList")
            userListRef.child(String(myUid)).getData(completion: {error, snapshot in
                let value = snapshot.value as? NSDictionary
                let listOfPartRoom = value?["listOfPartRoom"] as? NSMutableArray ?? []
                
                if listOfPartRoom.contains(self.roomId!) {
                    listOfPartRoom.remove(self.roomId)
                }
               userListRef.child(String(myUid)).child("listOfPartRoom").setValue(listOfPartRoom)
            })
            
            // chatroom 에 참여하는 user 삭제
            let chatListRef = self.ref.child("chatroomTest")
            chatListRef.child(String(self.roomId!)).child("users").getData(completion: {error, snapshot in
                let value = snapshot.value as? NSDictionary
                let usersList = value?["listOfPartRoom"] as? NSMutableArray ?? []
                
                if usersList.contains(Int(myUid)) {
                    usersList.remove(Int(myUid))
                }
                chatListRef.child(String(self.roomId!)).child("users").setValue(usersList)
            })
            
            _ = self.navigationController?.popViewController(animated: true)
        }
        let cancle = UIAlertAction(title: "취소", style: .default, handler: nil)
        
        alert.addAction(cancle)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}

extension ChatRoomVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(self.comments[indexPath.row].uid == uid) {   // 내가 보내는 메세지
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as? MyMessageCell else {
                 return UITableViewCell()
             }
            cell.label_message.text = self.comments[indexPath.row].message
            cell.label_message.numberOfLines = 0
            if let time = self.comments[indexPath.row].timestamp {
                cell.label_time.text = time.todaytime
            }
            self.setReadCount(label: cell.label_readUsers, position: indexPath.row)
            
            return cell
            
        }else {     // 상대방이 보내는 메세지
            let destinationUser = self.users![self.comments[indexPath.row].uid!]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationMessageCell", for: indexPath) as? DestinationMessageCell else {
                 return UITableViewCell()
             }
            cell.label_name.text = destinationUser!["name"] as! String
            cell.label_message.text = self.comments[indexPath.row].message
            cell.label_message.numberOfLines = 0
            if let time = self.comments[indexPath.row].timestamp {
                cell.label_time.text = time.todaytime
            }
            self.setReadCount(label: cell.label_readUsers, position: indexPath.row)
            
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



extension ChatRoomVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 이미지 선택 시 (일단 임시)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                    //ImageView.image = image
                    print(info)
            }
            dismiss(animated: true, completion: nil)
        }
    
}

extension ChatRoomVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    }
}

extension Int{
    var todaytime: String{
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.dateFormat = "HH:mm"
        let date = Date(timeIntervalSince1970: Double(self)/1000)
        return dateformatter.string(from: date)
        
    }
}
