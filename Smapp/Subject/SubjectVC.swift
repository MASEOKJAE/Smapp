//
//  SubjectVC.swift
//  Smapp
//
//  Created by 이예준 on 2022/01/14.
//
import UIKit
import GoogleSignIn
import Firebase
import FirebaseDatabase

class SubjectVC: UIViewController {
    var ref: DatabaseReference!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var nowMajor: UITextField!
    @IBOutlet weak var dropdown: UIPickerView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var makeRoom: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var search: UIButton!
    
    var willDisplayData = [RoomData]()
    
    @IBAction func searchButton(_ sender: Any) {
        viewWillAppear(true)
    }
    
    
    func updateData() {
        willDisplayData.removeAll()
        
        let roomListRef = ref.child("roomList")
        
        roomListRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let values = snapshot.value!
            let dic = values as? [Any] ?? []
            for item in dic {
                let i = item as? Dictionary<String, Any> ?? [:]
                if (self.nowMajor.text! == i["major"] as? String) {
                    if(self.searchBar.text! == "" || (i["subject"] as! String).contains(self.searchBar.text!) || (i["title"] as! String).contains(self.searchBar.text!) || (i["contents"] as! String).contains(self.searchBar.text!) || (i["professor"] as! String).contains(self.searchBar.text!)) {
                        self.willDisplayData.append(RoomData(dic: i))
                    }
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
    
    
    override func viewDidLoad() {
        ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        
        super.viewDidLoad()
        
        
        let userListRef = ref.child("userList")
        
        userListRef.child(String((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)).getData(completion: {error, snapshot in
            let value = snapshot.value as? NSDictionary
            
            self.nowMajor.text = value?["likeMajor"] as? String ?? "Error"
        })
        
        collectionView.dataSource = self
        //collectionView.delegate = self
        
        search.layer.masksToBounds = true
        search.layer.cornerRadius = 10
        
        makeRoom.layer.masksToBounds = true
        makeRoom.layer.cornerRadius = 40
        
        self.view.bringSubviewToFront(dropdown)
        self.view.bringSubviewToFront(makeRoom)
        
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }
}


extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
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
        
        cell.roomId = item.roomId
        cell.roomTitle?.text = item.title!
        cell.information?.text = item.subject! + " | " + item.professor! + " | " + (item.isOnce! ? "" : "~") + formatter.string(from: formatter.date(from: item.dueDate!)!) + " | " + (item.isOnce! ? "번개" : "정기")
        cell.member?.text = "(" + String(item.listOfPartUser?.count ?? -1) + "/" + String(item.numberOfMax!) + ")"
    
        //db읽고 listOfLikeRoom에 포함되어있으면 하트 채워주기
        ref.child("userList").child(String((GIDSignIn.sharedInstance.currentUser?.profile!.email.prefix(8))!)).getData(completion: {error, snapshot in
            let value = snapshot.value as? NSDictionary
            let likeRooms = value?["listOfLikeRoom"] as? NSMutableArray ?? []
                        
            if likeRooms.contains(cell.roomId!) {
                cell.LikeImage.image = UIImage(named: "heart.fill")
            } else {
                cell.LikeImage.image = UIImage(named: "heart")
            }
        })
        
        return cell
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subjectCell", for: indexPath as IndexPath) as! SubjectCell
        
        return cell
    }
    
    // 각 Cell의 방 정보 인덱스를 RoomEnter로 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            if segue.identifier == "RoomEnter" {
                let vc = segue.destination as? RoomEnterVC
                let cell = sender as! SubjectCell
                let indexPath = collectionView.indexPath(for: cell)
                let selectedData = indexPath?.row
                // vc?.SaveOrder = Int(selectedData!) // DB에 저장된 내용 순서대로 데이터를 가져 옴
                vc?.EnterIndex = cell.roomId // 클릭한 룸 아이디 데이터를 가져 옴
            }
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

