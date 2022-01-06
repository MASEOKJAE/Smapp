//
//  ViewController.swift
//  Smapp
//
//  Created by 마석재 on 2022/01/04.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController {

    @IBOutlet var AppTitle: UILabel!
    @IBOutlet var AppSubTitle: UILabel!
    @IBOutlet var GoogleLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }


    @IBAction func TapGoogleLogin(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let signInConfig = GIDConfiguration.init(clientID: clientID)
        
      GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
        guard error == nil else { return }

        guard let authentication = user?.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken: authentication.accessToken)
        // access token 부여 받음
        
        // 파베 인증정보 등록
        Auth.auth().signIn(with: credential) {_,_ in
            // token을 넘겨주면, 성공했는지 안했는지에 대한 result값과 error값을 넘겨줌
            //self.showMainViewController()
        }
      }
    }
}
