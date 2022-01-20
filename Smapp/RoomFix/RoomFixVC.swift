//
//  RoomFixVC.swift
//  Smapp
//
//  Created by 마석재 on 2022/01/20.
//

import UIKit

class RoomFixVC: UIViewController {
    
    @IBOutlet weak var TitleFix: UITextField!
    @IBOutlet weak var ClassFix: UITextField!
    @IBOutlet weak var ProfessorFix: UITextField!
    @IBOutlet weak var ExplainFix: UITextField!
    
    var TitleText:String? // 기존 방제목을 받아오기 위한 변수
    var ClassText:String?
    var ProfessorText:String?
    var ExplainText:String?
    
    @IBAction func FixCompleted(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "RoomEnter", bundle: nil)
        let FixController = storyboard.instantiateViewController(identifier: "RoomEnter") as! RoomEnterVC
                    FixController.TitleOrigin = TitleFix.text // 수정된 방 제목 전달
                    FixController.ClassOrigin = ClassFix.text // 수정된 강의명 전달
                    FixController.ProfessorOrigin = ProfessorFix.text // 수정된 방 교수 전달
        FixController.ExplainOrigin = ExplainFix.text // 수정된 방 스터디 설명 전달
                    present(FixController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 기존 내용들을 가져옴
        if TitleText != nil {
            TitleFix.text = TitleText
        }
        if ClassText != nil {
            ClassFix.text = ClassText
        }
        if ProfessorText != nil {
            ProfessorFix.text = ProfessorText
        }
        if ExplainText != nil {
            ExplainFix.text = ExplainText
        }
        
    }
}
