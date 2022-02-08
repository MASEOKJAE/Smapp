//
//  SubjectCell.swift
//  Smapp
//
//  Created by 이예준 on 2022/01/14.
//

import UIKit

class SubjectCell: UICollectionViewCell {
    var roomId: Int?
    @IBOutlet weak var roomTitle: UILabel!
    @IBOutlet weak var information: UILabel!
    @IBOutlet weak var member: UILabel!
    @IBOutlet weak var LikeImage: UIImageView!
}
