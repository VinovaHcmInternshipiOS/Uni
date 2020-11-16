//
//  Event.swift
//  Uni
//
//  Created by nguyen gia huy on 13/11/2020.
//

import Foundation
import UIKit
class Event {
    var checkin: String?
    var checkout: String?
    var date: String?
    var key: String
    var type: String
    var title: String
    var urlImage: String?
    
    init(title: String,key: String, date:String,checkout:String, checkin:String, type: String, urlImage: String) {
        self.title = title
        self.key = key
        self.date = date
        self.checkout = checkout
        self.checkin = checkin
        self.type = type
        self.urlImage = urlImage
    }
    

    
}
    extension Date {
       func getFormattedDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateTime = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: dateTime!)
      }
    }
//extension Date {
//  func postDetailPresenter() -> String {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "d"
//    let day = formatter.string(from: self)
//    let daySuffix = self.daySuffix()
//    formatter.dateFormat = "MMMM"
//    let month = formatter.string(from: self)
//    return "\(day)\(daySuffix) \(month)"
//  }
//  func daySuffix() -> String {
//    let calendar = Calendar.current
//    let dayOfMonth = (calendar as NSCalendar).component(.day, from: self)
//    switch dayOfMonth {
//    case 1: fallthrough
//    case 21: fallthrough
//    case 31: return "st"
//    case 2: fallthrough
//    case 22: return "nd"
//    case 3: fallthrough
//    case 23: return "rd"
//    default: return "th"
//    }
//  }
//  func toString() -> String {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "MMM dd"
//    return formatter.string(from: self)
//  }
//  func toStringDayMonth() -> String {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "MMMM dd"
//    return formatter.string(from: self)
//  }
//  func toLocalTime() -> Date {
//    let timezone: TimeZone = TimeZone.autoupdatingCurrent
//    let seconds: TimeInterval = TimeInterval(timezone.secondsFromGMT(for: self))
//    return Date(timeInterval: seconds, since: self)
//  }
//  func dateISO8601() -> String {
//    let dateFormatter = DateFormatter()
//    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//    dateFormatter.timeZone = TimeZone.autoupdatingCurrent
//    dateFormatter.dateFormat = "yyyy-MM-dd’T’HH:mm:ssZZZZZ"
//    return dateFormatter.string(from: self)
//  }
//  func toStringDayMonthYear() -> String {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "EEE, dd MMM yyyy"
//    return formatter.string(from: self)
//  }
//  func toDayString() -> String {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "EEE, dd MMM"
//    return formatter.string(from: self)
//  }
//  func toDayPostedString() -> String {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "dd, MMM yyyy"
//    return formatter.string(from: self)
//  }
//  func toStringDate(format: String) -> String {
//      let formatter = DateFormatter()
//      formatter.dateFormat = format
//      return formatter.string(from: self)
//  }
//  func toTimeString() -> String {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "h:mm a"
//    return formatter.string(from: self)
//  }
//  func dateToString() -> String {
//      let formatter = DateFormatter()
//      formatter.dateFormat = "yyyy-MM-dd"
//      return formatter.string(from: self)
//  }
//  func toNewDateISO8601() -> String {
//    let dateFormatter = DateFormatter()
//    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//    dateFormatter.timeZone = TimeZone.autoupdatingCurrent
//    dateFormatter.dateFormat = "dd MMM yyy, h:mm a"
//    return dateFormatter.string(from: self)
//  }
//}

