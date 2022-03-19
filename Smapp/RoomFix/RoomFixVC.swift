//
//  RoomFixVC.swift
//  Smapp
//
//  Created by 마석재 on 2022/01/20.
//
import UIKit
import FirebaseDatabase

class RoomFixVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var TitleFix: UITextField!
    @IBOutlet weak var SubjectFix: UITextField!
    @IBOutlet weak var ProfessorFix: UITextField!
    @IBOutlet weak var ContentsFix: UITextField!
    @IBOutlet weak var MajorFix: UITextField!
    @IBOutlet weak var MajorFixDropdown: UIPickerView!
    @IBOutlet weak var MaxNumFix: UITextField!
    @IBOutlet weak var DueDateFix: UITextField!
    @IBOutlet weak var IsOnceFix: UISegmentedControl!
    
    
    
    var TitleText:String? // 기존 방제목을 받아오기 위한 변수
    var SubjectText:String?
    var ProfessorText:String?
    var ContentsText:String?
    var OpenDateText:String?
    var DueDateText:String?
    var MajorText:String?
    
    var IsClosedText:Bool?
    var IsOnceText:Bool?
    
    var RoomIdFix: Int? // 고치려는 roomId가 담겨 있음
    var MaxNumText:Int?
    var ListOfPartUserText:[Int] = []
    
    var ref: DatabaseReference!
    let datePicker = UIDatePicker()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let majorpicker = UIPickerView()
    
    @IBAction func FixCompleted(_ sender: UIButton) {
        let refRoom = ref.child("roomList")
        
        let fixData = [
            "major": self.MajorFix.text!,
            "title": self.TitleFix.text!,
            "subject": self.SubjectFix.text!,
            "professor": self.ProfessorFix.text!,
            "contents": self.ContentsFix.text!,
            "numberOfMax": Int(self.MaxNumFix.text!)!,
            "dueDate": self.DueDateFix.text!,
            "isOnce" : IsOnceFix.selectedSegmentIndex == 0 ? true : false,
        ] as [String : Any]
        
        refRoom.child("\(RoomIdFix!)").updateChildValues(fixData)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(MainTabBarController)
    }
    
    
    @IBOutlet var FixCompleted: UIButton!
    
    // 원하는 배경 설정
    
    func openLibrary(){
      picker.sourceType = .photoLibrary
      present(picker, animated: false, completion: nil)
    }
    func openCamera(){
      picker.sourceType = .camera
      present(picker, animated: false, completion: nil)
    }
    let picker = UIImagePickerController()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                    FixImageView.image = image
                    print(info)
                }

                dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var FixImageView: UIImageView!
    
    @IBAction func FixAddImage(_ sender: UIButton) {
         let alert = UIAlertController(title: "사진 추가", message: "원하는 배경 설정", preferredStyle: UIAlertController.Style.alert)
        
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }
        
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
        self.openCamera()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(library)
        
        alert.addAction(camera)
        
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database(url: "https://smapp-69029-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        
        picker.delegate = self
        
        // 기존 내용들을 가져옴
        if TitleText != nil {
            TitleFix.text = TitleText
        }
        if SubjectText != nil {
            SubjectFix.text = SubjectText
        }
        if ProfessorText != nil {
            ProfessorFix.text = ProfessorText
        }
        if ContentsText != nil {
            ContentsFix.text = ContentsText
        }
        if MajorText != nil {
            MajorFix.text = MajorText
        }
        if MaxNumText != nil {
            MaxNumFix.text = String(MaxNumText!)
        }
        if DueDateText != nil {
            DueDateFix.text = DueDateText
        }
        
        FixDatePicker()
        configPickerView()
    }
}

extension RoomFixVC {
    func FixDatePicker() {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor.blue
        toolbar.sizeToFit()
        
        let yesBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.yesPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let nolBT = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.noPicker))
        
        toolbar.setItems([nolBT,flexibleSpace,yesBT], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        
        DueDateFix.inputAccessoryView = toolbar
        DueDateFix.inputView = datePicker
    }
    
    @objc func yesPicker() {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy-MM-dd"
        
        DueDateFix.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func noPicker() {
        self.DueDateFix.text = nil
        self.DueDateFix.resignFirstResponder()
    }
}

extension RoomFixVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func configPickerView() {
        majorpicker.delegate = self
        majorpicker.dataSource = self
        MajorFix.inputView = majorpicker
        
        configToolbar()
    }
    
    func configToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.blue
        toolBar.sizeToFit()
        let doneBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.donePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBT = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelPicker))
        
        toolBar.setItems([cancelBT,flexibleSpace,doneBT], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        MajorFix.inputAccessoryView = toolBar
    }
    
    @objc func donePicker() {
        let row = self.majorpicker.selectedRow(inComponent: 0)
        self.majorpicker.selectRow(row, inComponent: 0, animated: false)
        self.MajorFix.text = self.appDelegate.majorList[row]
        self.MajorFix.resignFirstResponder()
    }
    
    @objc func cancelPicker() {
        self.MajorFix.text = nil
        self.MajorFix.resignFirstResponder()
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.appDelegate.majorList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.appDelegate.majorList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { self.MajorFix.text = self.appDelegate.majorList[row]
    }
}
