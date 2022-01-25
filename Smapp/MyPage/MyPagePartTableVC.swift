//
//  myTableVC.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/11.
//

import UIKit

class MyPagePartTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let chattingName = ["최진아", "이예준", "마석재", "김성빈", "크랑이", "크라", "CRA"]
    let chattingContent = ["오늘 2시에 괜찮으신가요?","네 이따가 봅시다!", "안녕하세요", "이거는 그 문제 같은데요..? 블라블라 블라블라", "소라에서 볼까요?", "넵", "거의 다 도착했습니다!"]

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initRefresh()
    }
    
    func initRefresh() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
        //refresh.attributedTitle = NSAttributedString(string: "새로고침")
        
        tableView.addSubview(refresh)
    }
    
    @objc
    func updateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appDelegate.roomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath) as? MyPageTableCell else {
             return UITableViewCell()
         }
        
        let item = self.appDelegate.roomList[indexPath.item]
        
        cell.roomTitle.text = item.title
        //cell.participants.text = String(item.listOfPartUser?.count!) + "/" + String(item.numberOfMax!)
        cell.chatsName.text = chattingName[indexPath.row]
        cell.chatsContent.text = chattingContent[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyPageToChat" {
            let vc = segue.destination as? ChatRoomVC
            let selectedIndex = tableView.indexPathForSelectedRow
            vc?.roomIndex = Int((selectedIndex?.row)!)
        }
    }
    
    
}

