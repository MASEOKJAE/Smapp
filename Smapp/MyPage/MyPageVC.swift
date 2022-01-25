//
//  MypageViewController.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/11.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseDatabase

class MyPageVC: UIViewController{
    
    var ref: DatabaseReference!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var partStudy: UIView!
    @IBOutlet weak var likeStudy: UIView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var settingButton: UIButton!
    

    
    
    //구글 로그인에서 가져온 정보들
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        
        let refUser = ref.child("userList")
        
        refUser.child(String(GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8) ?? "Error!")).getData(completion: {error, snapshot in
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? "Error!"
            
            self.userName.text = name
        })
        
        userEmail.text = GIDSignIn.sharedInstance.currentUser?.profile!.email
    }
    
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            partStudy.alpha = 1
            likeStudy.alpha = 0
        } else {
            partStudy.alpha = 0
            likeStudy.alpha = 1
        }
    }
    
}
