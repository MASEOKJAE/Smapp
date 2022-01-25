//
//  MypageViewController.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/11.
//

import UIKit
import GoogleSignIn

class MyPageVC: UIViewController{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        
        userName.text = (self.appDelegate.userList[self.appDelegate.userList.count - 1].name!)
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
