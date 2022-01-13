//
//  myTableVC.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/11.
//

import UIKit

class myLikedTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let likedTitleOfRoom = ["네똑 스터디 하실 분ㅠㅠ~", "웹서개 스터디 입니다!!"]
    let likedPartsOfRoom = ["2/4", "4/4"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return arr.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedTitleOfRoom.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath) as? CustomTableCell else {
             return UITableViewCell()
         }
         cell.likedRoomTitle.text = likedTitleOfRoom[indexPath.row]
         cell.LikedRoomParticipants.text = likedPartsOfRoom[indexPath.row]
         return cell

//        return UITableViewCell()
    }
}

