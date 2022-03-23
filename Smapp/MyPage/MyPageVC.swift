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
        
    @IBOutlet weak var partStudy: UIView!
    @IBOutlet weak var likeStudy: UIView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        
        let userListRef = ref.child("userList")
        
        userListRef.child(String((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)).getData(completion: {error, snapshot in
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? "Error!"
            
            self.userName.text! = name
        })

        userEmail.text = GIDSignIn.sharedInstance.currentUser?.profile!.email
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let childVC = self.children[1] as? MyPagePartTableVC {
            childVC.viewWillAppear(true)
        }
    }
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
//            partStudy.alpha = 1
//            likeStudy.alpha = 0
            partStudy.isHidden = false
            likeStudy.isHidden = true
            if let childVC = self.children[1] as? MyPagePartTableVC {
                childVC.viewWillAppear(true)
            }
        } else {
//            partStudy.alpha = 0
//            likeStudy.alpha = 1
            partStudy.isHidden = true
            likeStudy.isHidden = false
            if let childVC = self.children[0] as? MyPageLikedTableVC {
                childVC.viewWillAppear(true)
            }
        }
    }
}
