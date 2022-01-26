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
                contentView.backgroundColor = UIColor(displayP3Red: 223/255, green: 234/255, blue: 248/255, alpha: 1)
            }
            else {
                contentView.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            }
        }
    }
    
    @IBOutlet weak var majorLabel: UILabel!
}
