//
//  String+Extension.swift
//  Uni
//
//  Created by nguyen gia huy on 23/11/2020.
//

import Foundation
import UIKit
extension String {
    
    func toDateTime() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self) ?? Date()
    }
    
    func toDateDate() ->Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self) ?? Date()
    }
    
    func formatDateCreate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: date ?? Date())
    }
    
    func formatStringToDate() -> Date {
        let dateFormatter = DateFormatter()
        return dateFormatter.date(from: self) ?? Date()
    }

    var localized: String {
           guard let currentLanguages = UserDefaults.standard.string(forKey: "AppleLanguage"), let bundlePath = Bundle.main.path(forResource: currentLanguages, ofType: "lproj"), let bundle = Bundle(path: bundlePath) else {
               return NSLocalizedString(self, comment: "")
           }
           return NSLocalizedString(self, tableName: nil, bundle: bundle, comment: "")
       }
}
