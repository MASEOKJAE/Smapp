//
//  ViewController.swift
//  Smapp
//
//  Created by 마석재 on 2022/01/04.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginVC: UIViewController {

    @IBOutlet var AppTitle: UILabel!
    @IBOutlet var AppSubTitle: UILabel!
    @IBOutlet var GoogleLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func TapGoogleLogin(_ sender: Any) {
        let signInConfig = GIDConfiguration.init(clientID: "784619439338-5521ne6gp5nq2p57pjm3vaphh04g1ncq.apps.googleusercontent.com")
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }

            guard let authentication = user?.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken: authentication.accessToken)
            // access token 부여 받음
            
            // 파베 인증정보 등록
            //로그인 성공하면
            Auth.auth().signIn(with: credential) {_,_ in
                // token을 넘겨주면, 성공했는지 안했는지에 대한 result값과 error값을 넘겨줌
                
                //메인 탭바로 이동
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                
                // This is to get the SceneDelegate object from your view controller
                // then call the change root view controller function to change to main tab bar
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                
                //사용자 정보 가져오기
                GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
                    guard error == nil else { return }
                    guard let user = user else { return }

                    let emailAddress = user.profile?.email

                    let fullName = user.profile?.name
                    let givenName = user.profile?.givenName
                    let familyName = user.profile?.familyName

                    let profilePicUrl = user.profile?.imageURL(withDimension: 320)
                }
            }
        }
    }
}
