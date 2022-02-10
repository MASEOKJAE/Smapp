//
//  RegisterVC.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/24.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseDatabase

class RegisterVC: UIViewController {
    
    var ref: DatabaseReference!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var allAccept: UIButton!
    
    @IBOutlet weak var registerOne: UIButton!
    @IBOutlet weak var registerTwo: UIButton!
    @IBOutlet weak var registerThree: UIButton!
    @IBOutlet weak var registerFour: UIButton!
    
    @IBOutlet weak var termsBtn: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameSelect: UIButton!
    
    @IBAction func nameClicked(_ sender: UIButton) {
        if nameTextField.text != "" {
            //경고창
            let alert = UIAlertController(title: "이름 변경이 불가능합니다.", message: "계속 진행하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            
            let ok = UIAlertAction(title: "확인", style: .destructive) { (action) in
                //username 으로 설정
                self.userName()
                //홈 뷰로 이동
                let storyboard = UIStoryboard(name: "Register", bundle: nil)
                let TermsViewController = storyboard.instantiateViewController(identifier: "Terms")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(TermsViewController)
            }
            
            let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
            
            alert.addAction(cancel)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        } else {
            let warning = UIAlertController(title: "이름설정", message: "이름을 입력하시오.", preferredStyle: UIAlertController.Style.alert)
            let yes = UIAlertAction(title: "확인", style: .default, handler: nil)
            
            warning.addAction(yes)
            present(warning, animated: true, completion: nil)
        }
    }
    
    //이름 받고 FBDB에 업데이트
    func userName() {
        let refUser = ref.child("userList")
        
        refUser.child(String((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)).updateChildValues(["name": nameTextField.text!])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //약관 동의 체크 박스
    @IBAction func allAcceptAction(_ sender: Any) {
        self.allAccept.isSelected.toggle()
        self.registerOne.isSelected = true
        self.registerTwo.isSelected = true
        self.registerThree.isSelected = true
        self.registerFour.isSelected = true
    }
    
    @IBAction func registerOneAction(_ sender: Any) {
        self.registerOne.isSelected.toggle()
    }
    @IBAction func registerTwoAction(_ sender: Any) {
        self.registerTwo.isSelected.toggle()
    }
    
    @IBAction func registerThreeAction(_ sender: Any) {
        self.registerThree.isSelected.toggle()
    }
    @IBAction func registerFourAction(_ sender: Any) {
        self.registerFour.isSelected.toggle()
    }
    
    @IBAction func termsClicked(_ sender: Any) {
        if (registerOne.isSelected == true) && (registerTwo.isSelected == true) && (registerThree.isSelected == true) {
            //필수 3가지 체크된 경우 -> 카테고리 탭바로 이동
            let storyboard = UIStoryboard(name: "Categories", bundle: nil)
            let NavigationController = storyboard.instantiateViewController(identifier: "CategoriesNav")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(NavigationController)
        }
        else {
            //경고
            let alert = UIAlertController(title: nil, message: "모든 필수 약관에 동의 바람.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
    }
}
