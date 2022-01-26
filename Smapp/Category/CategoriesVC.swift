//
//  CategoriesCollectionVC.swift
//  Smapp
//
//  Created by 김성빈 on 2022/01/18.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseDatabase

class CategoriesVC: UIViewController {
    var ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func doneButtonAction(_ sender: Any) {
        let collectionView = self.collectionView
        //경고창
        guard collectionView?.indexPathsForSelectedItems != nil else {
            let alert = UIAlertController(title: nil, message: "전공을 선택해 주세요.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if let indexPath = collectionView?.indexPathsForSelectedItems?.first,
        let cell = collectionView?.cellForItem(at: indexPath) as? CategoriesCell,
        let majorData = cell.majorLabel.text {
            //DB
            let refUser = ref.child("userList")

            refUser.child(String((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)).updateChildValues(["likeMajor": majorData])
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = 5
    }
}

extension CategoriesVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return appDelegate.majorList.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCell", for: indexPath) as! CategoriesCell
        
        let item = appDelegate.majorList[indexPath.item]
        
        cell.majorLabel?.text = item
        cell.contentView.layer.masksToBounds = true
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        cell.layer.masksToBounds = false;
        cell.layer.shadowRadius = 2
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 10, height: 10)
        
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCell", for: indexPath as IndexPath) as! CategoriesCell
        
        cell.majorLabel.text = appDelegate.majorList[indexPath.item]
        
        return cell
    }
}
