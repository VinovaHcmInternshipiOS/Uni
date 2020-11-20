//
//  ADEEvent.swift
//  Uni
//
//  Created by nguyen gia huy on 20/11/2020.
//

import Foundation
import UIKit
class ADEEvent{
    var urlImageLanscape: String?
    var urlImagePortal: String?
    var title: String?
    var overview: String?
    var location: String?
    var date: String?
    var checkin: String?
    var checkout: String?
    var score: Int?

    
    init(urlImageLanscape: String, urlImagePortal: String, title: String, overview: String, location: String, date: String, checkin: String, checkout: String,score:Int) {
        self.urlImageLanscape = urlImageLanscape
        self.urlImagePortal = urlImagePortal
        self.title = title
        self.overview = overview
        self.location = location
        self.date = date
        self.checkin = checkin
        self.checkout = checkout
        self.score = score
    }
    
    init() {
        
    }
}
