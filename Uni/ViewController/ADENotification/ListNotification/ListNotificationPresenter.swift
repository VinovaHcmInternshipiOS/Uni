//
//  ListNotificationPresenter.swift
//  Uni
//
//  Created nguyen gia huy on 27/12/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import UIKit
import Foundation
import FirebaseMessaging
import UserNotifications
import FirebaseAuth
import FirebaseDatabase
import Firebase

// MARK: View -
protocol ListNotificationViewProtocol: class {
    func fetchNotificationSuccess()
    func fetchNotificationFailed()
    func removeNotificationSuccess()
    func removeNotificationFailed()
}

// MARK: Presenter -
protocol ListNotificationPresenterProtocol: class {
    var view: ListNotificationViewProtocol? { get set }
    var infoNotification: [NotificationAdmin?] {get set}
    var statistical: [String?] {get set}
    func fetchNotification()
    func countUser()
    func removeNotification(keyNotification: String)
    func deleteNotiAfter7day(dateCurrent:Date,isClockFormat12h:Bool)
}

class ListNotificationPresenter: ListNotificationPresenterProtocol {
    
    weak var view: ListNotificationViewProtocol?
    var ref = Database.database().reference()
    var databaseHandle = DatabaseHandle()
    var infoNotification: [NotificationAdmin?] = []
    var statistical: [String?] = []
    
    func fetchNotification() {
        infoNotification.removeAll()
        ref.child("Notification").observeSingleEvent(of:.value) { [self] (snapshot) in
            if(snapshot.exists()) {
                for keyEvent in snapshot.children.allObjects as! [DataSnapshot] {
                    let placeRef = self.ref.child("Notification/\(keyEvent.key)")
                    placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
                        if snapshot.exists()
                        {
                            let dict = snapshot.value as! [String: Any]
                            let title = dict["Title"] as! String
                            let content = dict["Content"] as! String
                            let date = dict["Date"] as! String
                            
                            ref.child("Notification/\(keyEvent.key)/List").observeSingleEvent(of:.value) { [self] (snapshotNotification) in
                                snapshotNotification.exists() == true ? infoNotification.insert(NotificationAdmin(keyNotification: keyEvent.key,title: title, content: content, date: date,statistical: [Double(snapshotNotification.childrenCount),Double(statistical.count)] ,stateCell: false), at: 0) : infoNotification.insert(NotificationAdmin(keyNotification: keyEvent.key,title: title, content: content, date: date,statistical: [0,Double(statistical.count)] ,stateCell: false), at: 0)
                                view?.fetchNotificationSuccess()
                            }
                            
                        }
                        else
                        {
                            view?.fetchNotificationFailed()
                        }
                    })
                    
                }
            } else {
                view?.fetchNotificationFailed()
            }
        }
    }
    
    func countUser() {
        ref.child("Users").observeSingleEvent(of:.value) { [self] (snapshotUser) in
            if snapshotUser.exists() {
                for keyUser in snapshotUser.children.allObjects as! [DataSnapshot] {
                    statistical.append(keyUser.key)
                }
            }
        }
    }
    
    func deleteNotiAfter7day(dateCurrent:Date,isClockFormat12h:Bool) {
        ref.child("Notification").observeSingleEvent(of:.value) { [self] (snapshot) in
            if(snapshot.exists()) {
                for keyNotification in snapshot.children.allObjects as! [DataSnapshot] {
                    let placeRef = self.ref.child("Notification/\(keyNotification.key)")
                    placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
                        if snapshot.exists()
                        {
                            let dict = snapshot.value as! [String: Any]
                            let date = dict["Date"] as! String
                            let calendar = Calendar.current
                            let componentsTime = calendar.dateComponents([.day,.month,.year,.hour,.minute,.second], from: isClockFormat12h == true ? ((date.formatterDateTime12h()).toDateTimeFormat(format: "dd-MM-yyyy hh:mma")) : ((date.formatterDateTime24h()).toDateTimeFormat(format: "dd-MM-yyyy HH:mm")), to: dateCurrent)
                            if componentsTime.day ?? 0 > 7 {
                                removeNotification(keyNotification: keyNotification.key)
                            } else {
                                view?.removeNotificationSuccess()
                            }
                            
                        }
                    })
                    
                }
            }
        }
    }
    
    
    func removeNotification(keyNotification: String) {
        let placeRef = self.ref.child("Notification/\(keyNotification)")
        placeRef.observeSingleEvent(of:.value, with: { [] snapshot in
            if snapshot.exists()
            {
                placeRef.removeValue { [self] (error, snapshot) in
                    if error != nil {
                        view?.removeNotificationFailed()
                    } else {
                        view?.removeNotificationSuccess()
                        
                    }
                }
            }
        })
        
    }
    
    
}
