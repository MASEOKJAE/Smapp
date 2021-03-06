//
//  RoomEnterViewController.swift
//  Smapp
//
//  Created by 마석재 on 2022/01/17.
//
import UIKit
import GoogleSignIn
import FirebaseDatabase
import Alamofire

class RoomEnterVC: UIViewController {
    
    // 스터디룸 내용 수정 페이지에 전달
    @IBOutlet weak var RoomTitle: UILabel!
    @IBOutlet weak var SubjectTitle: UILabel!
    @IBOutlet weak var ProfessorName: UILabel!
    @IBOutlet weak var StudyContents: UILabel!

    @IBOutlet weak var RoomMajor: UILabel!
    @IBOutlet weak var CloseDate: UILabel!
    @IBOutlet weak var MaxNum: UILabel!
    
    @IBOutlet weak var RoomEnterButton: UIButton!

    @IBOutlet weak var KingName: UILabel!
    @IBOutlet weak var KingId: UILabel!
    
    var myName: String?
    
    var TitleOrigin:String? // 수정된 방제목을 받아오기 위한 변수
    var ClassOrigin:String?
    var ProfessorOrigin:String?
    var ContentsOrigin:String?
    
    var EnterIndex:Int? // 입장하기 데이터를 전달받기 위한 변수
    // var SaveOrder:Int? // DB에 저장된 순서대로 값을 받아 옴
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var ref: DatabaseReference!
    var willDisplayData = [RoomData]()

    var array: [UserModel] = []

    
    @IBAction func FixBtnClick(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "RoomFix", bundle: nil)
        let EnterController  = storyboard.instantiateViewController(identifier: "RoomFix") as! RoomFixVC
                    EnterController.MajorText = RoomMajor.text // 방 전공 전달
                    EnterController.TitleText = RoomTitle.text // 방 제목 전달
                    EnterController.SubjectText = SubjectTitle.text // 방 강의명 전달
                    EnterController.ProfessorText = ProfessorName.text // 방 교수 전달
                    EnterController.ContentsText = StudyContents.text // 방 스터디 설명 전달
                    EnterController.RoomIdFix = EnterIndex // 방 아이디 전달
                    EnterController.MaxNumText = Int(MaxNum.text!)! // 방 최대 인원 전달
                    EnterController.DueDateText = CloseDate.text // 방 마감 날짜 전달

                    present(EnterController, animated: true, completion: nil)
    }
    
    // 원하는 배경 설정
    
//    func openLibrary(){
//      picker.sourceType = .photoLibrary
//      present(picker, animated: false, completion: nil)
//    }
//    func openCamera(){
//      picker.sourceType = .camera
//      present(picker, animated: false, completion: nil)
//    }
//    let picker = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        
        
        //db읽고 방 listOfLikeRooms에 존재여부
        ref.child("userList").child(String((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)).getData(completion: {error, snapshot in
            let value = snapshot.value as? NSDictionary
            let likeRooms = value?["listOfLikeRoom"] as? NSMutableArray ?? []
            
            //likebutton 초기 설정
            if likeRooms.contains(self.EnterIndex!){
                self.LikeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else { self.LikeButton.setImage(UIImage(systemName: "heart"), for: .normal) }
        })
        
        let userListRef = ref.child("userList")
        
        userListRef.child(String((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)).getData(completion: {error, snapshot in
            let value = snapshot.value as? NSDictionary
            
            self.myName = value?["name"] as? String ?? "Error"
        })
//        picker.delegate = self
        

              
        updateLabel()
        
        // 수정된 내용들을 가져옴
        if TitleOrigin != nil {
            RoomTitle.text = TitleOrigin
        }
        if ClassOrigin != nil {
            SubjectTitle.text = ClassOrigin
        }
        if ProfessorOrigin != nil {
            ProfessorName.text = ProfessorOrigin
        }

        if ContentsOrigin != nil {
            StudyContents.text = ContentsOrigin
        }
    }
    

    
    // 선택한 cell에 해당하는 정보 DB에서 받아오는 작업
    func updateLabel(){
        let subinfo = EnterIndex!
        let roomListRef = ref.child("roomList").child("\(subinfo)")
        
        roomListRef.observeSingleEvent(of: .value, with: { [self] (snapshot) in
            for child in snapshot.children {
                let title = child as! DataSnapshot
                let titlekey = title.key
                let titlevalue = title.value!
                

                if titlekey == "title" {
                    self.RoomTitle.text = titlevalue as? String
                } else if titlekey == "subject" {
                    self.SubjectTitle.text = titlevalue as? String
                } else if titlekey == "professor" {
                    self.ProfessorName.text = titlevalue as? String
                } else if titlekey == "contents" {
                    self.StudyContents.text = titlevalue as? String
                } else if titlekey == "major" {
                    self.RoomMajor.text = titlevalue as? String
                } else if titlekey == "dueDate" {
                    self.CloseDate.text = titlevalue as? String
                } else if titlekey == "numberOfMax" {
                    self.MaxNum.text = "\(titlevalue)"
                } else if titlekey == "king" {
                    self.KingId.text = "\(titlevalue)"
                    ref.child("userList").child(self.KingId.text!).getData(completion: {error, snapshot in
                        let value = snapshot.value as? NSDictionary
                        let name = value?["name"] as? String ?? "Error!"
                        
                        self.KingName.text = "\(name)"
                    })
                }
            }
        })

    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
//                    ImageView.image = image
//                    print(info)
//                }
//
//                dismiss(animated: true, completion: nil)
//    }
    
   
    @IBOutlet var ImageView: UIImageView!


//    @IBAction func AddImage(_ sender: UIButton) {
//        let alert = UIAlertController(title: "사진 추가", message: "원하는 배경 설정", preferredStyle: UIAlertController.Style.alert)
//
//        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
//        }
//
//        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
//        self.openCamera()
//        }
//
//        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//
//        alert.addAction(library)
//
//        alert.addAction(camera)
//
//        alert.addAction(cancel)
//
//        present(alert, animated: true, completion: nil)
//    }
        
    
    
    // 스터디룸 입장하기 버튼 누르면 입장하는 유저, 방 정보 DB에 추가 + chatroom에 user 추가
    @IBAction func ClickRoomEnter(_ sender: Any) {
        let myUid: Int! = Int((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)
        
        // roomList의 listOfPartUser에 유저 추가 (중복 허용 x)
        let roomid = String(self.EnterIndex!)
        let roomListRef = self.ref.child("roomList").child(roomid)
        
        roomListRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            for child in snapshot.children {
                let title = child as! DataSnapshot
                let titlekey = title.key
                let titlevalue = title.value!
                var listOfPartUsers: [Int]?
                
                if titlekey == "listOfPartUser" {
                    listOfPartUsers = titlevalue as? [Int]
                    
                if let firstIndex = listOfPartUsers?.firstIndex(of: myUid!) {
                    return
                } else {
                    listOfPartUsers?.append(myUid)
                    roomListRef.child("listOfPartUser").setValue(listOfPartUsers)
                }
                }
                
            }
        })
        
        
        
        
        // userList의 listOfPartRoom에 입장하는 방 번호 추가 (중복 허용 x)
        let userListRef = ref.child("userList")
        userListRef.child(String(myUid)).getData(completion: {error, snapshot in
            let value = snapshot.value as? NSDictionary
            let listOfPartRoom = value?["listOfPartRoom"] as? NSMutableArray ?? []
            self.appDelegate.enterName = value?["name"] as? String
            
            if listOfPartRoom.contains(self.EnterIndex!) {
                return
            } else {
                listOfPartRoom.add(self.EnterIndex!)
            }
        
           userListRef.child(String(myUid)).child("listOfPartRoom").setValue(listOfPartRoom)
        })
        
        // chatroom 에 참여하는 user 추가
        let chatListRef = ref.child("chatRooms")
        chatListRef.child(String(self.EnterIndex!)).getData(completion: {error, snapshot in
            let value = snapshot.value as? NSDictionary
            let users = value?["users"] as? NSDictionary
            
            print("users list -------------: ")
            print(users)
            if users == nil {
                return
            }
            if (users![String(myUid)] != nil) == true {
                return
            } else {
                self.sendMessage()
                chatListRef.child(String(self.EnterIndex!)).child("users").updateChildValues([String(myUid):true])
            }
        })
        
        _ = self.navigationController?.popViewController(animated: true)
    
    }
    
    // 메세지 보내기
    @objc
    func sendMessage() {
        let value: Dictionary<String, Any> = [
            "uid": "CRA",
            "message": self.myName! + "님이 입장하였습니다",
            "timestamp": ServerValue.timestamp(),
            "ymdTime": "0"
        ]

        let chatListRef = ref.child("chatRooms")
        chatListRef.child(String(self.EnterIndex!)).child("comments").childByAutoId().setValue(value)
           
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

                if segue.identifier == "roomEnterToChat" {
                    let vc = segue.destination as? ChatRoomVC
                    vc?.roomId = self.EnterIndex
                }
            }
    

    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
//                    ImageView.image = image
//                    print(info)
//                }
//
//                dismiss(animated: true, completion: nil)
//    }
    
   


    
    @IBOutlet weak var LikeButton: UIButton!
    
    
    @IBAction func LikeButtonClick(_ sender: UIButton) {
        //read data
        let refUser = ref.child("userList")
        
        //room indexPath.row
        let roominfo = EnterIndex!
    
        refUser.child(String((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)).getData(completion: {error, snapshot in
            let value = snapshot.value as? NSDictionary
            let likeRooms = value?["listOfLikeRoom"] as? NSMutableArray ?? []
                        
            //Likebutton 작동
            if likeRooms.contains(roominfo) {
                self.LikeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                
                //likeRooms array에서 방 제거
                likeRooms.remove(roominfo)
            } else {
                self.LikeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                
                //likeRooms array에서 방 추가
                likeRooms.add(roominfo)
            }
            
            //update data
            refUser.child(String((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)).child("listOfLikeRoom").setValue(likeRooms)
        })
    }
    
    
    // 스터디 방 공유 기능
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
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
    } // Toast Message 구현을 위한 함수
    
    
    @IBOutlet weak var ShareButton: UIButton!
    
    @IBAction func ClickShare(_ sender: UIButton) {
        let shareText: String = "스터디룸 제목: \(RoomTitle.text!)"
        var shareObject = [Any]()

        shareObject.append(shareText)

        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)

        activityViewController.popoverPresentationController?.sourceView = self.view

        self.present(activityViewController, animated: true, completion: nil)

        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                self.showToast(message: "복사 완료", font: .systemFont(ofSize: 12.0))
            }
            else {
                self.showToast(message: "복사 취소", font: .systemFont(ofSize: 12.0))
            }
            if let shareError = error {
                self.showToast(message: "\(shareError.localizedDescription)", font: .systemFont(ofSize: 12.0))
            }
        }
    }
}
