//
//  RankEvent.swift
//  Uni
//
//  Created by nguyen gia huy on 18/11/2020.
//

import Foundation
class RankEvent {
    var name: String?
    var score: Int?
    var imgURL: String?
    
    init(name: String, score: Int, imgURL: String) {
        self.name = name
        self.score = score
        self.imgURL = imgURL
        
    }
}
