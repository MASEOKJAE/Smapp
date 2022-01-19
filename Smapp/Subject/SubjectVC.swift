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
    }
    
    @IBAction func LikeClicked(_ sender: UIButton) {
        if sender.tag == 0 {
           sender.setImage(UIImage(systemName: "heart"), for: .normal)
           sender.tag = 1
       }
       else{
           sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
           sender.tag = 0
       }
    }
}

extension SubjectVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.appDelegate.roomList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subjectCell", for: indexPath) as! SubjectCell
        
        let item = self.appDelegate.roomList[indexPath.item]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        cell.roomTitle?.text = item.title!
        cell.information?.text = item.subject! + " | " + item.professor! + " | ~" + formatter.string(from: item.dueDate!)
        cell.member?.text = "(" + String(item.numberOfPart!) + "/" + String(item.numberOfMax!) + ")"
        
        LikeClicked(cell.LikeButton)
        
        return cell
    }
}
