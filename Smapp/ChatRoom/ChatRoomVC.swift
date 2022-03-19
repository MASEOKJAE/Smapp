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
import Alamofire


class ChatRoomVC: UIViewController, UITextViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var willDisplayData = [RoomData]()
    var uid: String?
    var roomId: Int?    //  방 id
    var comments : [ChatModel.Comment] = []
//    var myModel: UserModel?
    var myModelName : String?
//    var userModel: UserModel?
    var userModelToken : String?
    var ref: DatabaseReference!
    var refChatrooms: DatabaseReference?
    var refUsers: DatabaseReference?
    var refComments: DatabaseReference?
    var observe: UInt?
    var numOfPartUsers: Int?
    var prof: String?
    var subject: String?
    var users: [String: AnyObject]?
    var today: String?
    var cnt: Int? = 0

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
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.today = formatter.string(from: Date())

        // 유저 정보 가져오기
        let userRef = ref.child("userList")
        userRef.observeSingleEvent(of: DataEventType.value, with: {(datasnapshot) in
            self.users = datasnapshot.value as! [String: AnyObject]
        })
        
        updateRoomInfo()
        getMessageList()
        //groupedMessages()
        
        // 채팅 텍스트 박스 꾸미기
        chatText.layer.borderWidth = 0.5
        chatText.layer.borderColor = UIColor.gray.cgColor
        chatText.layer.cornerRadius = 10
        
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        self.tabBarController?.tabBar.isHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
//    func groupedMessages() {
//        let groupedMessages = Dictionary(grouping: self.comments) { (element) -> String in
//            print("--------------element ymdTime: \(element.ymdTime)----------------")
//            return element.ymdTime!
//        }
//
//        groupedMessages.keys.forEach{(key) in
//            print("It's Key!!!!----------\(key)--------------")
//        }
//
//        print("----------grouped Message: \(groupedMessages)---------")
//    }
    

    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        self.tabBarController?.tabBar.isHidden = false
        refComments?.removeObserver(withHandle: observe!)
    }
    

    // 메세지 보내기
    @objc
    func sendMessage() {
        let value: Dictionary<String, Any> = [
            "uid": uid!,
            "message": self.chatText.text!,
            "timestamp": ServerValue.timestamp(),
            "ymdTime": self.today!
        ]
        
        self.refUsers = ref.child("userList")

        self.refUsers?.child(self.uid!).observeSingleEvent(of: DataEventType.value, with: { (datasnapshot) in
            self.myModelName = (datasnapshot.value as! [String : Any])["name"] as? String
        })

        for key in self.users!.keys {
            if(key != self.uid) {
                self.refUsers?.child(String(key)).observeSingleEvent(of: DataEventType.value, with: { (datasnapshot) in
                    self.userModelToken = (datasnapshot.value as! [String : Any])["token"] as? String
                    if(((datasnapshot.value as! [String : Any])["notification"] as? Int == 1) && ((datasnapshot.value as! [String : Any])["isBackground"] as? Int == 1)) {
                        self.sendFcm(dest: self.userModelToken!, name: (self.myModelName)!, text: self.chatText.text)
                    }
                })
            }
        }
        
        let chatListRef = ref.child("chatRooms")
        
        
        // 메세지 보내면 텍스트필드 초기화
        chatListRef.child(String(self.roomId!)).child("comments").childByAutoId().setValue(value) { (err, ref) in
            self.chatText.text = ""
        }
        
    }

    
    //메세지 가져오기
    func getMessageList() {
        refComments = ref.child("chatRooms").child(String(roomId!)).child("comments")
        observe = refComments?.observe(DataEventType.value, with: { (datasnapshot) in
            self.comments.removeAll()
            var readUserDic : Dictionary<String, AnyObject> = [:]
            for item in datasnapshot.children.allObjects as! [DataSnapshot] {
                let key = item.key as String
                //print("-----------item.key = \(key)-------------")
                let comment = ChatModel.Comment(JSON: item.value as! [String:AnyObject])
                //print("-----------comment = \(comment)-------------")
                let comment_forReadUsers = ChatModel.Comment(JSON: item.value as! [String:AnyObject])
                //print("-----------comment for read users = \(comment_forReadUsers)-------------")
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

            refChatrooms = ref.child("chatRooms")
            refChatrooms?.child(String(self.roomId!)).child("users").observe(DataEventType.value, with:  { (datasnapshot) in
                let dic = datasnapshot.value as! [String: Bool]
                self.numOfPartUsers = dic.count
                
                // 읽지 않은 인원 수 세기
                let noReadCount = self.numOfPartUsers! - readCount
                if(noReadCount > 0) {   // 만약 읽지 않은 인원이 있다면
                    label?.isHidden = false
                    label?.text = String(noReadCount)
                } else {    // 다 읽었다면
                    label?.isHidden = true
                }
            })

//
    }

    func sendFcm(dest: String, name: String, text: String) {
        let url = "https://fcm.googleapis.com/fcm/send"
        let header : HTTPHeaders = [
            "Authorization" : "key=AAAAtq72hOo:APA91bG1AslRorFChyJchou_TCLtwDnTprBdmaf8FiUwbrG7udFAaKjT5wJjDMT2djLVP5LyutHygb0v7tMwodCIyudirFASBM8qZ7BPkaOUJ7h_o1lAtRZu9YwCiCvhDDGZl9vuGyO4"
        ]

        let notificationModel = NotificationModel()
        notificationModel.to = dest
        notificationModel.notification.title = name
        notificationModel.notification.body = text

        let params = notificationModel.toJSON()

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in

        }

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
            self.bottomConstraint.constant = keyboardSize.height - 20
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
        self.bottomConstraint.constant = 10
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
    
}

extension ChatRoomVC: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Section: \(section)"
//    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
//        return return comments[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EnterAlarmCell", for: indexPath) as? EnterAlarmCell else {
             return UITableViewCell()
         }
    
        
        if let username = appDelegate.enterName {
            if(cnt == 0) {
                cell.enterMessage.text = username + "님이 들어왔습니다."
                print("username: -------------------\(username) 님이 들어왔습니다.")
                cnt! += 1
                return cell
            }
        }
        
        if(self.comments[indexPath.row].uid != uid) {   // 상대방이 보내는 메세지
            let destinationUser = self.users![self.comments[indexPath.row].uid!]
            guard let decell = tableView.dequeueReusableCell(withIdentifier: "DestinationMessageCell", for: indexPath) as? DestinationMessageCell else {
                 return UITableViewCell()
             }
            decell.label_name.text = destinationUser!["name"] as! String
            decell.label_message.text = self.comments[indexPath.row].message
            decell.label_message.numberOfLines = 0
            if let time = self.comments[indexPath.row].timestamp {
                decell.label_time.text = time.todaytime
            }
            self.setReadCount(label: decell.label_readUsers, position: indexPath.row)

            return decell

        }
        else {     // 내가 보내는 메세지
            guard let mycell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as? MyMessageCell else {
                 return UITableViewCell()
             }
            mycell.label_message.text = self.comments[indexPath.row].message
            mycell.label_message.numberOfLines = 0
            if let time = self.comments[indexPath.row].timestamp {
                mycell.label_time.text = time.todaytime
            }
            self.setReadCount(label: mycell.label_readUsers, position: indexPath.row)

            return mycell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatToRoomSetting" {
            let vc = segue.destination as? RoomSettingVC
            vc?.chatRoomId = self.roomId
        }
    }
}



extension ChatRoomVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 이미지 선택 시 (일단 임시)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            //self.sendPhoto(image)
            }
            dismiss(animated: true, completion: nil)
        }
    
//    private func sendPhoto(_ image: UIImage) {
//        var isSendingPhoto: Bool? = true
//        FirebaseStor
//    }
    
}

extension ChatRoomVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    }
}

extension Int{
    var todaytime: String{
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.dateFormat = "a h:mm"
        let date = Date(timeIntervalSince1970: Double(self)/1000)
        return dateformatter.string(from: date)
        
    }
}

extension Int{
    var ymdTime: String {
        let nowDate = Date()
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.dateFormat = "yyyy년 MM월 dd일"
        return dateformatter.string(from: nowDate)
    }
}
//
//extension Date {
//    static func ymdTime(customString: String) -> Date {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
//        return dateFormatter.date(from: customString) ?? Date()
//    }
//}
