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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    @IBAction func signOut(sender: Any) {
        //signout instance
        GIDSignIn.sharedInstance.signOut()
        
        //로그인 뷰로 이동
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(LoginViewController)
    }
}
