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
    
    var uid: String?
    var chatRoomUid: String?
    public var destinationUid: String?   // 나중에 내가 채팅할 대상의 uid
    var comments : [ChatModel.Comment] = []
    var userModel: UserModel?
    var ref: DatabaseReference!
    
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
        
        checkChatRoom()
        
        // 일단 마이페이지에서 데이터 받음 -> 고쳐야함
//        let item = self.appDelegate.roomList[roomIndex!]
//        self.chatRoomTitle.text = item.title
//        self.chatSubtitle.text = String(item.subject!) + "-" + String(item.professor!)
//
        
        
        // 채팅 텍스트 박스 꾸미기
        chatText.layer.borderWidth = 0.5
        chatText.layer.borderColor = UIColor.gray.cgColor
        chatText.layer.cornerRadius = 10
        
        self.tabBarController?.tabBar.isHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //방 생성
    func createRoom() {
        let createRoomInfo : Dictionary<String, Any> = [ "users": [
                uid!: true,
                destinationUid!: true
            ]
        ]
        let refChatrooms = ref.child("chatrooms")
        
        if(chatRoomUid == nil) {
            self.sendButton.isEnabled = false
            refChatrooms.childByAutoId().setValue(createRoomInfo, withCompletionBlock: {(err, ref) in
                if(err == nil) {
                    self.checkChatRoom()
                }
            })
        } else {
            let value: Dictionary<String, Any> = [
                "uid": uid!,
                "message":chatText.text!
            ]
            // 메세지 보내면 텍스트필드 초기화
            refChatrooms.child(chatRoomUid!).child("comments").childByAutoId().setValue(value, withCompletionBlock: {(err, ref) in
                    self.chatText.text = ""
            })
        }

    }
    
    // 방 중복 확인
    func checkChatRoom() {
        let refChatrooms = ref.child("chatrooms")
        refChatrooms.queryOrdered(byChild: "users/"+uid!).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value, with: {(datasnapshot) in
            for item in datasnapshot.children.allObjects as! [DataSnapshot]{
                
                if let chatRoomdic = item.value as? [String:AnyObject] {
                    let chatModel = ChatModel(JSON: chatRoomdic)
                    if(chatModel?.users[self.destinationUid!] == true){
                        self.chatRoomUid = item.key
                        self.sendButton.isEnabled = true
                        self.getDestinationInfo()
                    }
                }
                
            }
        })
    }
    
    // 상대의 정보 가져오기
    func getDestinationInfo() {
        let refUsers = ref.child("userList")
        refUsers.child(self.destinationUid!).observeSingleEvent(of: DataEventType.value, with: { (datasnapshot) in
//        refUsers.child(self.destinationUid!).observe(DataEventType.value, with:  { (datasnapshot) in
            self.userModel = UserModel()
            self.userModel?.setValuesForKeys(datasnapshot.value as! [String : Any])
            self.getMessageList()
        })
    }
    
    //메세지 가져오기
    func getMessageList() {
        let refChatrooms = ref.child("chatrooms")
        refChatrooms.child(self.chatRoomUid!).child("comments").observe(DataEventType.value, with: { (datasnapshot) in
            self.comments.removeAll()
            for item in datasnapshot.children.allObjects as! [DataSnapshot] {
                let comment = ChatModel.Comment(JSON: item.value as! [String:AnyObject])
                self.comments.append(comment!)
            }
            self.tableView.reloadData()
            
            let count = self.comments.count - 1
            if self.comments.count > 0 {
                self.tableView.scrollToRow(at: IndexPath(item:count, section:0), at: UITableView.ScrollPosition.bottom, animated: true)
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
        createRoom()
    }
    
}

extension ChatRoomVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(self.comments[indexPath.row].uid == uid) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as? MyMessageCell else {
                 return UITableViewCell()
             }
            cell.label_message.text = self.comments[indexPath.row].message
            cell.label_message.numberOfLines = 0
            if let time = self.comments[indexPath.row].timestamp {
                cell.label_time.text = time.todaytime
            }
            return cell
            
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationMessageCell", for: indexPath) as? DestinationMessageCell else {
                 return UITableViewCell()
             }
            cell.label_name.text = self.userModel?.name
            cell.label_message.text = self.comments[indexPath.row].message
            cell.label_message.numberOfLines = 0
            if let time = self.comments[indexPath.row].timestamp {
                cell.label_time.text = time.todaytime
            }
            
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

