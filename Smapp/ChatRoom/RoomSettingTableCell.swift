//
//  RoomSettingTableCell.swift
//  Smapp
//
//  Created by 마석재 on 2022/02/16.
//

import UIKit

class RoomSettingTableCell: UITableViewCell {
    var TitleCell:String? // cell에 룸 데이터 전달 받기 위한 변수
    var SubjectCell:String?
    var ProfessorCell:String?
    var ContentsCell:String?
    var RoomIdCell: Int?
    
    @IBOutlet weak var roomMenus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        if selected {
                print("selected")
            let storyboard = UIStoryboard(name: "RoomSetting", bundle: nil)
            let EnterController  = storyboard.instantiateViewController(identifier: "Setting") as! RoomSettingVC
                    EnterController.TitleSetting = TitleCell // 방 제목 전달
                    EnterController.SubjectSetting = SubjectCell // 방 강의명 전달
                    EnterController.ProfessorSetting = ProfessorCell // 방 교수 전달
                    EnterController.ContentsSetting = ContentsCell // 방 스터디 설명 전달
                    EnterController.RoomIdSetting = RoomIdCell
            }
    }
}
