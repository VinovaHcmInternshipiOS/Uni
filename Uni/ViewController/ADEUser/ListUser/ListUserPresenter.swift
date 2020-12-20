//
//  ListUserPresenter.swift
//  Uni
//
//  Created nguyen gia huy on 01/12/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Firebase

// MARK: View -
protocol ListUserViewProtocol: class {
    func fetchUserSuccess()
    func fetchUserFailed()
    
    func fetchUserSearchSuccess()
    func fetchUserSearchFailed()
}

// MARK: Presenter -
protocol ListUserPresenterProtocol: class {
    var view: ListUserViewProtocol? { get set }
    var infoUsers: [ListUser?] {get set}
    func fetchListUser()
    func fetchUsersResult(keyUser: String)
}

class ListUserPresenter: ListUserPresenterProtocol {
    weak var view: ListUserViewProtocol?
    var ref = Database.database().reference()
    var databaseHandle = DatabaseHandle()
    var user = Auth.auth().currentUser
    var infoUsers: [ListUser?] = []
    
    func fetchListUser() {
        infoUsers.removeAll()
        ref.child("Users").observeSingleEvent(of:.value) { [self] (snapshot) in
            if(snapshot.exists()) {
                
                for keyUser in snapshot.children.allObjects as! [DataSnapshot] {
                    let placeRef = self.ref.child("Users/\(keyUser.key)")
                    placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
                        if snapshot.exists()
                        {
                            let dict = snapshot.value as! [String: Any]
                            let code = dict["Code"] as! String
                            let email = dict["Email"] as! String
                            let uid = dict["Uid"] as! String
                            
                            let placeRef = self.ref.child("Data/\(code)")
                            placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
                                if snapshot.exists()
                                {
                                    let dict = snapshot.value as! [String: Any]
                                    let name = dict["Name"] as! String
                                    let Image = dict["Image"] as! String

                                    let placeRef = self.ref.child("Users/\(keyUser.key)/Auth")
                                    placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
                                        if snapshot.exists()
                                        {
                                            let dict = snapshot.value as! [String: Any]
                                            let role = dict["Role"] as! String
                                            let state = dict["State"] as! Bool
                                            
                                            if role != "Admin" {
                                                infoUsers.append(ListUser(code: code, email: email, uid: uid, role: role, state: state, name: name,urlImage: Image))
                                                DispatchQueue.main.async {
                                                    view?.fetchUserSuccess()
                                                }
                                            }
                                            
                                            
                                        }
                                        else {
                                            view?.fetchUserFailed()
                                        }
                                    })
                                    
                                    
                                    
                                }
                                else {
                                    view?.fetchUserFailed()
                                }
                            })
                        }
                        else
                        {
                            view?.fetchUserFailed()
                        }
                    })
                }
                
                
            } else {
                view?.fetchUserFailed()
            }
        }
    }
    
    
    func fetchUsersResult(keyUser: String) {
        infoUsers.removeAll()
        self.ref.child("Users").queryOrdered(byChild: "Code").queryStarting(atValue: "\(keyUser)").queryEnding(atValue: "\(keyUser)" + "\u{f8ff}").observeSingleEvent(of:.value) { [self] snapshot in
            if (snapshot.exists()) {
                for keyUser in snapshot.children.allObjects as! [DataSnapshot] {
                    let placeRef = self.ref.child("Users/\(keyUser.key)")
                    placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
                        if snapshot.exists()
                        {
                            let dict = snapshot.value as! [String: Any]
                            let code = dict["Code"] as! String
                            let email = dict["Email"] as! String
                            let uid = dict["Uid"] as! String
                            
                            let placeRef = self.ref.child("Data/\(code)")
                            placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
                                if snapshot.exists()
                                {
                                    let dict = snapshot.value as! [String: Any]
                                    let name = dict["Name"] as! String
                                    let Image = dict["Image"] as! String

                                    let placeRef = self.ref.child("Users/\(keyUser.key)/Auth")
                                    placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
                                        if snapshot.exists()
                                        {
                                            let dict = snapshot.value as! [String: Any]
                                            let role = dict["Role"] as! String
                                            let state = dict["State"] as! Bool
                                            
                                            if role != "Admin" {
                                                infoUsers.append(ListUser(code: code, email: email, uid: uid, role: role, state: state, name: name,urlImage: Image))
                                                DispatchQueue.main.async {
                                                    view?.fetchUserSearchSuccess()
                                                }
                                            }
                                            
                                            
                                        }
                                        else {
                                            view?.fetchUserSearchFailed()
                                        }
                                    })
                                    
                                }
                                else {
                                    view?.fetchUserSearchFailed()
                                }
                            })
                        }
                        else
                        {
                            view?.fetchUserSearchFailed()
                        }
                    })
                }
            } else {
                view?.fetchUserSearchFailed()
            }
            
        }
    }
    
}
