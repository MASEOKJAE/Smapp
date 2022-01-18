//
//  RoomEnterViewController.swift
//  Smapp
//
//  Created by 마석재 on 2022/01/17.
//

import UIKit

class RoomEnterVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
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
    
}
