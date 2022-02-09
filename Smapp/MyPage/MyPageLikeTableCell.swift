//
//  MyPageLikeTableCell.swift
//  Smapp
//
//  Created by 최진아 on 2022/02/08.
//

import UIKit

class MyPageLikeTableCell: UITableViewCell {
    @IBOutlet weak var likedRoomTitle: UILabel!
    @IBOutlet weak var LikedRoomParticipants: UILabel!
    
    @IBOutlet weak var likedRoomImage: UIImageView!
    @IBOutlet weak var subject_prof: UILabel!
    
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
