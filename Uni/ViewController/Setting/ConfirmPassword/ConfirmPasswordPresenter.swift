//
//  ConfirmPasswordPresenter.swift
//  Uni
//
//  Created nguyen gia huy on 03/12/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Firebase

// MARK: View -
protocol ConfirmPasswordViewProtocol: class {
    func confirmPasswordSuccess()
    func confirmPasswordFailed(error:Error)
}

// MARK: Presenter -
protocol ConfirmPasswordPresenterProtocol: class {
	var view: ConfirmPasswordViewProtocol? { get set }
    func confirmPassword(password:String)
}

class ConfirmPasswordPresenter: ConfirmPasswordPresenterProtocol {

    weak var view: ConfirmPasswordViewProtocol?
    var ref = Database.database().reference()
    var databaseHandle = DatabaseHandle()
    var user = Auth.auth().currentUser
    
    func confirmPassword(password:String) {
        if let email = user?.email {
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            user?.reauthenticate(with: credential, completion: { [self] (result, error) in
                     if error != nil {
                        view?.confirmPasswordFailed(error: error!)
                     }
                     else {
                        view?.confirmPasswordSuccess()
                     }
                 })
        } else {return}
    }
}
