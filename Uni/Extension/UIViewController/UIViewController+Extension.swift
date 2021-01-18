//
//  UIViewController+Extension.swift
//  Uni
//
//  Created by nguyen gia huy on 12/11/2020.
//

import Foundation
import FirebaseAuth
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
    func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            for (index, option) in options.enumerated() {
                alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                    completion(index)
                }))
            }
            self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String?,
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
    
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

            alert.addAction(okAction)

            self.present(alert, animated: true, completion: nil)

        }
    }
    
    func getFormattedDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateTime = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: dateTime ?? Date())
      }

    func formatterDateTime12h(time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let date = dateFormatter.date(from: time)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mma"
        return dateFormatter.string(from: date ?? Date())
    }
    
    func formatterDateTime24h(time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mma"
        let date = dateFormatter.date(from: time)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return dateFormatter.string(from: date ?? Date())
    }
    
    func formatterTime12h(time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: time)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "hh:mma"
        return dateFormatter.string(from: date ?? Date())
    }
    
    func formatterTime24h(time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma"
        let date = dateFormatter.date(from: time)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date ?? Date())
    }
    
    func formatterYear(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateTime = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: dateTime ?? Date())
    }
    
    func currentPickerDate(pickerDate: UIDatePicker) ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle =
            DateFormatter.Style.long
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: pickerDate.date)
    }
    
    func currentPickerTime(pickerTime: UIDatePicker) ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "hh:mma"
        return dateFormatter.string(from: pickerTime.date)

    }
    
    func getCurrentTime() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    func getCurrentDate() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
    
    func formatDateToString(date:Date) ->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
    
    func transformStringDate(_ dateString: String,
                             fromDateFormat: String,
                             toDateFormat: String) -> String? {

        let initalFormatter = DateFormatter()
        initalFormatter.dateFormat = fromDateFormat

        guard let initialDate = initalFormatter.date(from: dateString) else {
            print ("Error in dateString or in fromDateFormat")
            return nil
        }

        let resultFormatter = DateFormatter()
        resultFormatter.dateFormat = toDateFormat

        return resultFormatter.string(from: initialDate)
    }

    
    func getCurrentDateTime12h() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mma"
        return formatter.string(from: date)
    }
    
    func getCurrentDateTime24h() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return formatter.string(from: date)
    }
    
    func getTimeInveral() -> Int {
        let date = Date()
        let timeInveral = date.timeIntervalSince1970
        return Int(timeInveral)
    }
    
    func is12hClockFormat() -> Bool {
        let formatString = DateFormatter.dateFormat(
            fromTemplate: "j",
            options: 0,
            locale: Locale.current
        )!
        return formatString.contains("a")
    }
    
    func checkFormatDateTime12h() -> String {
        return is12hClockFormat() == true ? "dd-MM-yyyy hh:mma" : "dd-MM-yyyy HH:mm"
    }
    
    func checkFormatTime12h() -> String {
        return is12hClockFormat() == true ? "hh:mma" : "HH:mm"
    }

    func removeWhiteSpaceAndLine(text: String) -> String {
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func headerTableView(numberOfLine:Int,labelColor: UIColor,labelFont:UIFont,titleHeader:String,leftAnchor:Int,topAnchor:Int) -> UIView {
        let label = UILabel()
        let headerView = UIView()
        label.font = labelFont
        label.text = titleHeader
        label.textColor = labelColor
        label.numberOfLines = numberOfLine
        headerView.backgroundColor = .none
        headerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: CGFloat(leftAnchor)).isActive = true
        label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: CGFloat(topAnchor)).isActive = true
        return headerView
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



