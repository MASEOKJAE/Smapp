//
//  RoomData.swift
//  Smapp
//
//  Created by 이예준 on 2022/01/17.
//

import Foundation
import UIKit

class RoomData {
    var roomId : Int?               // 번호
    var major : String?             // 전공
    var subject : String?           // 과목명
    var professor : String?         // 교수님
    var title : String?             // 방 제목
    var contents : String?          // 내용(설명)
    var numberOfMax : Int?          // 최대 참가 가능한 인원 수
    var openDate : String?            // 방 생성 날짜
    var dueDate : String?             // 방 마감 날짜
    var isOnce : Bool?              // 일시 / 정기 여부(True면 일시)
    var isClosed : Bool?            // 방 마감 여부(True면 더 이상 참가 불가)
    var listOfPartUser : [Int]?     // 참여자 명단
    
    init(dic: Dictionary<String, Any>) {
        self.roomId = dic["roomId"] as? Int ?? -1
        self.major = dic["major"] as? String ?? "Error"
        self.subject = dic["subject"] as? String ?? "Error"
        self.professor = dic["professor"] as? String ?? "Error"
        self.title = dic["title"] as? String ?? "Error"
        self.contents = dic["contents"] as? String ?? "Error"
        self.numberOfMax = dic["numberOfMax"] as? Int ?? -1
        self.openDate = dic["openDate"] as? String ?? "1900-01-01"
        self.dueDate = dic["dueDate"] as? String ?? "1900-01-01"
        self.isOnce = dic["isOnce"] as? Bool ?? false
        self.isClosed = dic["isClosed"] as? Bool ?? false
        self.listOfPartUser = dic["listOfPartUser"] as? Array ?? []
    }
}
