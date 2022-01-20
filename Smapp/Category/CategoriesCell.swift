//
//  CategoriesListCell.swift
//  Smapp
//
//  Created by 김성빈 on 2022/01/12.
//

import UIKit

class CategoriesCell: UICollectionViewCell {
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = UIColor(displayP3Red: 242/255, green: 111/255, blue: 63/255, alpha: 1)
            }
            else {
                backgroundColor = UIColor(displayP3Red: 223/255, green: 234/255, blue: 248/255, alpha: 1)
            }
        }
    }
    @IBOutlet weak var majorLabel: UILabel!
}
