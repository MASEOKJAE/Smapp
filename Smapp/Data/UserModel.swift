//
//  UserModel.swift
//  Smapp
//
//  Created by 최진아 on 2022/01/25.
//

import UIKit

@objcMembers
class UserModel: NSObject {
    var email : String?                 // 이메일
    var name : String?                  // 이름
    var likeMajor: String?              // 관심있는 전공
    var studentId: NSNumber?            // 학번
    var listOfPartRoom : [NSNumber]?    // 참가중인 방
    var listOfLikeRoom: [NSNumber]?       // 관심있는 방
}

