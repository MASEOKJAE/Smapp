//
//  CustomTableCell.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/11.
//

import UIKit

class CustomTableCell: UITableViewCell {
    
    @IBOutlet weak var roomTitle: UILabel!
    @IBOutlet weak var participants: UILabel!
    
    @IBOutlet weak var chatsName: UILabel!
    @IBOutlet weak var chatsContent: UILabel!
    
    @IBOutlet weak var likedRoomTitle: UILabel!
    @IBOutlet weak var LikedRoomParticipants: UILabel!
    
    
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
