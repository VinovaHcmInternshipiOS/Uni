//
//  CreateEventPresenter.swift
//  Uni
//
//  Created nguyen gia huy on 19/11/2020.
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
protocol CreateEventViewProtocol: class {
    func createEventSuccess(path:String,title:String)
    func createEventFailed()
    func uploadImageLandscapeSuccess(keyRef:String,pathEvent:String)
    func uploadImagePortalSuccess(keyRef:String,pathEvent:String)
    func uploadImageLandscapeFailed()
    func uploadImagePortalFailed()
}

// MARK: Presenter -
protocol CreateEventPresenterProtocol: class {
    var view: CreateEventViewProtocol? { get set }
    var detailEvent: ADEEvent? { get set}
    func createEvent(urlImgLanscape: String,urlImgPortal:String,title:String,overview:String,location:String,date:String,checkin:String,checkout:String,score:Int)
    func uploadImage(images: [UIImage],path:String)
    func updateImageEvent(keyRef:String,path:String,type:typeImage)
}

class CreateEventPresenter: CreateEventPresenterProtocol {

    weak var view: CreateEventViewProtocol?
    var ref = Database.database().reference()
    var databaseHandle = DatabaseHandle()
    var user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    var detailEvent: ADEEvent?
    
    
    
    func createEvent(urlImgLanscape: String, urlImgPortal: String, title: String, overview: String, location: String, date: String, checkin: String, checkout: String, score: Int) {
        let path = self.ref.child("Event").childByAutoId()
        let childAuto = path.key
        let sentValue = ["ImageLandscape":"\(urlImgLanscape)","ImagePortal":"\(urlImgPortal)","Title":"\(title)","Overview":"\(overview)","Location":"\(location)","Date":"\(date)","Checkin":"\(checkin)","Checkout":"\(checkout)","Score":score,"Key":"\(childAuto!)","Type":"ComingSoon"] as [String : Any]
        path.setValue(sentValue) { [self]
            (error:Error?, ref:DatabaseReference) in
            if error != nil {
                view?.createEventFailed()
            }
            else
            {
                view?.createEventSuccess(path: childAuto!,title: title)
            }
        }
    }
    
    func uploadImage(images:[UIImage],path:String) {
        for i in 0..<images.count {
            let storedImage = storageRef.child("Event/\(path)/\(images[i].hashValue)")
            if let uploadData = images[i].jpegData(compressionQuality: 1)
            {
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpg"
                storedImage.putData(uploadData, metadata: metaData, completion: { [self]  (metadata, error) in
                    if error != nil {
                        switch i {
                        case 0:
                            view?.uploadImageLandscapeFailed()
                        case 1:
                            view?.uploadImagePortalFailed()
                        default:
                            break
                        }
                    }
                    else {
                        switch i {
                        case 0:
                            view?.uploadImageLandscapeSuccess(keyRef: storedImage.fullPath, pathEvent: path)
                        case 1:
                            view?.uploadImagePortalSuccess(keyRef: storedImage.fullPath, pathEvent: path)
                        default:
                            break
                        }
                    }
                })
                
            }
        }
        
    }
    
    func updateImageEvent(keyRef: String, path: String,type:typeImage) {
        let ImageEvent = ["Event/\(path)/Image\(type)":(keyRef)] as [String : Any]
        ref.updateChildValues(ImageEvent as [AnyHashable : Any]) { (error, snapshot) in
            if error != nil {
                print("failed")
            } else {
                print("success")
            }
        }
    }
    
}
