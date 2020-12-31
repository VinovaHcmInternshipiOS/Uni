//
//  NotificationAdmin.swift
//  Uni
//
//  Created by nguyen gia huy on 30/12/2020.
//
import Foundation
import UIKit
class NotificationAdmin{
    var keyNotification:String?
    var title: String?
    var content: String?
    var date: String?
    var statistical: [Double]?
    var stateCell: Bool?

    
    init(keyNotification:String,title: String, content: String, date: String, statistical: [Double] ,stateCell: Bool) {
        self.keyNotification = keyNotification
        self.title = title
        self.content = content
        self.date = date
        self.statistical = statistical
        self.stateCell = stateCell
    }
    
    init() {
        
    }
}
