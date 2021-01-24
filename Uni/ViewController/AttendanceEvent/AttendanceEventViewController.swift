//
//  AttendanceEventViewController.swift
//  Uni
//
//  Created nguyen gia huy on 23/11/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import UIKit
import BarcodeScanner
import AVFoundation
import AudioToolbox
import MessageUI
import SVProgressHUD

class AttendanceEventViewController: BaseViewController,AVCaptureMetadataOutputObjectsDelegate,MFMailComposeViewControllerDelegate {
    @IBOutlet weak var lbNoData: UILabel!
    @IBOutlet weak var btPlus: UIButton!
    @IBOutlet weak var viewPlus: UIView!
    @IBOutlet weak var viewBtExport: UIView!
    @IBOutlet weak var btExport: UIButton!
    @IBOutlet weak var btScan: UIButton!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var pullControl = UIRefreshControl()
    var presenter: AttendanceEventPresenterProtocol
    var listAttendance = [AttendanceEvent?]()
    var keyDetailEvent = ""
    var getkeySearch: (()->Void)? = nil
    var countUser: (()->Void)? = nil
    var clearSearchText: (()->Void)? = nil
    var dataCSV: Data?
    let viewController = BarcodeScannerViewController()
    let systemSoundID: SystemSoundID = 1103 // Tick
    init(presenter: AttendanceEventPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "AttendanceEventViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self
        SVProgressHUD.show()
        presenter.fetchAttendance(keyEvent: keyDetailEvent)
        presenter.getDateTimeEvent(keyEvent: keyDetailEvent)
        setupUI()
        setupLanguage()
        pullRefreshData()
        addNav()
     
    }
    
    
    func setupLanguage(){
        //lbListAttendance.text = AppLanguage.ListAttendance.ListAttendance.localized
        lbNoData.text = AppLanguage.HandleError.noData.localized
    }
    
    func setupUI() {
        
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        

        collectionView.delegate =  self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AttendanceCell", bundle: nil), forCellWithReuseIdentifier: "AttendanceCell")
        collectionView.register(UINib(nibName: "HeaderAttendance", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderAttendance")
        
        collectionView.register(UINib(nibName: "HeaderAttendance", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HeaderAttendance")
        viewButton.shadowColor = AppColor.YellowShadow
        btScan.setImage(AppIcon.icBarcodeYellow, for: .normal)
        
        viewBtExport.shadowColor = AppColor.YellowShadow
        btExport.setImage(AppIcon.icExportYellow, for: .normal)
        
        viewPlus.shadowColor = AppColor.YellowShadow
        btPlus.setImage(AppIcon.icPlusYellow, for: .normal)
        pullControl.tintColor = AppColor.YellowFAB32A
        collectionView.alwaysBounceVertical = true
        collectionView.addSubview(pullControl)
        skeletonView()
    }
    
    
    func skeletonView(){
        collectionView.isSkeletonable = true
        collectionView.showAnimatedSkeleton(usingColor: UIColor.clouds, animation: nil, transition:.crossDissolve(0.25))
    }
    
    func addNav() {
        self.navigationController?.hideShadowLine()
    }
    
    @IBAction func btExport(_ sender: UIButton) {
        presenter.getDetailEvent(keyEvent: keyDetailEvent)
    }

    
    func showMailComposer()
    {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            UIApplication.shared.open(URL(string: "mailto:?subject=&body=")!)
        }
    }
    
    func createfileCSV(title:String, date:String, location:String, checkin:String, checkout:String, score:Int,Array: [AttendanceEvent?], total:Int,  mailString: NSMutableString)
    {
        
        
        mailString.append("\n")
        mailString.append(AppLanguage.ListAttendance.Title.localized + " \(title)\n")
        mailString.append(AppLanguage.ListAttendance.Date.localized + " \(date)\n")
        mailString.append(AppLanguage.ListAttendance.Location.localized + " \(location)\n")
        mailString.append(AppLanguage.ListAttendance.CheckIn.localized + " \(checkin)\n")
        mailString.append(AppLanguage.ListAttendance.CheckOut.localized + " \(checkout)\n")
        mailString.append("\n")
        mailString.append(AppLanguage.CreateEvent.Score.localized + " \(score)\n")
        mailString.append(AppLanguage.ListAttendance.TotalJoiner.localized + " \(Array.count)\n")
        mailString.append("\n")
        mailString.append("No, \(AppLanguage.ListAttendance.StudentID.localized),\(AppLanguage.ListAttendance.FirstName.localized),\(AppLanguage.ListAttendance.LastName.localized),\(AppLanguage.ListAttendance.Checkin.localized), \(AppLanguage.CreateEvent.Date.localized)\n")
        for n in 0..<total{
            let i = listAttendance.firstIndex(where: { $0!.code == Array[n]!.code })
            if let fullName = listAttendance[i!]?.name {
                var components = fullName.components(separatedBy: " ")
                if components.count > 0 {
                    //let lastName = components.removeFirst()
                    let lastName = components.removeLast()
                    let firstName = components.joined(separator: " ")
                    if let code = Array[n]?.code, let checkin = Array[n]?.checkin, let date = Array[n]?.date {
                        mailString.append("\(n+1),\(code),\(firstName),\(lastName),\(formatterTime12h(time: checkin)),\(date)\n")
                    } else { return }
                    
                }
                
            } else { return}
            
            self.dataCSV = mailString.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)
            
        }
    }
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        let systemVersion = UIDevice.current.systemVersion //version IOS
        //iPhone or iPad
        let model = UIDevice.current.model
        mailComposerVC.setSubject(AppLanguage.ListAttendance.RerportEvent.localized)
        mailComposerVC.setToRecipients(["hanhuy308@gmail.com"])
        mailComposerVC.addAttachmentData(dataCSV!, mimeType: "text/csv", fileName: "UniAttendace.csv")
        mailComposerVC.setMessageBody("\n\n\n\n\nIOS: \(systemVersion) \nDevice: \(model)", isHTML: false)
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error
        {
            controller.dismiss(animated: true)
        }
        switch result {
        case .cancelled:
            print("Cancel")
        case .failed:
            let alertViewController = UIAlertController(title: "Sent Mail Failed", message: "Please check your email again", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alertViewController.addAction(okAction)
            self.present(alertViewController, animated:  true, completion:  nil)
        case .saved:
            let alertViewController = UIAlertController(title: "Save Mail", message: "Your mail has been saved to the draft folder", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alertViewController.addAction(okAction)
            self.present(alertViewController, animated:  true, completion:  nil)
        case .sent:
            let alertViewController = UIAlertController(title: "Sent Mail Success", message: "Thank you for your  mail", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alertViewController.addAction(okAction)
            self.present(alertViewController, animated:  true, completion:  nil)
        @unknown default:
            fatalError()
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addAttendance(_ sender: Any) {

    }
    
    func refreshListAttendance() {
        presenter.fetchAttendance(keyEvent: keyDetailEvent)
    }
    
    @objc func pulledRefreshControl(sender:AnyObject) {
        skeletonView()
        clearSearchText?()
        refreshListAttendance()
    }
    
    private func pullRefreshData() {
        pullControl.addTarget(self, action: #selector(pulledRefreshControl), for: UIControl.Event.valueChanged)
    }
    
    func checkTime24h() -> [String] {
        return [is12hClockFormat() == true ? formatterTime12h(time: presenter.checkinEvent ?? "") : presenter.checkinEvent ?? "",is12hClockFormat() == true ? formatterTime12h(time: presenter.checkoutEvent ?? "") : presenter.checkoutEvent ?? ""]
    }
    
    func checkTimeAttendance() -> Bool {
        let formatDate = checkFormatDateTime12h()
        if let dateCurrent = transformStringDate(getCurrentDateTime12h(), fromDateFormat: formatDate, toDateFormat: formatDate), let dateCheckinEvent = transformStringDate("\(presenter.dateEvent ?? "") \(checkTime24h()[0])", fromDateFormat: formatDate, toDateFormat: formatDate),let dateCheckoutEvent = transformStringDate("\(presenter.dateEvent ?? "") \(checkTime24h()[1])", fromDateFormat: formatDate, toDateFormat: formatDate) {
            
            if Int(dateCurrent.toDateTimeFormat(format: formatDate).timeIntervalSince1970) < Int(dateCheckinEvent.toDateTimeFormat(format: formatDate).timeIntervalSince1970) {
                presentAlertWithTitle(title: AppLanguage.HandleError.anError.localized, message: AppLanguage.HandleError.timeInCheckin.localized, options: AppLanguage.Ok.localized) { (Int) in}
                return false
            } else if Int(dateCurrent.toDateTimeFormat(format: formatDate).timeIntervalSince1970) > Int(dateCheckoutEvent.toDateTimeFormat(format: formatDate).timeIntervalSince1970) {
                presentAlertWithTitle(title: AppLanguage.HandleError.anError.localized, message: AppLanguage.HandleError.timeOutCheckout.localized, options: AppLanguage.Ok.localized) { (Int) in}
                return false
           
            } else {
                return true
            }
        } else {return false}
    }

    @IBAction func scanBarcode(_ sender: Any) {
        viewController.headerViewController.closeButton.tintColor = .red
        viewController.cameraViewController.showsCameraButton = true
        viewController.cameraViewController.barCodeFocusViewType = .animated
        viewController.messageViewController.messages.notFoundText = AppLanguage.HandleError.invalidID.localized
        viewController.messageViewController.messages.processingText = AppLanguage.Checking.localized
        viewController.headerViewController.titleLabel.text = AppLanguage.titleCamera.localized
        viewController.messageViewController.messages.scanningText = AppLanguage.FooterCamera.localized
        if checkTimeAttendance() {
            present(viewController, animated: true, completion: nil)
        }
    }
    
    
    func vibrate()
    {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.impactOccurred()
        AudioServicesPlaySystemSound (systemSoundID)
    }
    
    
    @objc func actionSearch(sender: UIButton) {
        lbNoData.isHidden = true
        getkeySearch?()
    }
    
    func remakeData(){
        listAttendance = presenter.infoAttendance
        print("Count",listAttendance.count)
        collectionView.hideSkeleton()
        collectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
                collectionView.performBatchUpdates({
                    collectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
                }){_ in
                    // optional closure
                    print("finished updating cell")
                }
        checkEmptyData()
        
    }
    
    func checkEmptyData(){
        print(listAttendance.count)
        if presenter.infoAttendance.count != 0 {
            lbNoData.isHidden = true
        } else {
            listAttendance.removeAll()
            lbNoData.isHidden = false
        }
        SVProgressHUD.dismiss()
    }
}

extension AttendanceEventViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 , height: 170 )
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionView.elementKindSectionHeader:
                if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderAttendance", for: indexPath) as? HeaderAttendance {
                    countUser = { [self] in
                        headerView.lbTotal.text = AppLanguage.ListAttendance.Total.localized + " \(presenter.infoAttendance.count)"
                    }
                    headerView.lbHeader.text = AppLanguage.ListAttendance.ListAttendance.localized
                    headerView.lbTotal.isHidden = false
                    headerView.txtSearch.placeholder = AppLanguage.SearchEvent.Search.localized
                    headerView.btSearch.addTarget(self, action: #selector(actionSearch(sender:)), for: .touchUpInside)
                    clearSearchText = {
                        headerView.txtSearch.text = ""
                    }

                    getkeySearch = { [self] in
                        if let keysearch = headerView.txtSearch.text {
                            //presenter.infoAttendance = []
                            if(removeWhiteSpaceAndLine(text: keysearch) == "") {
                                presenter.fetchAttendance(keyEvent: keyDetailEvent)
                            } else {
                                skeletonView()
                                showSpinner()
                                presenter.fetchEventResult(keyEvent: keyDetailEvent, keySearch: keysearch.lowercased())
                            }

                        } else {return}

                    }
                    return headerView
                } else {
                    return UICollectionReusableView()
                }
                
            case UICollectionView.elementKindSectionFooter:
                if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderAttendance", for: indexPath) as? HeaderAttendance {
                        return headerView
                } else {return UICollectionReusableView()}
            default:
                
                assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0000000
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0000000
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 258 )
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
}

extension AttendanceEventViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listAttendance.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let profileUser = ProfileViewController(presenter: ProfilePresenter())
        profileUser.fromAttendance = true
        profileUser.keyUser = (listAttendance[indexPath.row]?.code)!
        self.navigationController?.pushViewController(profileUser, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttendanceCell", for: indexPath) as? AttendanceCell, let listAttendance = listAttendance[indexPath.row] {

            cell.dateCheckin.text = "\(getFormattedDate(date: listAttendance.date ?? ""))-\((listAttendance.checkin ?? "").toTimeFormat(format: checkFormatTime12h()))"
            cell.codeUser.text = listAttendance.code
            cell.nameUser.text = listAttendance.name
            
            if let profileURL = listAttendance.urlImage {
                cell.imageUser.sd_setImage(with: URL(string: profileURL), completed: nil)
                
            }
            
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
    
}

extension AttendanceEventViewController: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        vibrate()
        print("Barcode Data: \(code)")
        print("Symbology Type: \(type)")
        let charactersetTextView = CharacterSet(charactersIn: ",[]:;<>,+=-_|!@%^&?$/.{()*&^%#`~'} ")
        if checkTimeAttendance() {
            if (code.rangeOfCharacter(from: charactersetTextView.intersection(charactersetTextView)) != nil){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    controller.messageViewController.errorTintColor = UIColor.systemRed
                    controller.resetWithError(message: AppLanguage.HandleError.invalidID.localized)
                }
            }
            else
            {
                presenter.checkFakeCode(fakeCode: code, type: .scan)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                controller.messageViewController.errorTintColor = UIColor.systemRed
                controller.resetWithError(message: AppLanguage.HandleError.scanBarcodeEndedEvent.localized)
            }
        }

    }
}
// MARK: - BarcodeScannerErrorDelegate
extension AttendanceEventViewController: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
        
    }
}

// MARK: - BarcodeScannerDismissalDelegate
extension AttendanceEventViewController: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension AttendanceEventViewController: AttendanceEventViewProtocol {
    func pushNotificationSuccess() {
        
    }
    
    func pushNotificationFailed() {
        
    }
    
    
    func searchAttendanceEventSuccess() {
        countUser?()
        remakeData()
        SVProgressHUD.dismiss()
    }
    
    func searchAttendanceEventFailed() {
        checkEmptyData()
        countUser?()
        collectionView.hideSkeleton()
        SVProgressHUD.dismiss()
        collectionView.reloadData()
    }
    
    func checkFakeCodeSuccess(code: String, type: typeInput) {
        presenter.checkExistUser(keyEvent:keyDetailEvent,code: code,type:type)
    }
    
    func checkFakeCodeFailed() {
        
        viewController.messageViewController.errorTintColor = UIColor.systemRed
        viewController.resetWithError(message: AppLanguage.HandleError.invalidID.localized)
    }
    
    func fetchDetailSuccess() {
        let mailString = NSMutableString()
        let detail = presenter.detailEvent
        if let detail = detail {
            createfileCSV(title: detail.title ?? "", date: detail.date ?? "",location: detail.address ?? "", checkin: formatterTime12h(time: detail.checkin ?? "") , checkout: formatterTime12h(time: detail.checkout ?? ""), score: detail.score ?? 0, Array: listAttendance, total: listAttendance.count, mailString: mailString)
            //joinEvent.text = detail.joinEvent
            let filename = "\(detail.title ?? "") \(getCurrentDate()).csv"
            let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let documenturl = URL(fileURLWithPath: document).appendingPathComponent(filename)
            do {
                try dataCSV?.write(to: documenturl)
            } catch  {
                
            }
            let objectsToShare: [Any] = [documenturl]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    self.present(activityVC, animated: true, completion: nil)
        } else { return }
        
    }
    
    func fetchDetailFailed() {
        print("fetch detail event failed")
    }
    
    func updateListEventOfUserSuccess() {
        print("update list event of user success")
    }
    
    func updateListEventOfUserFailed() {
        print("update list event of user failed")
    }
    
    
    func updateListUserFailed() {
        print("update list user success")
    }
    
    func getScoreEventSuccess(score: Int,code:String) {
        presenter.getScoreUser(code: code, scoreEvent: score)
    }
    
    func getScoreEventFailed() {
        print("get score event failed")
    }
    
    func updateScoreSuccess(scoreEvent:Int,code:String) {
        print("get update score success")
        presenter.updateListEventOfUser(code: code, keyEvent: keyDetailEvent, score: scoreEvent, date: getCurrentDate(), checkin: getCurrentTime())
    }
    
    func updateScoreFailed() {
        print("update score failed")
    }
    
    func getScoreUserSuccess(scoreUser: Int, scoreEvent: Int,code:String) {
        presenter.updateScore(keyEvent: keyDetailEvent, code: code, scoreEvent: scoreEvent, scoreUser: scoreUser)
    }
    
    func getScoreUserFailed() {
        print("get score user failed")
    }
    
    
    func checkExistUserSuccess(code: String,type: typeInput) {
        switch type {
        case .scan:
           
            DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
                    viewController.messageViewController.errorTintColor = UIColor.systemRed
                    viewController.resetWithError(message: "\(code)\r\(AppLanguage.HandleError.attendanceAlready.localized)")
                }
            
      
        case .keyboard:
            presentAlertWithTitle(title: AppLanguage.HandleError.anError.localized, message: "\(code)\(AppLanguage.HandleError.attendanceAlready.localized)", options: AppLanguage.Ok.localized) { (Int) in
            }
        }
    }
    
    func checkExistUserFailed(code: String,type:typeInput) {
        presenter.userAttendance(keyUser: code, keyEvent: keyDetailEvent, date: getCurrentDate(), checkin: getCurrentTime(), type: type)
    }
    
    func createUserSuccess(code:String) {
        presenter.getScoreEvent(keyEvent: keyDetailEvent, code: code)
    }
    
    func createUserFailed() {
        print("Create user failed")
    }
    
    func checkUserAttendanceSuccess(code: String,type:typeInput) {
        switch type {
        case .scan:
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {  [self] in
                    viewController.messageViewController.errorTintColor = UIColor.systemGreen
                    viewController.resetWithError(message: "\(AppLanguage.HandleSuccess.attendance.localized) \rID: \(code)")
                }
            
  
        case .keyboard:
            presentAlertWithTitle(title: AppLanguage.HandleSuccess.Success.localized, message: "\(AppLanguage.HandleSuccess.attendance.localized)\r\(code)", options: AppLanguage.Ok.localized) { (Int) in
            }
        }
        presenter.sendPushNotification(to: "", title: "You have", body: "You have attended the event successfully\nPlease check the event history", codeUser: code)
        presenter.getScoreEvent(keyEvent: keyDetailEvent, code: code)
    }
    
    func checkUserAttendanceFailed(code: String,type:typeInput) {
        switch type {
        case .scan:
            
            DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
                    viewController.messageViewController.errorTintColor = UIColor.systemGreen
                    viewController.resetWithError(message: "\(AppLanguage.HandleSuccess.Success.localized) \(AppLanguage.HandleSuccess.updateInformationID.localized)")
                }
            
            
        case .keyboard:
            presentAlertWithTitle(title: AppLanguage.HandleSuccess.Success.localized, message: AppLanguage.HandleSuccess.updateInformationID.localized, options: AppLanguage.Ok.localized) { (Int) in
            }
        }
        presenter.createUser(code: code)
    }
    
    func userAttendanceSuccess(code: String,type:typeInput) {
        presenter.checkUserAttendance(keyUser: code,type: type)
        refreshListAttendance()
    }
    
    func userAttendanceFailed() {
        remakeData()
        pullControl.endRefreshing()
        print("Failed")
    }
    
    func fetchAttendanceSuccess() {
        countUser?()
        remakeData()
        pullControl.endRefreshing()
    }
    
    func fetchAttendanceFailed() {
        print("fetch attendance failed")
        countUser?()
        checkEmptyData()
        pullControl.endRefreshing()
    }
}
