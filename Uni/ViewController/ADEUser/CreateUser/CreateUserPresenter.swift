//
//  CreateUserPresenter.swift
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
import FirebaseStorage

// MARK: View -
protocol CreateUserViewProtocol: class {
    func createAccountSuccess(code:String)
    func createAccoutnFailed(error:Error)
    func createInformationSuccess()
    func createInformationFailed()
    func checkExistEmailSuccess()
    func checkExistEmailFailed()
    func checkExistIDSuccess()
    func checkExistIDFailed()
    func errorCreateAccount(error:Error)
}

// MARK: Presenter -
protocol CreateUserPresenterProtocol: class {
    var view: CreateUserViewProtocol? { get set }
    var detailUser: ADEUser? { get set}
    func createAccount(email:String,id:String,role:String,state:Bool,created:String)
    func createInformation(code:String,name:String,gender:String,Class:String,course:String,faculty:String)
    func checkExistEmail(email:String)
    func checkExistID(code:String)
    
}

class CreateUserPresenter: CreateUserPresenterProtocol {

    
    weak var view: CreateUserViewProtocol?
    var ref = Database.database().reference()
    var databaseHandle = DatabaseHandle()
    var user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    var detailUser: ADEUser?
    
    func checkExistEmail(email: String) {
        Auth.auth().fetchSignInMethods(forEmail: email, completion: { [self] (signInMethods, error) in
            if signInMethods != nil {
                view?.checkExistEmailSuccess()
            } else {
                view?.checkExistEmailFailed()
            }
        })
    }
    
    func checkExistID(code: String) {
        ref.child("Users").queryOrdered(byChild: "Code").queryEqual(toValue: "\(code)").observeSingleEvent(of: .value) { [self] (snapshot) in
            if snapshot.exists() {
                view?.checkExistIDSuccess()
            } else {
                view?.checkExistIDFailed()
            }
        }
    }
    
    func createAccount(email:String,id:String,role:String,state:Bool,created:String) {
        Auth.auth().createUser(withEmail: email, password: "\(email.hashValue)") { [self] UserInfo, error in
            
            if(error != nil)
            {
                
                view?.errorCreateAccount(error: error!)
                
            }
            else
            {
                if let getUID = UserInfo {
                    let contenttitleNoti = ["Users/\(getUID.user.uid)/Email":"\(email)","Users/\(getUID.user.uid)/Uid":"\(getUID.user.uid)","Users/\(getUID.user.uid)/Code":"\(id)","Users/\(getUID.user.uid)/Auth/Role":"\(role)","Users/\(getUID.user.uid)/Auth/State":state,"Users/\(getUID.user.uid)/Created":created,"Users/\(getUID.user.uid)/SignedIn":"nil"] as [String : Any]
                    self.ref.updateChildValues(contenttitleNoti as [AnyHashable : Any]){ [self](error, ref) in
                        if(error != nil){
                            view?.createAccoutnFailed(error: error!)
                        }
                        else {
                            view?.createAccountSuccess(code:id)
                            Auth.auth().sendPasswordReset(withEmail: email)
                        }
                        
                    }
                } else {return}
            }
        }
    }
    
    func createInformation(code:String,name:String,gender:String,Class:String,course:String,faculty:String) {
        ref.child("Data\(code)").observeSingleEvent(of:.value) { [self] (snapshot) in
            if snapshot.exists() {
                view?.checkExistIDSuccess()
            } else {
                let path = ref.child("Data/\(code)")
                let sentValue = ["Code":"\(code)","Name":"\(name)","Gender":"\(gender)","Class":"\(Class)","Course":"\(course)","Faculty":"\(faculty)","Image":"","Score":0] as [String : Any]
                path.setValue(sentValue) { [self]
                    (error:Error?, ref:DatabaseReference) in
                    if error != nil {
                        view?.createInformationFailed()
                    }
                    else
                    {
                        view?.createInformationSuccess()
                    }
                }
            }
        }
    }
}
