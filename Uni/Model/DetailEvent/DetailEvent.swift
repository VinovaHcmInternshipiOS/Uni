//
//  DetailEvent.swift
//  Uni
//
//  Created by nguyen gia huy on 16/11/2020.
//

import Foundation
import UIKit
class DetailEvent {
    
    var title: String?
    var content: String?
    var address: String?
    var score:Int?
    var date: String?
    var checkin: String?
    var checkout: String?
    var urlImageLandscape: String?
    var urlImagePortal: String?
    
    init(title: String,content: String, address:String,score: Int,date: String,checkin:String,checkout: String, urlImageLandscape: String,urlImagePortal: String) {
        self.title = title
        self.content = content
        self.address = address
        self.score = score
        self.date = date
        self.checkout = checkout
        self.checkin = checkin
        self.urlImageLandscape = urlImageLandscape
        self.urlImagePortal = urlImagePortal
    }
    

    
}
