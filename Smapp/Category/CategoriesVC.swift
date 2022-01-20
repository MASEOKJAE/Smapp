//
//  CategoriesCollectionVC.swift
//  Smapp
//
//  Created by 김성빈 on 2022/01/18.
//

import UIKit

class CategoriesVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
    }
}

extension CategoriesVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Categories.majors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCell", for: indexPath) as! CategoriesCell
        
        let item = Categories.majors[indexPath.item]
        
        //print(Categories.majors)
        
        cell.majorLabel?.text = item.major
        
        return cell
    }
}
