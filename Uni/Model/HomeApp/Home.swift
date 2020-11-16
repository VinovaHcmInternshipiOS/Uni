//
//  Home.swift
//  Uni
//
//  Created by nguyen gia huy on 13/11/2020.
//

import Foundation
import UIKit
class Home {
    var code: String?
    var name: String?
    var faculty: String?
    var urlImage: String?
    
    init(code: String, name: String, faculty: String, urlImage: String) {
        self.code = code
        self.name = name
        self.faculty = faculty
        self.urlImage = urlImage
    }
    
    init() {
        
    }
}
