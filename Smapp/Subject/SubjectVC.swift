//
//  SubjectVC.swift
//  Smapp
//
//  Created by 이예준 on 2022/01/14.
//

import UIKit

class SubjectVC: UIViewController {
    
    @IBOutlet weak var nowMajor: UITextField!
    @IBOutlet weak var dropdown: UIPickerView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var willDisplayData = [RoomData]()
    
    @IBAction func search(_ sender: Any) {
        viewWillAppear(true)
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
    
    func updateData() {
        willDisplayData.removeAll()
        for item in self.appDelegate.roomList {
            if nowMajor.text! == item.major {
                willDisplayData.append(item)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        //collectionView.delegate = self
        
        updateData()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
        
        updateData()
    }
}

extension SubjectVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.willDisplayData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subjectCell", for: indexPath) as! SubjectCell
        
        let item = self.willDisplayData[indexPath.item]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        cell.roomTitle?.text = item.title!
        cell.information?.text = item.subject! + " | " + item.professor! + "교수님 | ~" + formatter.string(from: item.dueDate!)
        cell.member?.text = "(" + String(item.numberOfPart!) + "/" + String(item.numberOfMax!) + ")"
        
        LikeClicked(cell.LikeButton)
        
        return cell
    }
}

extension SubjectVC: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{

        return self.appDelegate.majorList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        self.view.endEditing(true)
        return self.appDelegate.majorList[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        self.nowMajor.text = self.appDelegate.majorList[row]
        self.dropdown.isHidden = true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.nowMajor {
            self.dropdown.isHidden = false

            textField.endEditing(true)
        }
    }
}
