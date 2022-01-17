//
//  CategoriesListCell.swift
//  Smapp
//
//  Created by 김성빈 on 2022/01/12.
//

import UIKit

class CategoriesListCell: UITableViewCell {
    var index: Int?
    @IBOutlet var majorLabel: UILabel!
    @IBOutlet var englishLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

    @IBAction func btnLike_Click(_ sender: Any) {
        if likeButton.tag == 1 { //empty
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tag = 0
        } else {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tag = 1
        }
    }
}
