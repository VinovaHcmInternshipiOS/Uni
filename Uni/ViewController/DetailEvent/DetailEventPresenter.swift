//
//  DetailEventPresenter.swift
//  Uni
//
//  Created nguyen gia huy on 03/11/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Firebase
import FirebaseStorage
import UIKit
// MARK: View -
protocol DetailEventViewProtocol: class {
    func fetchDetailSuccess()
    func fetchDetailFailed()
    func fetchJoinerEventSuccess()
    func fetchJoinerEventFailed()
}

// MARK: Presenter -
protocol DetailEventPresenterProtocol: class {
	var view: DetailEventViewProtocol? { get set }
    var detailEvent: DetailEvent? {get set}
    var joinerEvent: Int? {get set}
    func getDetailEvent(keyEvent: String)
    func getJoinerEvent(keyEvent: String)
}

class DetailEventPresenter: DetailEventPresenterProtocol {

    weak var view: DetailEventViewProtocol?
    var ref = Database.database().reference()
    var databaseHandle = DatabaseHandle()
    var detailEvent: DetailEvent?
    var joinerEvent: Int?
    let storageRef = Storage.storage().reference()
    
    func getDetailEvent(keyEvent: String) {
        let placeRef = self.ref.child("Event/\(keyEvent)")
        placeRef.observe(.value, with: { [self] snapshot in
            if snapshot.exists()
            {
                let dict = snapshot.value as! [String: Any]
                let title = dict["Title"] as! String
                let content = dict["Overview"] as! String
                let address = dict["Location"] as! String
                let score = dict["Score"] as! Int
                
                let date = dict["Date"] as! String
                let checkin = dict["Checkin"] as! String
                let checkout = dict["Checkout"] as! String
                let urlImagePortal = dict["ImagePortal"] as! String
                let urlImageLandscape = dict["ImageLandscape"] as! String
                
                detailEvent = DetailEvent(title: title, content: content, address: address, score: score, date: date, checkin: checkin, checkout: checkout, urlImageLandscape:urlImageLandscape,urlImagePortal: urlImagePortal)

                view?.fetchDetailSuccess()
            }
            else
            {
                view?.fetchDetailFailed()
            }
        })
    }
    
    func getJoinerEvent(keyEvent: String) {
        //let placeRef = self.ref.child("Event/\(keyEvent)/Joiner")
        let placeRef = self.ref.child("Joiner/\(keyEvent)")
        placeRef.observe(.value, with: { [self] snapshot in
            if snapshot.exists()
            {
                joinerEvent = Int(snapshot.childrenCount)
                
                view?.fetchJoinerEventSuccess()
            }
            else
            {
                view?.fetchJoinerEventFailed()
            }
        })
    }
    

   
    

}
