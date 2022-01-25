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
    
    @IBOutlet weak var allAccept: UIButton!
    
    @IBOutlet weak var registerOne: UIButton!
    @IBOutlet weak var registerTwo: UIButton!
    @IBOutlet weak var registerThree: UIButton!
    @IBOutlet weak var registerFour: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var nameSelect: UIButton!
    
    @IBAction func nameClicked(_ sender: UIButton) {
        userName()
    }
    
    func userName() {
        let refUser = ref.child("userList")
        
        refUser.child(String((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)).updateChildValues(["name": nameTextField.text!])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
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
}
