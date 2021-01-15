//
//  FavoriteEventPresenter.swift
//  Uni
//
//  Created nguyen gia huy on 10/01/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import UIKit
import Foundation
import FirebaseAuth
import FirebaseDatabase
import Firebase

// MARK: View -
protocol FavoriteEventViewProtocol: class {
    func fetchEventSuccess()
    func fetchEventFailed()
    func likeEventFailed()
    func likeEventSuccess()
}

// MARK: Presenter -
protocol FavoriteEventPresenterProtocol: class {
	var view: FavoriteEventViewProtocol? { get set }
    var listEvent: [Event?] {get set}
    func getInfoEventFavorite()
    func isLikeEvent(keyEvent: String, stateLike: Bool)
}

class FavoriteEventPresenter: FavoriteEventPresenterProtocol {

    weak var view: FavoriteEventViewProtocol?
    var ref = Database.database().reference()
    var databaseHandle = DatabaseHandle()
    var user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    var listEvent: [Event?] = []
    
    func getInfoEventFavorite() {
        listEvent.removeAll()
        ref.child("Event").observeSingleEvent(of: .value) { [self] (snapshot) in
            if(snapshot.exists()) {
                for keyEvent in snapshot.children.allObjects as! [DataSnapshot] {
                    let placeRef = self.ref.child("Event/\(keyEvent.key)")
                    placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
                        if snapshot.exists()
                        {
                            let dict = snapshot.value as! [String: Any]
                            let title = dict["Title"] as! String
                            let date = dict["Date"] as! String
                            let checkin = dict["Checkin"] as! String
                            let checkout = dict["Checkout"] as! String
                            let key = dict["Key"] as! String
                            let type = dict["Type"] as! String
                            let urrlImage = dict["ImagePortal"] as! String
                            let placeRef = self.ref.child("Event/\(keyEvent.key)/Like/\(user?.uid ?? "")")
                            placeRef.observeSingleEvent(of:.value, with: { snapshot in
                                if snapshot.exists()
                                {
                                    let dict = snapshot.value as! [String: Any]
                                    let like = dict["StateLike"] as! Bool
                                    let request = Event(title: title, key: key, date: date, checkout: checkout, checkin: checkin, type: type, urlImage: urrlImage, stateLike: like)
                                    if like {
                                        listEvent.append(request)
                                        view?.fetchEventSuccess()
                                    } else {
                                        view?.fetchEventFailed()
                                    }
                                }
                                else {
                                    view?.fetchEventFailed()
                                }
                                
                            })

                        }
                        else
                        {
                            view?.fetchEventFailed()
                        }
                    })
                    
                }
            } else {
                view?.fetchEventSuccess()
            }
        }
    }
    
    func isLikeEvent(keyEvent: String, stateLike: Bool) {
        let path = self.ref.child("Event/\(keyEvent)/Like/\(user?.uid ?? "")/").child("StateLike")
        path.setValue(stateLike) { [self]
            (error:Error?, ref:DatabaseReference) in
            if error != nil {
                view?.likeEventFailed()
            }
            else
            {
                view?.likeEventSuccess()
            }
        }
    }
}