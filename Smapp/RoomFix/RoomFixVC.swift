//
//  RoomFixVC.swift
//  Smapp
//
//  Created by 마석재 on 2022/01/20.
//

import UIKit
import FirebaseDatabase

class RoomFixVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var TitleFix: UITextField!
    @IBOutlet weak var SubjectFix: UITextField!
    @IBOutlet weak var ProfessorFix: UITextField!
    @IBOutlet weak var ContentsFix: UITextField!
    
    var TitleText:String? // 기존 방제목을 받아오기 위한 변수
    var SubjectText:String?
    var ProfessorText:String?
    var ContentsText:String?
    var OpenDateFix:String?
    var DueDateFix:String?
    var MajorFix:String?
    
    var IsClosedFix:Bool?
    var IsOnceFix:Bool?
    
    var RoomIdFix: Int? // 고치려는 roomId가 담겨 있음
    var NumberOfMaxFix:Int = 0
    var ListOfPartUserFix:[Int] = []
    
    var ref: DatabaseReference!
    
    @IBAction func FixCompleted(_ sender: UIButton) {
        let refRoom = ref.child("roomList")
        let fixData = [
            "title": TitleFix.text!,
            "subject": SubjectFix.text!,
            "professor": ProfessorFix.text!,
            "contents": ContentsFix.text!,
        ]
        refRoom.child("\(RoomIdFix!)").updateChildValues(fixData)
        
        let storyboard = UIStoryboard(name: "Subject", bundle: nil)
        let NavigationController = storyboard.instantiateViewController(identifier: "Nav")
        
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(NavigationController)
    }
    
    
    @IBOutlet var FixCompleted: UIButton!
    
    // 원하는 배경 설정
    
    func openLibrary(){
      picker.sourceType = .photoLibrary
      present(picker, animated: false, completion: nil)
    }
    func openCamera(){
      picker.sourceType = .camera
      present(picker, animated: false, completion: nil)
    }
    let picker = UIImagePickerController()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                    FixImageView.image = image
                    print(info)
                }

                dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet var FixImageView: UIImageView!
    
    @IBAction func FixAddImage(_ sender: UIButton) {
         let alert = UIAlertController(title: "사진 추가", message: "원하는 배경 설정", preferredStyle: UIAlertController.Style.alert)
        
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }
        
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
        self.openCamera()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(library)
        
        alert.addAction(camera)
        
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        
        picker.delegate = self
        
        // 기존 내용들을 가져옴
        if TitleText != nil {
            TitleFix.text = TitleText
        }
        if SubjectText != nil {
            SubjectFix.text = SubjectText
        }
        if ProfessorText != nil {
            ProfessorFix.text = ProfessorText
        }
        if ContentsText != nil {
            ContentsFix.text = ContentsText
        }
        
    }
}
