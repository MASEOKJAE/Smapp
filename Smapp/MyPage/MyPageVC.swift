//
//  MypageViewController.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/11.
//

import UIKit
import GoogleSignIn

class MyPageVC: UIViewController{
    
    @IBOutlet weak var partStudy: UIView!
    @IBOutlet weak var likeStudy: UIView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var settingButton: UIButton!
    

    @IBAction func tapSettingButton(_ sender: Any) {
        performSegue(withIdentifier: "MyPagetoSetting", sender: nil)
    }
    
    
    //구글 로그인에서 가져온 정보들
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.text = GIDSignIn.sharedInstance.currentUser?.profile!.familyName
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
