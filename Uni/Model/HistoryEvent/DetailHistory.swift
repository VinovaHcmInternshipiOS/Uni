//
//  DetailHistory.swift
//  Uni
//
//  Created by nguyen gia huy on 17/11/2020.
//

import Foundation
class DetailHistory {
    var title: String?
    var date: String?
    var checkin: String?
    var score: Int?
    var key: String?
    var urlImage: String?
    
    init(title: String, date: String,checkin:String,score: Int,key:String, urlImage: String) {
        self.title = title
        self.date = date
        self.checkin = checkin
        self.score = score
        self.key = key
        self.urlImage = urlImage
        
    }
}
