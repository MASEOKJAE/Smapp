//
//  CategoriesCollectionVC.swift
//  Smapp
//
//  Created by 김성빈 on 2022/01/18.
//

import UIKit

class CategoriesVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func doneButtonAction(_ sender: Any) {
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
        
        
        //print(Categories.majors)
        let item = appDelegate.majorList[indexPath.item]

        
        cell.majorLabel?.text = item
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        
        return cell
    }
}
