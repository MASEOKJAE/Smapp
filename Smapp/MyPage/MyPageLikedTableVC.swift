//
//  myTableVC.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/11.
//

import UIKit
import FirebaseDatabase
import GoogleSignIn

class MyPageLikedTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var likeRoomArray: [RoomData] = []
    var listOfLikeRoomId: [Int?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initRefresh()
        ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchListOfLikeRoomId()
        updateData()
    }
    
    func initRefresh() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
        //refresh.attributedTitle = NSAttributedString(string: "새로고침")
        
        tableView.addSubview(refresh)
    }
    
    // 유저가 관심있는 방 번호 가져오기
    func fetchListOfLikeRoomId() {
        let myUid: Int! = Int((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)
        let userListRef = ref.child("userList")
        userListRef.child(String(myUid)).getData(completion: {error, snapshot in
            let value = snapshot.value as? NSDictionary
            self.listOfLikeRoomId = value?["listOfLikeRoom"] as? Array ?? []
        })
    }
    

    func updateData() {
        let refRoom = ref.child("roomList")
        refRoom.observe(DataEventType.value, with:  { (snapshot) in
            self.likeRoomArray.removeAll()

            for item in snapshot.children.allObjects as! [DataSnapshot] {
                let roomList = RoomData(dic: item.value as! [String:Any])
                if self.listOfLikeRoomId.contains(roomList.roomId) {    // 유저가 관심있는 방만 가져오기
                    self.likeRoomArray.append(roomList)
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    @objc
    func updateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        updateData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.likeRoomArray.count
//        return self.appDelegate.roomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageLikeTableCell", for: indexPath) as? MyPageLikeTableCell else {
             return UITableViewCell()
         }
        
        let item = self.likeRoomArray[indexPath.row]

        cell.likedRoomTitle.text = item.title
        cell.LikedRoomParticipants.text = String(item.listOfPartUser?.count ?? -1) + "/" + String(item.numberOfMax!)
         cell.subject_prof.text = String(item.subject!) + "-" + String(item.professor!)

         return cell

//        let item = self.appDelegate.roomList[indexPath.row]
//
//        cell.likedRoomTitle.text = item.title
//        //cell.LikedRoomParticipants.text = String(item.numberOfPart!) + "/" + String(item.numberOfMax!)
//        cell.subject_prof.text = String(item.subject!) + "-" + String(item.professor!)
//
//        return cell

    }
    
}

