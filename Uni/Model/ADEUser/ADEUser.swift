//
//  ADEUser.swift
//  Uni
//
//  Created by nguyen gia huy on 02/12/2020.
//

import Foundation
import UIKit
class ADEUser{
    var email: String?
    var id: String?
    var role: String?
    var state: Bool?
    var name: String?
    var gender: String?
    var Class: String?
    var course: String?
    var faculty: String?

    
    init(email: String, id: String, role: String, state: Bool, name: String, gender: String, Class: String, course: String,faculty:String) {
        self.email = email
        self.id = id
        self.role = role
        self.state = state
        self.name = name
        self.gender = gender
        self.Class = Class
        self.course = course
        self.faculty = faculty
    }
    
    init() {
        
    }
}
