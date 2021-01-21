//
//  AttendanceEventPresenter.swift
//  Uni
//
//  Created nguyen gia huy on 23/11/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Firebase
import FirebaseStorage
enum typeInput {
    case scan
    case keyboard
}
// MARK: View -
protocol AttendanceEventViewProtocol: class {
    func fetchAttendanceSuccess()
    func fetchAttendanceFailed()
    func userAttendanceSuccess(code: String,type:typeInput)
    func userAttendanceFailed()
    func checkUserAttendanceSuccess(code: String,type:typeInput)
    func checkUserAttendanceFailed(code: String,type:typeInput)
    func checkExistUserSuccess(code:String,type:typeInput)
    func checkExistUserFailed(code:String,type:typeInput)
    func createUserSuccess(code:String)
    func createUserFailed()
    func getScoreEventSuccess(score:Int,code:String)
    func getScoreEventFailed()
    func updateScoreSuccess(scoreEvent:Int,code:String)
    func updateScoreFailed()
    func getScoreUserSuccess(scoreUser:Int,scoreEvent:Int,code:String)
    func getScoreUserFailed()
    func updateListEventOfUserSuccess()
    func updateListEventOfUserFailed()
    func fetchDetailSuccess()
    func fetchDetailFailed()
    func checkFakeCodeSuccess(code:String,type:typeInput )
    func checkFakeCodeFailed()
    func searchAttendanceEventSuccess()
    func searchAttendanceEventFailed()
    func pushNotificationSuccess()
    func pushNotificationFailed()
}

// MARK: Presenter -
protocol AttendanceEventPresenterProtocol: class {
    var view: AttendanceEventViewProtocol? { get set }
    var infoAttendance: [AttendanceEvent?] {get set}
    var scanUser: AttendanceEvent? {get set}
    var detailEvent: DetailEvent? {get set}
    var dateEvent: String? {get set}
    var checkinEvent: String? {get set}
    var checkoutEvent: String? {get set}
    func fetchAttendance(keyEvent:String)
    func userAttendance(keyUser: String, keyEvent: String,date:String,checkin:String,type:typeInput)
    func checkUserAttendance(keyUser: String,type:typeInput)
    func fetchEventResult(keyEvent: String,keySearch:String)
    func checkExistUser(keyEvent:String,code: String,type: typeInput)
    func createUser(code:String)
    func getScoreEvent(keyEvent:String,code:String)
    func updateScore(keyEvent:String,code:String,scoreEvent:Int,scoreUser:Int)
    func getScoreUser(code:String,scoreEvent:Int)
    func updateListEventOfUser(code: String,keyEvent:String,score:Int,date:String,checkin:String)
    func getDetailEvent(keyEvent: String)
    func checkFakeCode(fakeCode: String,type: typeInput )
    func getDateTimeEvent(keyEvent: String)
    func sendPushNotification(to token: String, title: String, body: String, codeUser:String)
}

class AttendanceEventPresenter: AttendanceEventPresenterProtocol {
    
    
    
    weak var view: AttendanceEventViewProtocol?
    var ref = Database.database().reference()
    var databaseHandle = DatabaseHandle()
    var user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    var infoAttendance: [AttendanceEvent?] = []
    var scanUser: AttendanceEvent?
    var detailEvent: DetailEvent?
    var dateEvent: String?
    var checkinEvent: String?
    var checkoutEvent: String?
    
    func sendPushNotification(to token: String, title: String, body: String, codeUser:String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["condition": "'\(codeUser)' in topics",
                                           "priority" : "high",
                                           "notification" : [
                                             "body" : body,
                                             "title" : title,
                                           ],
                                           "data" :[
                                               "userDetail": codeUser
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
                        DispatchQueue.main.async { [self] in
                            view?.pushNotificationSuccess()
                        }
                    }
                }
            } catch let err as NSError {
                DispatchQueue.main.async { [self] in
                    view?.pushNotificationFailed()
                }
                
                print(err.debugDescription)
            }
        }
        task.resume()
    }
    
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
                
                detailEvent = DetailEvent(title: title, content: content, address: address, score: score, date: date, checkin: checkin, checkout: checkout, urlImageLandscape:urlImageLandscape,urlImagePortal: urlImagePortal, stateLike: false)
                
                view?.fetchDetailSuccess()
            }
            else
            {
                view?.fetchDetailFailed()
            }
        })
    }
    
    func getDateTimeEvent(keyEvent: String) {
        let placeRef = self.ref.child("Event/\(keyEvent)")
        placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
            if snapshot.exists()
            {
                let dict = snapshot.value as! [String: Any]
                let date = dict["Date"] as! String
                let checkout = dict["Checkout"] as! String
                let checkin = dict["Checkin"] as! String
                dateEvent = date
                checkinEvent = checkin
                checkoutEvent = checkout
            }
        })
    }
    
    func updateListEventOfUser(code: String,keyEvent:String,score:Int,date:String,checkin:String) {
        let path = self.ref.child("Data/\(code)/List").child(keyEvent)
        let sentValue = ["Date":"\(date)","Checkin":"\(checkin)","Score":score] as [String : Any]
        path.setValue(sentValue) { [self]
            (error:Error?, ref:DatabaseReference) in
            if error != nil {
                view?.updateListEventOfUserFailed()
            }
            else
            {
                view?.updateListEventOfUserSuccess()
            }
        }
    }
    
    func updateScore(keyEvent: String, code: String,scoreEvent:Int,scoreUser:Int) {
        let scoreUser = ["Data/\(code)/Score":(scoreUser + scoreEvent)] as [String : Any]
        ref.updateChildValues(scoreUser as [AnyHashable : Any]) { [self] (error, snapshot) in
            if error != nil {
                view?.updateScoreFailed()
            } else {
                view?.updateScoreSuccess(scoreEvent:scoreEvent,code:code)
            }
        }
        
    }
    
    func getScoreUser(code: String,scoreEvent:Int) {
        let placeRef = self.ref.child("Data/\(code)")
        placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
            if snapshot.exists()
            {
                let dict = snapshot.value as! [String: Any]
                let score = dict["Score"] as! Int
                
                view?.getScoreUserSuccess(scoreUser: score, scoreEvent: scoreEvent,code: code)
            }
            else
            {
                view?.getScoreUserFailed()
            }
        })
    }
    
    func getScoreEvent(keyEvent: String,code:String) {
        let placeRef = self.ref.child("Event/\(keyEvent)")
        placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
            if snapshot.exists()
            {
                let dict = snapshot.value as! [String: Any]
                let score = dict["Score"] as! Int
                
                view?.getScoreEventSuccess(score: score,code: code)
            }
            else
            {
                view?.getScoreEventFailed()
            }
        })
    }
    
    
    func userAttendance(keyUser: String, keyEvent: String,date:String,checkin:String,type: typeInput) {
        let path = self.ref.child("Joiner").child(keyEvent).child(keyUser)
        let sentValue = ["Date":"\(date)","Checkin":"\(checkin)"] as [String : Any]
        path.setValue(sentValue) { [self]
            (error:Error?, ref:DatabaseReference) in
            if error != nil {
                view?.userAttendanceFailed()
            }
            else
            {
                view?.userAttendanceSuccess(code: keyUser,type:type)
            }
        }
    }
    
    func checkUserAttendance(keyUser: String,type:typeInput){
        let placeRef = self.ref.child("Data").child("\(keyUser)")
        placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
            if(snapshot.exists())
            {
                view?.checkUserAttendanceSuccess(code: keyUser,type: type)
            } else {
                view?.checkUserAttendanceFailed(code: keyUser,type: type)
            }
        })
    }
    
    func fetchAttendance(keyEvent:String) {
        infoAttendance.removeAll()
        ref.child("Joiner/\(keyEvent)").observeSingleEvent(of: .value) { (snapshot) in
            if(snapshot.exists()) {
                for keyJoiner in snapshot.children.allObjects as! [DataSnapshot] {
                    let placeRef = self.ref.child("Joiner/\(keyEvent)/\(keyJoiner.key)")
                    placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
                        if snapshot.exists()
                        {
                            let placeDict = snapshot.value as! [String: Any]
                            let checkin = placeDict["Checkin"] as! String
                            let date = placeDict["Date"] as! String
                            
                            let placeRef = self.ref.child("Data").child("\(keyJoiner.key)")
                            placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
                                if(snapshot.exists())
                                {
                                    let placeDict = snapshot.value as! [String: Any]
                                    let name = placeDict["Name"] as! String
                                    let urlImage = placeDict["Image"] as! String
                                    
                                    infoAttendance.insert(AttendanceEvent(code: keyJoiner.key, name: name, checkin: checkin, date: date, urlImage: urlImage), at: 0)
                                        view?.fetchAttendanceSuccess()

                                    
                                }
                                else
                                {
                                    view?.fetchAttendanceFailed()
                                }
                            })
                        }
                        else
                        {
                            view?.fetchAttendanceFailed()
                        }
                    })
                    
                }
            }
        }
        
    }
    func fetchEventResult(keyEvent: String,keySearch:String) {
        infoAttendance.removeAll()
        self.ref.child("Joiner/\(keyEvent)").observeSingleEvent(of:.value) { [self] snapshot in
            if (snapshot.exists()) {
                for keyUser in snapshot.children.allObjects as! [DataSnapshot] {
                    let placeRef = self.ref.child("Joiner/\(keyEvent)/\(keyUser.key)")
                    placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
                        if snapshot.exists()
                        {
                            let placeDict = snapshot.value as! [String: Any]
                            let checkin = placeDict["Checkin"] as! String
                            let date = placeDict["Date"] as! String
                            
                            let placeRef = self.ref.child("Data").child("\(keyUser.key)")
                            placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
                                if(snapshot.exists())
                                {
                                    let placeDict = snapshot.value as! [String: Any]
                                    let name = placeDict["Name"] as! String
                                    let urlImage = placeDict["Image"] as! String
                                    
                                        if keyUser.key.lowercased().contains(keySearch) || name.lowercased().contains(keySearch) || checkin.lowercased().contains(keyEvent) {
                                            infoAttendance.insert(AttendanceEvent(code: keyUser.key, name: name, checkin: checkin, date: date, urlImage: urlImage), at: 0)
                                            view?.searchAttendanceEventSuccess()
                                        } else {
                                            view?.searchAttendanceEventFailed()
                                        }
                                    
                                }
                                else
                                {
                                    view?.searchAttendanceEventFailed()
                                }
                            })
                        }
                        else
                        {
                            view?.searchAttendanceEventFailed()
                        }
                    })
                }
            } else {
                view?.searchAttendanceEventFailed()
            }
            
        }
    }
    //    func fetchEventResult(keyEvent: String,keySearch:String) {
    //                    let placeRef = self.ref.child("Joiner/\(keyEvent)/\(keyJoiner)")
    //                    placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
    //                        if snapshot.exists()
    //                        {
    //                            let placeDict = snapshot.value as! [String: Any]
    //                            let checkin = placeDict["Checkin"] as! String
    //                            let date = placeDict["Date"] as! String
    //
    //                            let placeRef = self.ref.child("Data").child("\(keyJoiner)")
    //                            placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
    //                                if(snapshot.exists())
    //                                {
    //                                    let placeDict = snapshot.value as! [String: Any]
    //                                    let name = placeDict["Name"] as! String
    //                                    let urlImage = placeDict["Image"] as! String
    //
    //                                    if infoAttendance.contains(where: {$0?.code == keyJoiner}) == false {                           infoAttendance.insert(AttendanceEvent(code: keyJoiner, name: name, checkin: checkin, date: date, urlImage: urlImage), at: 0)
    //
    //                                        view?.searchAttendanceEventSuccess()
    //
    //                                    }
    //
    //                                }
    //                                else
    //                                {
    //                                    view?.searchAttendanceEventFailed()
    //                                }
    //                            })
    //                        }
    //                        else
    //                        {
    //                            view?.searchAttendanceEventFailed()
    //                        }
    //                    })
    //    }
    
    func createUser(code: String) {
        let path = self.ref.child("Data").child(code)
        let sentValue = ["Class":"Unknown","Code":"\(code)","Course":"Unknown","Faculty":"Unknown","Gender":"Unknown","Image":"","Name":"Unknown","Score":0] as [String : Any]
        path.setValue(sentValue) { [self]
            (error:Error?, ref:DatabaseReference) in
            if error != nil {
                view?.createUserFailed()
            }
            else
            {
                view?.createUserSuccess(code:code)
            }
        }
    }
    
    func checkExistUser(keyEvent:String,code: String,type:typeInput) {
        let placeRef = self.ref.child("Joiner/\(keyEvent)").child("\(code)")
        placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
            if(snapshot.exists())
            {
                view?.checkExistUserSuccess(code: code,type: type)
            } else {
                view?.checkExistUserFailed(code: code,type: type)
            }
        })
    }
    
    func checkFakeCode(fakeCode: String,type:typeInput) {
        let placeRef = self.ref.child("OTP").child("\(fakeCode)")
        placeRef.observeSingleEvent(of:.value, with: { [self] snapshot in
            if(snapshot.exists())
            {
                let placeDict = snapshot.value as! [String: Any]
                let code = placeDict["Code"] as! String
                
                DispatchQueue.main.async {
                    view?.checkFakeCodeSuccess(code: code,type:type )
                }
            }
            else
            {
                view?.checkFakeCodeFailed( )
            }
        })
    }
    
}
