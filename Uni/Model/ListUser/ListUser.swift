//
//  ListUser.swift
//  Uni
//
//  Created by nguyen gia huy on 01/12/2020.
//

import Foundation
import UIKit
class ListUser {
    var code: String?
    var email: String?
    var uid: String?
    var role: String?
    var state: Bool?
    var name: String?
    var urlImage: String?
    
    init(code: String, email: String, uid: String, role: String, state:Bool, name: String, urlImage:String) {
        self.code = code
        self.email = email
        self.uid = uid
        self.role = role
        self.state = state
        self.name = name
        self.urlImage = urlImage
    }
    
    init() {
        
    }
}
