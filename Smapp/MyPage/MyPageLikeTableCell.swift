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
        
        // Add width constraint if you want dynamic height
        contentView.translatesAutoresizingMaskIntoConstraints = true
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 60).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height/10).isActive = true
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
