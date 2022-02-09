//
//  ViewController.swift
//  Smapp
//
//  Created by 마석재 on 2022/01/04.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseDatabase

class LoginVC: UIViewController {
    
    //DB 정보 전달
    var ref: DatabaseReference!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var AppTitle: UILabel!
    @IBOutlet var AppSubTitle: UILabel!
    @IBOutlet var GoogleLogin: UIButton!
    
    var emailAddress: String?
    var familyName: String?
    var profilePicUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
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
            Auth.auth().signIn(with: credential) { [self]_,_ in
                // token을 넘겨주면, 성공했는지 안했는지에 대한 result값과 error값을 넘겨줌
                
                
                //valid email이 아닌경우 로그인뷰에서 이동하지 못하도록 return함, 이동하는 코드는 이 코드 밑에...
                if self.forceLogout((GIDSignIn.sharedInstance.currentUser?.profile!.email)!) == false { return }
                
                //firebase realtime database 연동
                let refUser = ref.child("userList")

                let userInputData = [
                    "email": GIDSignIn.sharedInstance.currentUser?.profile!.email,
                    "studentId": Int((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)!,
                    "token": Messaging.messaging().fcmToken!
                ] as [String : Any]
                
                refUser.child(String((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)).updateChildValues(userInputData)
                
                //self.showToast(message: "로그인 완료", font: .systemFont(ofSize: 15.0))
                
                refUser.child(String((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)).child("name").getData(completion: {error, snapshot in
                    let value = snapshot.value as? String
                    print("\n\n\n\n\(String(describing: value))\n\n\n\n")
                    //로그인한 유저의 이메일이 db에 존재하면
                    if value != nil {
                        
                        //SubjectVC 페이지로 이동
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let MainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                        
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(MainTabBarController)
                    } else {
                        //RegisterVC 페이지로 이동
                        let storyboard = UIStoryboard(name: "Register", bundle: nil)
                        let RegisterVC = storyboard.instantiateViewController(identifier: "RegisterName")
                        
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(RegisterVC)
                    }
                })
            }
        }
    }
    
    
    //"handong.edu" 검사
    func isValidEmail(_ testStr:String) -> Bool {
        if testStr.contains("handong") {
            return true
        } else {
            return false
        }
    }
    
    
    //강제 로그아웃
    func forceLogout(_ sender: String) -> Bool{
        if isValidEmail(sender) == false {
            //signout instance
            GIDSignIn.sharedInstance.signOut()
            
            //로그인 에러 팝업
            self.showToast(message: "한동 메일이 아닙니다", font: .systemFont(ofSize: 15.0))
            
            return false
        }
        return true
    }
}
    

extension LoginVC {
    //toast 메세지
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 60))
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
    }
}
