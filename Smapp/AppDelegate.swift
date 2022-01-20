//
//  AppDelegate.swift
//  Smapp
//
//  Created by 마석재 on 2022/01/04.
//

import UIKit
import Firebase
import GoogleSignIn
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var roomList = [RoomData]()
    var userList = [UserData]()
    var majorList = ["글로벌리더십학부", "전산전자공학부", "콘텐츠융합디자인학부", "경영경제학부", "공간환경시스템공학부", "국제어문학부", "기계제어공학부", "법학부", "산업교육학부", "상담심리사회복지학부", "생명과학부", "창의융합교육원", "커뮤니케이션학부", "AI융합교육원", "ICT창업학부"]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let LoginViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(LoginViewController)
            } else {
                // Show the app's signed-in state.
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            }
        }
        return true
    }
    
    // google login handler
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool

          handled = GIDSignIn.sharedInstance.handle(url)
          if handled {
            return true
          }
          // Handle other custom URL types.
          // If not handled by this app, return false.
          return false
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

