//
//  Profile.swift
//  Uni
//
//  Created by nguyen gia huy on 19/11/2020.
//

import Foundation
import UIKit
class Profile{
    var code: String?
    var name: String?
    var email: String?
    var gender: String?
    var classs: String?
    var course: String?
    var faculty: String?
    var urlImage: String?
    
    init(code: String, name: String, email: String, gender: String, classs: String, course: String, faculty: String, urlImage: String) {
        self.code = code
        self.name = name
        self.email = email
        self.gender = gender
        self.classs = classs
        self.course = course
        self.faculty = faculty
        self.urlImage = urlImage
    }
    
    init() {
        
    }
}
