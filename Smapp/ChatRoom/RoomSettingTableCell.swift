//
//  RoomSettingTableCell.swift
//  Smapp
//
//  Created by 마석재 on 2022/02/16.
//

import UIKit

class RoomSettingTableCell: UITableViewCell {
    
    
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
            }
    }
}
