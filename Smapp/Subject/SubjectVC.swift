//
//  SubjectVC.swift
//  Smapp
//
//  Created by 이예준 on 2022/01/14.
//

import UIKit

class SubjectVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        //collectionView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
        
        let n = self.appDelegate.subjectList.count
        print(n)
        if(n > 0) {
            print(self.appDelegate.subjectList[n-1].subject!)
            print(self.appDelegate.subjectList[n-1].contents!)
        }
    }
}

extension SubjectVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.appDelegate.subjectList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subjectCell", for: indexPath) as! SubjectCell
        
        let item = self.appDelegate.subjectList[indexPath.item]
        
        print(item.subject!)
        print(item.contents!)
        
        cell.subject?.text = item.subject!
        cell.contents?.text = item.contents!
        
        return cell
    }
}
