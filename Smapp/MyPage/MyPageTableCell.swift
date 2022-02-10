//
//  CustomTableCell.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/11.
//

import UIKit

class MyPageTableCell: UITableViewCell {
    var roomId: Int?
    @IBOutlet weak var roomTitle: UILabel!
    @IBOutlet weak var participants: UILabel!
    @IBOutlet weak var roomImage: UIImageView!
    
    @IBOutlet weak var chatsName: UILabel!
    @IBOutlet weak var chatsContent: UILabel!
    
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
    }
}
