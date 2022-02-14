//
//  CustomTableCell.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/11.
//

import UIKit

class MyPageTableCell: UITableViewCell {
    
    @IBOutlet weak var roomTitle: UILabel!
    @IBOutlet weak var participants: UILabel!
    @IBOutlet weak var roomImage: UIImageView!
    
    @IBOutlet weak var chatsName: UILabel!
    @IBOutlet weak var chatsContent: UILabel!
    
    @IBOutlet weak var likedRoomTitle: UILabel!
    @IBOutlet weak var LikedRoomParticipants: UILabel!
    
    @IBOutlet weak var likedRoomImage: UIImageView!
    @IBOutlet weak var subject_prof: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Add width constraint if you want dynamic height
        contentView.translatesAutoresizingMaskIntoConstraints = true
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 40).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height/10).isActive = true
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        if selected {
                print("selected")
            }
    }
    
    
    func viewDidLoad() {
        roomTitle.font = .systemFont(ofSize: 40)
        roomTitle.adjustsFontSizeToFitWidth = true
        roomTitle.translatesAutoresizingMaskIntoConstraints = false
        roomTitle.textAlignment = .center
        roomTitle.sizeToFit()
        roomTitle.minimumScaleFactor = 0.2
    }
}
