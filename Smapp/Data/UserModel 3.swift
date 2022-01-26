//
//  UserModel.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/25.
//

import UIKit

class UserModel: NSObject {
    var userId : Int?                   // 번호
    var email : String?                 // 이메일
    var studentId : Int?                // 학번
    var name : String?                  // 이름
    var likeMajor : String?             // 관심있는 전공
    var listOfPartRoom : [Int]?         // 참가중인 방
    var listOfLikeRoom : [Int]?         // 관심있는 방
}
