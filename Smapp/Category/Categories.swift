//
//  Categories.swift
//  Smapp
//
//  Created by 김성빈 on 2022/01/12.
//

import Foundation

struct Categories {
    var major: String
    var likeMajor = UserData().listOfLikeMajor
}

extension Categories {
    static var majors = [
        Categories(major: "글로벌리더쉽학부"),
        Categories(major: "국제어문학부"),
        Categories(major: "경영경제학부"),
        Categories(major: "법학부"),
        Categories(major: "커뮤니케이션학부"),
        Categories(major: "공간시스템공학부"),
        Categories(major: "기계제어공학부"),
        Categories(major: "콘텐츠융합디자인하부"),
        Categories(major: "생명과학부"),
        Categories(major: "전산전자공학부"),
        Categories(major: "상담심리학부"),
        Categories(major: "ICT창업학부"),
        Categories(major: "창의융합교육원"),
        Categories(major: "AI융합교육원"),
    ]
}
