//
//  NotificationModel.swift
//  Smapp
//
//  Created by 이예준 on 2022/02/09.
//

import ObjectMapper

class NotificationModel : Mappable {
    public var to : String?
    public var notification : Notification = Notification()
    
    init() {
        
    }
    
    required init? (map : Map) {
        
    }
    
    func mapping(map : Map) {
        to <- map["to"]
        notification <- map["notification"]
    }
    
    class Notification : Mappable{
        public var title : String?
        public var body : String?
        
        init() {
            
        }
        
        required init?(map : Map) {
            
        }
        
        func mapping(map : Map) {
            title <- map["title"]
            body <- map["body"]
        }
    }
}
