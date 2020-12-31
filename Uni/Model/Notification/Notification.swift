//
//  Notification.swift
//  Uni
//
//  Created by nguyen gia huy on 28/12/2020.
//

import Foundation
import UIKit
class NotificationUser{
    var keyNotification:String?
    var title: String?
    var content: String?
    var date: String?
    var state:Bool?

    
    init(keyNotification:String,title: String, content: String, date: String,state:Bool) {
        self.keyNotification = keyNotification
        self.title = title
        self.content = content
        self.date = date
        self.state = state
    }
    
    init() {
        
    }
}
