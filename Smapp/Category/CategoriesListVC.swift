//
//  CategoriesListViewController.swift
//  Smapp
//
//  Created by 김성빈 on 2022/01/12.
//

import UIKit

class CategoriesListVC: UITableViewController {
    @IBOutlet weak var subjectView: UITableView!
    //var listOfLikeMajor: [String] = []
    var listOfLikeMajor: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectView.dataSource = self
        subjectView.delegate = self
        listOfLikeMajor = Array<Int>(repeating: 0, count: Categories.majors.count) //String
    }
}


extension CategoriesListVC/*: UITableViewDataSource*/ {
    static let categoriesListCellIdentifier = "CategoriesListCell"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Categories.majors.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.categoriesListCellIdentifier, for: indexPath) as? CategoriesListCell else {
            fatalError("Unable to dequeue CategoriesCell")
        }
        let categories = Categories.majors[indexPath.row]
        cell.majorLabel.text = categories.major
        cell.englishLabel.text = categories.english
        /*cell.likeButtonAction = {
            Categories.majors[indexPath.row].likeMajor.toggle()
            ...
        }*/
        
        /*if indexPath.row == 1 {
            cell.isTouched = true
        } else {
            cell.isTouched = false
        }*/
        
        return cell
    }
    
    func didPressHeart(for index: Int, like: Bool) {
        if like == true{
            listOfLikeMajor[index] = 1
        }else{
            listOfLikeMajor[index] = 0
        }
    }
}
