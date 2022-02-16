//
//  RoomSettingVC.swift
//  Smapp
//
//  Created by 마석재 on 2022/02/16.
//

import UIKit

class RoomSettingVC: UIViewController {
    
    
    @IBOutlet weak var RoomTableView: UITableView!
    let RoomMenu = ["스터디룸 수정"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RoomSettingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.RoomMenu.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "RoomFix", sender: nil)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RoomSettingTableCell", for: indexPath) as? RoomSettingTableCell else {
             return UITableViewCell()
         }
        cell.roomMenus.text = RoomMenu[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
