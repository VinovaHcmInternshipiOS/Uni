//
//  DetailAccount.swift
//  Uni
//
//  Created by nguyen gia huy on 03/12/2020.
//

import Foundation
import UIKit
class DetailAccount{
    var created: String?
    var signedin: String?
    var state: Bool?
    var uid: String?
    var id: String?
    var email: String?
    var role: String?
   
    
    init(created: String, signedin: String, state: Bool, uid: String, id: String, email: String, role: String) {
        self.created = created
        self.signedin = signedin
        self.state = state
        self.uid = uid
        self.id = id
        self.email = email
        self.role = role
    }
    
    init() {
        
    }
}
