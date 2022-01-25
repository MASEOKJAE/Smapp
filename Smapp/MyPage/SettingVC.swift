//
//  SettingVC.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/21.
//

import UIKit
import GoogleSignIn

class SettingVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var logoutButton: UIButton!
    let myPageMenu = ["공지사항", "전공 수정", "알림 설정", "개발자에게 피드백", "회원목록(테스트)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.logoutButton.layer.borderWidth = 0.5
        self.logoutButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    @IBAction func signOut(_ sender: Any) {
        // 경고창
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        
        let ok = UIAlertAction(title: "확인", style: .destructive) { (action) in
            //signout instance
            GIDSignIn.sharedInstance.signOut()
            
            //로그인 뷰로 이동
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let LoginViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(LoginViewController)
        }
        let cancle = UIAlertAction(title: "취소", style: .default, handler: nil)
        
        alert.addAction(cancle)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

extension SettingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myPageMenu.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "notice", sender: nil)
        case 1:
            performSegue(withIdentifier: "reselectMajor", sender: nil)
        case 2:
            performSegue(withIdentifier: "setAlarm", sender: nil)
        case 3:
            performSegue(withIdentifier: "feedBack", sender: nil)
        case 4:
            performSegue(withIdentifier: "peopleview", sender: nil)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell", for: indexPath) as? SettingTableCell else {
             return UITableViewCell()
         }
        cell.menus.text = myPageMenu[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
}

