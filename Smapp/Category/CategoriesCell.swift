//
//  CategoriesListCell.swift
//  Smapp
//
//  Created by 김성빈 on 2022/01/12.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseDatabase

class CategoriesCell: UICollectionViewCell {
    
    var ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()

    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.backgroundColor = UIColor(displayP3Red: 223/255, green: 234/255, blue: 248/255, alpha: 1)
                
                //DB
                let refUser = ref.child("userList")
                
                refUser.child(String((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)).updateChildValues(["likeMajor": majorLabel.text!])
            }
            else {
                contentView.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            }
        }
    }
    
    @IBOutlet weak var majorLabel: UILabel!
}
