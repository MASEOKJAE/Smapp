//
//  RoomFixVC.swift
//  Smapp
//
//  Created by 마석재 on 2022/01/20.
//

import UIKit

class RoomFixVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var TitleFix: UITextField!
    @IBOutlet weak var ClassFix: UITextField!
    @IBOutlet weak var ProfessorFix: UITextField!
    @IBOutlet weak var ExplainFix: UITextField!
    
    var TitleText:String? // 기존 방제목을 받아오기 위한 변수
    var ClassText:String?
    var ProfessorText:String?
    var ExplainText:String?
    
    @IBAction func FixCompleted(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "RoomEnter", bundle: nil)
        let FixController = storyboard.instantiateViewController(identifier: "RoomEnter") as! RoomEnterVC
                    FixController.TitleOrigin = TitleFix.text // 수정된 방 제목 전달
                    FixController.ClassOrigin = ClassFix.text // 수정된 강의명 전달
                    FixController.ProfessorOrigin = ProfessorFix.text // 수정된 방 교수 전달
        FixController.ContentsOrigin = ExplainFix.text // 수정된 방 스터디 설명 전달
                    present(FixController, animated: true, completion: nil)
        
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        // 기존 내용들을 가져옴
        if TitleText != nil {
            TitleFix.text = TitleText
        }
        if ClassText != nil {
            ClassFix.text = ClassText
        }
        if ProfessorText != nil {
            ProfessorFix.text = ProfessorText
        }
        if ExplainText != nil {
            ExplainFix.text = ExplainText
        }
        
    }
}
