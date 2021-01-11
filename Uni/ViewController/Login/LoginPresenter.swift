//
//  LoginPresenter.swift
//  Uni
//
//  Created nguyen gia huy on 02/11/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import Firebase
import UIKit
// MARK: View -
protocol LoginViewProtocol: class {
    func loginSuccess(uid: String)
    func loginFailed(error: Error)
    func checkAuthSuccess(role:String,code:String)
    func checkAuthFailed()
    func checkStateUser()
    
}

// MARK: Presenter -
protocol LoginPresenterProtocol: class {
	var view: LoginViewProtocol? { get set }
    func siginIn(email:String, password: String)
    func checkAuth(uid: String,completion: @escaping(String)->Void)
    func checkSigned(uid:String,timeSignedIn:String)
    
}

class LoginPresenter: LoginPresenterProtocol {

    
    weak var view: LoginViewProtocol?
    var ref = Database.database().reference()
    var databaseHandle = DatabaseHandle()
    //let user = Auth.auth().currentUser
    
    func siginIn(email:String, password: String) {
        //if NetworkState.shared.isConnected {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
                guard self != nil else { return }
                if error != nil {
                    self?.view?.loginFailed(error: error!)
                }
                else
                {
                    if let user = Auth.auth().currentUser {
                        print("User loggin in with data: \(user.uid)")
                        self?.view?.loginSuccess(uid: user.uid)
                    } else {return}
                   
                    
                }
            }
       // } else {
        //    print("Not connected")
        //}
    }
    func checkSigned(uid:String,timeSignedIn:String){
        ref.child("Users/\(uid)/SignedIn").setValue(timeSignedIn) { []
            (error:Error?, ref:DatabaseReference) in
            if error != nil {
                
            }
            else
            {
        
            }
        }
    }
    
    func checkAuth(uid: String,completion: @escaping (String) -> Void) {
            let placeRef = self.ref.child("Users").child("\(uid)").child("Auth")
            placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
                if(snapshot.exists())
                {
                    let placeDict = snapshot.value as! [String: Any]
                    let role = placeDict["Role"] as! String
                    let state = placeDict["State"] as! Bool
                    let placeRef = self.ref.child("Users").child("\(uid)")
                    placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
                        if(snapshot.exists())
                        {
                            let placeDict = snapshot.value as! [String: Any]
                            let code = placeDict["Code"] as! String
                            
                            if (state == true) {
                                completion(role)
                                view?.checkAuthSuccess(role: role, code: code)
                            } else {
                                do { try Auth.auth().signOut()
                                } catch _ {}
                                view?.checkStateUser()
                            }
                        } else {
                            view?.checkAuthFailed()
                        }
                    })
                    
                    
                } else {
                    view?.checkAuthFailed()
                }
                
            })
        
    }
}
