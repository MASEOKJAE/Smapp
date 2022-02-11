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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add width constraint if you want dynamic height
        contentView.translatesAutoresizingMaskIntoConstraints = true
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width/2 - 35).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func viewDidLoad() {
        majorLabel.adjustsFontSizeToFitWidth = true
        majorLabel.textAlignment = .center
        majorLabel.sizeToFit()
    }
}
