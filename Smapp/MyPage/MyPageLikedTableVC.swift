//
//  myTableVC.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/11.
//

import UIKit

class MyPageLikedTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        cell.likedRoomTitle.text = item.title
        cell.LikedRoomParticipants.text = String(item.numberOfPart!) + "/" + String(item.numberOfMax!)
         cell.subject_prof.text = String(item.subject!) + "-" + String(item.professor!)
        
         return cell

//        return UITableViewCell()
    }
    
}

