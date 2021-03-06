//
//  UpdateEventPresenter.swift
//  Uni
//
//  Created nguyen gia huy on 24/11/2020.
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
protocol UpdateEventViewProtocol: class {
    func fetchDetailSuccess()
    func fetchDetailFailed()
    func updateEventSuccess(keyEvent:String)
    func updateEventFailed()
    func uploadImageLandscapeSuccess(keyRef:String)
    func uploadImagePortalSuccess(keyRef:String)
    func uploadImageLandscapeFailed()
    func uploadImagePortalFailed()
    func updateImageEventSuccess()
    func updateImageEventFailed()
}

// MARK: Presenter -
protocol UpdateEventPresenterProtocol: class {
    var view: UpdateEventViewProtocol? { get set }
    var detailEvent: DetailEvent? {get set}
    var keyEvent: String {get set}
    var dateEvent: String? {get set}
    var checkinEvent: String? {get set}
    var checkoutEvent: String? {get set}
    func getDetailEvent()
    func updateEvent(urlImgLanscape: String,urlImgPortal:String,title:String,overview:String,location:String,date:String,checkin:String,checkout:String,score:Int)
    func uploadImage(image: UIImage,type:typeImage)
    func updateImageEvent(keyRef:String,type:typeImage)
    func updateScoreUser(score: Int)
    func sendPushNotification(keyEvent:String)
}

class UpdateEventPresenter: UpdateEventPresenterProtocol {
    var keyEvent: String
    weak var view: UpdateEventViewProtocol?
    var ref = Database.database().reference()
    var databaseHandle = DatabaseHandle()
    var detailEvent: DetailEvent?
    let storageRef = Storage.storage().reference()
    var checkinEvent: String?
    var checkoutEvent: String?
    var dateEvent: String?
    
    init(keyEvent: String) {
        self.keyEvent = keyEvent
    }
    
    func sendPushNotification(keyEvent:String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["condition": "'notify' in topics",
                                           "priority" : "high",
                                           "notification" : [
                                            "body" : "\(AppLanguage.UpdateEvent.havejustUpdate.localized) \(detailEvent?.title ?? "") \(AppLanguage.UpdateEvent.letCheck.localized)",
                                            "title" : AppLanguage.UpdateEvent.editEvent.localized,
                                           ],
                                           "data" :[
                                            "keyEvent": keyEvent
                                         ]
                                           
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(AppKey.keyPushNotification, forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  {  (data, response, error) in
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
    
    func getDetailEvent() {
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
                
                detailEvent = DetailEvent(title: title, content: content, address: address, score: score, date: date, checkin: checkin, checkout: checkout, urlImageLandscape:urlImageLandscape,urlImagePortal: urlImagePortal, stateLike: false)
                dateEvent = date
                checkinEvent = checkin
                checkoutEvent = checkout
                view?.fetchDetailSuccess()
            }
            else
            {
                view?.fetchDetailFailed()
            }
        })
    }
    
    func updateEvent(urlImgLanscape: String, urlImgPortal: String, title: String, overview: String, location: String, date: String, checkin: String, checkout: String, score: Int) {
        let path = self.ref.child("Event/\(keyEvent)")
        let sentValue = ["ImageLandscape":"\(urlImgLanscape)","ImagePortal":"\(urlImgPortal)","Title":"\(title)","Overview":"\(overview)","Location":"\(location)","Date":"\(date)","Checkin":"\(checkin)","Checkout":"\(checkout)","Score":score,"Key":keyEvent,"Type":"ComingSoon"] as [String : Any]
        path.setValue(sentValue) { [self]
            (error:Error?, ref:DatabaseReference) in
            if error != nil {
                view?.updateEventFailed()
            }
            else
            {   
                view?.updateEventSuccess(keyEvent: keyEvent)
                updateScoreUser(score: score)
            }
        }
    }
    func updateScoreUser(score: Int) {
        ref.child("Data").observeSingleEvent(of: .value) { [self] (snapshot) in
            if(snapshot.exists()) {
                for keyUser in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let placeRef = ref.child("Data/\(keyUser.key)")
                    placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
                        if snapshot.exists()
                        {
                            let dict = snapshot.value as! [String: Any]
                            let scoreUser = dict["Score"] as? Int ?? 0
                            
                            
                            let placeRef = self.ref.child("Data/\(keyUser.key)/List/\(keyEvent)")
                            placeRef.observeSingleEvent(of:.value, with: { [] snapshot in
                                if snapshot.exists()
                                {
                                    
                                    let dict = snapshot.value as! [String: Any]
                                    let scoreEvent = dict["Score"] as? Int ?? 0
                                    
                                    ref.child("Data/\(keyUser.key)/List/\(keyEvent)/Score").setValue(score) { []
                                        (error:Error?, ref:DatabaseReference) in
                                        if error != nil {
                                            
                                        }
                                        else
                                        {
                                            self.ref.child("Data/\(keyUser.key)/Score").setValue(scoreUser - scoreEvent + score) { []
                                                (error:Error?, ref:DatabaseReference) in
                                                if error != nil {
                                                    
                                                }
                                                else
                                                {
                                                    
                                                }
                                            }
                                        }
                                    }
                                    
                                    
                                    
                                }
                                else
                                {
                                    
                                }
                            })
                            
                        } else {
                            
                        }
                    })
                    
                    
                    
                }
            }
        }
        
    }
    func uploadImage(image:UIImage,type:typeImage) {
        let storedImage = storageRef.child("Event/\(keyEvent)/\(image.hashValue)")
        if let uploadData = image.jpegData(compressionQuality: 1)
        {
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            storedImage.putData(uploadData, metadata: metaData, completion: { [self]  (metadata, error) in
                if error != nil {
                    switch type {
                    case .Landscape:
                        view?.uploadImageLandscapeFailed()
                    case .Portal:
                        view?.uploadImagePortalFailed()
                        
                    }
                }
                else {
                    storedImage.downloadURL { (url, error) in
                        if error == nil {
                            if let url = url {
                                switch type {
                                case .Landscape:
                                    view?.uploadImageLandscapeSuccess(keyRef: "\(url)")
                                case .Portal:
                                    view?.uploadImagePortalSuccess(keyRef: "\(url)")
                                }
                            } else {return}
                            
                        }
                    }
                    
                }
            })
            
        }
    }
    
    func updateImageEvent(keyRef: String, type: typeImage) {
        let ImageEvent = ["Event/\(keyEvent)/Image\(type)":(keyRef)] as [String : Any]
        ref.updateChildValues(ImageEvent as [AnyHashable : Any]) { [self] (error, snapshot) in
            if error != nil {
                view?.updateImageEventFailed()
            } else {
                view?.updateImageEventSuccess()
            }
        }
    }
    
}
