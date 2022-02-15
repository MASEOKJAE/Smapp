//
//  AppDelegate.swift
//  Smapp
//
//  Created by 마석재 on 2022/01/04.
//

import UIKit
import Firebase
import GoogleSignIn
import UserNotifications
import Alamofire

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var enterName: String?
    
    var ref: DatabaseReference!
    var uid: String?
    var background: Int?
    
    var roomList = [RoomData]()
    var userList = [UserData]()
    var majorList = ["글로벌리더십학부", "전산전자공학부", "콘텐츠융합디자인학부", "경영경제학부", "공간환경시스템공학부", "국제어문학부", "기계제어공학부", "법학부", "상담심리사회복지학부", "생명과학부", "창의융합교육원", "커뮤니케이션학부", "AI융합교육원", "ICT창업학부"]
    
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
                self.uid = String((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)
                self.ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
                
                let refUser = self.ref.child("userList")
                
                refUser.child(self.uid!).updateChildValues(["token": Messaging.messaging().fcmToken!])
                
                // Show the app's signed-in state.
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            }
        }
        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            }
            else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
        
        UNUserNotificationCenter.current().delegate = self

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization( options: authOptions, completionHandler: {_, _ in })
        }
        else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
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


extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("파이어베이스 토큰: \(fcmToken)")
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {

    // 푸시알림이 수신되었을 때 수행되는 메소드
    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("메시지 수신")
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse,withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
}

extension AppDelegate {
    func changeCode(code: Int) {
        self.ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        
        let userListRef = self.ref.child("userList")
        
        if(self.uid != nil) {
            userListRef.child(self.uid!).updateChildValues(["isBackground": code])
        }
    }
}
