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
    
    func toDateTimeFormat(format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self) ?? Date()
    }
    
    func toTimeFormat(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: self)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date ?? Date())
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
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date ?? Date())
    }
    
    func formatStringToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.date(from: self) ?? Date()
    }
    
    func formatStringToDateTime24h() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return dateFormatter.date(from: self) ?? Date()
    }
    
    func formatterDateTime12h() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let date = dateFormatter.date(from: self)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mma"
        return dateFormatter.string(from: date ?? Date())
    }
    
    func formatterDateTime24h() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mma"
        let date = dateFormatter.date(from: self)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return dateFormatter.string(from: date ?? Date())
    }

    var localized: String {
           guard let currentLanguages = UserDefaults.standard.string(forKey: "AppleLanguage"), let bundlePath = Bundle.main.path(forResource: currentLanguages, ofType: "lproj"), let bundle = Bundle(path: bundlePath) else {
               return NSLocalizedString(self, comment: "")
           }
           return NSLocalizedString(self, tableName: nil, bundle: bundle, comment: "")
       }
}
