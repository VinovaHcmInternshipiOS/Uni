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
}

// MARK: Presenter -
protocol LoginPresenterProtocol: class {
	var view: LoginViewProtocol? { get set }
    func siginIn(email:String, password: String)
}

class LoginPresenter: LoginPresenterProtocol {

    
    weak var view: LoginViewProtocol?
    
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
    
}
