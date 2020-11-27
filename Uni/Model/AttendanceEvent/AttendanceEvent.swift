//
//  AttendanceEvent.swift
//  Uni
//
//  Created by nguyen gia huy on 24/11/2020.
//

import Foundation
class AttendanceEvent{
    var code: String?
    var name: String?
    var checkin: String?
    var date: String?
    var urlImage: String?
    
    init(code: String, name: String, checkin: String, date: String, urlImage: String) {
        self.code = code
        self.name = name
        self.checkin = checkin
        self.date = date
        self.urlImage = urlImage
    }
    
    init() {
        
    }
}
