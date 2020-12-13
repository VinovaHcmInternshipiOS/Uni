//
//  PushNotificationSender.swift
//  Uni
//
//  Created by nguyen gia huy on 11/12/2020.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["condition": "'notify' in topics",
                                           "priority" : "high",
                                           "notification" : [
                                             "body" : body,
                                             "title" : title,
                                             "sound" : "default"
                                           ]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAxuJXQMs:APA91bF_VSOeNqbz_iLMl67NgIdS9RyJGFnQ6pSeUKOiYG3YyykhnRklJxmXcDt1LltHrc96jXLexb1uOkk3p4y4LggCs8LAXlzMUCKjtcSn42ccNXgZ6S7vTY8PJAKGUYQNk1rTRuUL", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
