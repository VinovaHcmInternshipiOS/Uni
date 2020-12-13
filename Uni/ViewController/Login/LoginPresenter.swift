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
    func loginSuccess()
    func loginFailed(error: Error)
    func checkAuthSuccess(role:String)
    func checkAuthFailed()
    func checkStateUser()
    
}

// MARK: Presenter -
protocol LoginPresenterProtocol: class {
	var view: LoginViewProtocol? { get set }
    func siginIn(email:String, password: String)
    func checkAuth(completion: @escaping(String)->Void)
    
}

class LoginPresenter: LoginPresenterProtocol {

    
    weak var view: LoginViewProtocol?
    var ref = Database.database().reference()
    var databaseHandle = DatabaseHandle()
    var user = Auth.auth().currentUser
    
    func siginIn(email:String, password: String) {
        //if NetworkState.shared.isConnected {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
                guard self != nil else { return }
                if error != nil {
                    self?.view?.loginFailed(error: error!)
                }
                else
                {
                    let user = Auth.auth().currentUser
                    print("User loggin in with data: \(user!.uid)")
                    self?.view?.loginSuccess()
                }
            }
       // } else {
        //    print("Not connected")
        //}
      
    }
    
    func checkAuth(completion: @escaping (String) -> Void) {
        if let user = user?.uid {
            let placeRef = self.ref.child("Users").child("\(user)").child("Auth")
            placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
                if(snapshot.exists())
                {
                    let placeDict = snapshot.value as! [String: Any]
                    let role = placeDict["Role"] as! String
                    let state = placeDict["State"] as! Bool
                    if (state == true) {
                        completion(role)
                        view?.checkAuthSuccess(role: role)
                    } else {
                        do { try Auth.auth().signOut()
                        } catch _ {}
                        view?.checkStateUser()
                    }
                    
                } else {
                    view?.checkAuthFailed()
                }
                
            })
        } else {return}
        
    }
}
