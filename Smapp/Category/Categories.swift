//
//  Categories.swift
//  Smapp
//
//  Created by 김성빈 on 2022/01/12.
//

import Foundation

struct Categories {
    var major: String
    var english: String
    var likeMajor: Bool = false
}

extension Categories {
    static var majors = [
        Categories(major: "글로벌리더쉽학부", english: "Global Leadership School"),
        Categories(major: "국제어문학부", english: "International Studies"),
        Categories(major: "경영경제학부", english: "Management & Economics"),
        Categories(major: "법학부", english: "School of Law"),
        Categories(major: "커뮤니케이션학부", english: "School of Communication Arts"),
        Categories(major: "공간시스템공학부", english: "Spatial Environment System Engineering"),
        Categories(major: "기계제어공학부", english: "Mechanical & Electrical Engineering"),
        Categories(major: "콘텐츠융합디자인하부", english: "Contents Convergence Design"),
        Categories(major: "생명과학부", english: "Life Sciences"),
        Categories(major: "전산전자공학부", english: "Computer Science & Electrical Engineering"),
        Categories(major: "상담심리학부", english: "Counselling Psychology & Socail Welfare"),
        Categories(major: "ICT창업학부", english: "Global Management & ICT"),
        Categories(major: "창의융합교육원", english: "School of Creative Convergence Education"),
        Categories(major: "AI융합교육원", english: "AI Convergence Education"),
    ]
}
