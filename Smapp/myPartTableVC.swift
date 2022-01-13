//
//  myTableVC.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/11.
//

import UIKit

class myPartTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let titleOfRoom = ["특론 스터디 모집~", "머러 스터디 구해요!", "데구 같이 공부하실분", "자바 궁금한 거", "논설 알려주실분ㅠㅠ",
    "OSS 스터디입니다", "컴비 같이 하실분"]
    let partsOfRoom = ["3/4", "1/4", "4/4", "2/2", "1/3", "1/2", "2/3"]
    let chattingName = ["최진아", "이예준", "마석재", "김성빈", "크랑이", "크라", "CRA"]
    let chattingContent = ["오늘 2시에 괜찮으신가요?","네 이따가 봅시다!", "안녕하세요", "이거는 그 문제 같은데요..? 블라블라 블라블라", "소라에서 볼까요?", "넵", "거의 다 도착했습니다!"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return arr.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleOfRoom.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath) as? CustomTableCell else {
             return UITableViewCell()
         }
        cell.roomTitle.text = titleOfRoom[indexPath.row]
        cell.participants.text = partsOfRoom[indexPath.row]
        cell.chatsName.text = chattingName[indexPath.row]
        cell.chatsContent.text = chattingContent[indexPath.row]
        
        return cell

//        return UITableViewCell()
    }
}

