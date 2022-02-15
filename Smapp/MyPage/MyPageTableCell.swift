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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
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
