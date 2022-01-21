//
//  SettingTableCell.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/21.
//

import UIKit

class SettingTableCell: UITableViewCell {
    
    @IBOutlet weak var menus: UILabel!
    
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
