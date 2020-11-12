//
//  UIViewController+Extension.swift
//  Uni
//
//  Created by nguyen gia huy on 12/11/2020.
//

import Foundation
import UIKit
var vSpinner : UIView?
var childView = UIView()
var loadingTextLabel = UILabel()
extension UIViewController {
    
    func showSpinner() {
        
        vSpinner = UIView.init(frame: view.bounds)
        vSpinner?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        childView.frame = CGRect(x: 0, y: 0, width: vSpinner!.frame.height / 10, height: vSpinner!.frame.height / 10)
        childView.backgroundColor = UIColor.white
        childView.center = vSpinner!.center
        childView.clipsToBounds = true
        childView.layer.cornerRadius = 20
        
        vSpinner?.addSubview(childView)
        
        vSpinner?.tag = 10
        
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.color = .gray
        
        ai.center = vSpinner!.center
        //ai.center = CGPoint(x: vSpinner!.center.x, y: vSpinner!.center.y)
        ai.backgroundColor = UIColor.white
        ai.startAnimating()
        vSpinner?.addSubview(ai)
        self.navigationController?.view.addSubview(vSpinner!)
        //self.view.addSubview(vSpinner!)
        DispatchQueue.main.async {
            vSpinner?.addSubview(ai)
            self.navigationController?.view.addSubview(vSpinner!)
            //self.view.addSubview(vSpinner!)
        }
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false){(t) in
            self.removeSpinner()
        }
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            if let viewWithTag = self.view.viewWithTag(10) {
                viewWithTag.removeFromSuperview()
            }
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
    
    public func showAlert(title: String?,
                          message: String?,
                          actionTitles: [String?],
                          style: [UIAlertAction.Style],
                          actions: [((UIAlertAction) -> Void)?],
                          preferredActionIndex: Int? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: style[index], handler: actions[index])
            alert.addAction(action)
        }
        if let preferredActionIndex = preferredActionIndex { alert.preferredAction = alert.actions[preferredActionIndex] }
        self.present(alert, animated: true, completion: nil)
    }
    
}
class Switcher {
    
    static func updateRootVC(){
        
        let status = UserDefaults.standard.bool(forKey: "status")
        var rootVC : UIViewController?
       
            print(status)
        

        if(status == true){
            rootVC = LoginViewController(presenter: LoginPresenter())
        }else{
            rootVC = AppHomeViewController(presenter: AppHomePresenter())
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
        
    }
    
}

