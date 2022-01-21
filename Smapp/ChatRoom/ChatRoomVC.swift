//
//  ChatRoomVC.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/13.
//

import UIKit
import MobileCoreServices

class ChatRoomVC: UIViewController, UITextViewDelegate {
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var chatText: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var cameraMenu: UIButton!
    @IBOutlet weak var albumMenu: UIButton!
    @IBOutlet weak var fileMenu: UIButton!
    
    @IBOutlet weak var chatRoomTitle: UILabel!
    @IBOutlet weak var chatSubtitle: UILabel!
    
    let imagePicker = UIImagePickerController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        chatText.delegate = self
        
        let item = self.appDelegate.roomList[0]
        self.chatRoomTitle.text = item.title
        self.chatSubtitle.text = String(item.subject!) + "-" + String(item.professor!)
        
        // 세부 메뉴 설정
//        let cameraMenu = UIAction(title: "카메라", image: UIImage(systemName: "camera.fill"), handler: { _ in self.openCamera() })
//        let albumMenu = UIAction(title: "앨범", image: UIImage(systemName: "photo.fill"), handler: { _ in self.openLibrary() })
//        let fileMenu = UIAction(title: "파일", image: UIImage(systemName: "paperclip"), handler: { _ in self.openFile() })
        
//        menuButton.menu = UIMenu(title: "메뉴", identifier: nil, options: .displayInline, children: [fileMenu, albumMenu, cameraMenu])
        
        // 채팅 텍스트 박스 꾸미기
        chatText.layer.borderWidth = 0.5
        chatText.layer.borderColor = UIColor.gray.cgColor
        chatText.layer.cornerRadius = 10
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(_ sender: Notification) {
        // 텍스트 입력 시 키보드 올라갈 때 화면도 맞춰 올라가게끔
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
                let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                //keyHeight = keyboardHeight

                //self.view.frame.size.height -= keyboardHeight
            self.view.frame.origin.y -= keyboardHeight
    }

    @objc
    func keyboardWillHide(_ sender: Notification) {
        // 키보드 내려가면 화면 원상복귀
        self.view.frame.origin.y = 0
    }
    
    // 메뉴 버튼 누르면 세부 메뉴 뜨기
    @IBAction func tapMenuButton(_ sender: Any) {
        if self.menuView.isHidden == true {
            self.menuView.isHidden = false
        }
        else {
            self.menuView.isHidden = true
        }
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
    
    // 전송 버튼 누르면 키보드 내려가기
    @IBAction func tapSendButton(_ sender: Any) {
        chatText.resignFirstResponder()
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
