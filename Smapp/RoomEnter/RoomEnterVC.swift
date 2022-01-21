//
//  RoomEnterViewController.swift
//  Smapp
//
//  Created by 마석재 on 2022/01/17.
//

import UIKit

class RoomEnterVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    // 스터디룸 내용 수정 페이지에 전달
    @IBOutlet weak var RoomTitle: UILabel!
    @IBOutlet weak var ClassTitle: UILabel!
    @IBOutlet weak var ProfessorName: UILabel!
    @IBOutlet weak var StudyExplain: UILabel!
    
    var TitleOrigin:String? // 수정된 방제목을 받아오기 위한 변수
    var ClassOrigin:String?
    var ProfessorOrigin:String?
    var ExplainOrigin:String?
    
    @IBAction func FixBtnClick(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "RoomFix", bundle: nil)
        let EnterController  = storyboard.instantiateViewController(identifier: "RoomFix") as! RoomFixVC
                    EnterController.TitleText = RoomTitle.text // 방 제목 전달
                    EnterController.ClassText = ClassTitle.text // 방 강의명 전달
                    EnterController.ProfessorText = ProfessorName.text // 방 교수 전달
                    EnterController.ExplainText = StudyExplain.text // 방 스터디 설명 전달
                    present(EnterController, animated: true, completion: nil)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        // 수정된 내용들을 가져옴
        if TitleOrigin != nil {
            RoomTitle.text = TitleOrigin
        }
        if ClassOrigin != nil {
            ClassTitle.text = ClassOrigin
        }
        if ProfessorOrigin != nil {
            ProfessorName.text = ProfessorOrigin
        }
        if ExplainOrigin != nil {
            StudyExplain.text = ExplainOrigin
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                    ImageView.image = image
                    print(info)
                }

                dismiss(animated: true, completion: nil)
    }
    
   
    @IBOutlet var ImageView: UIImageView!
    
    
    @IBAction func AddImage(_ sender: UIButton) {
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
    
    @IBOutlet weak var LikeButton: UIButton!
    
    
    
    @IBAction func LikeButtonClick(_ sender: UIButton) {
         if LikeButton.tag == 0 {
            LikeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            LikeButton.tag = 1
        }
        else{
            LikeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            LikeButton.tag = 0
        }
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
        let shareText: String = "스터디방 공유"
        var shareObject = [Any]()
        
        shareObject.append(shareText)
        
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed { self.showToast(message: "복사 완료", font: .systemFont(ofSize: 12.0))
            }
            else { self.showToast(message: "복사 취소", font: .systemFont(ofSize: 12.0))
            }
            if let shareError = error {
                self.showToast(message: "\(shareError.localizedDescription)", font: .systemFont(ofSize: 12.0))
            }
        }
    }
}
