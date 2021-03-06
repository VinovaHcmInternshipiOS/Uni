//
//  CreateEventViewController.swift
//  Uni
//
//  Created nguyen gia huy on 19/11/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import UIKit
import FMPhotoPicker
import SVProgressHUD

class CreateEventViewController: BaseViewController {
    @IBOutlet weak var lbCreateEvent: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbOverview: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var imgLandscape: UIImageView!
    @IBOutlet weak var imgPortal: UIImageView!
    @IBOutlet weak var btImgLandscape: UIButton!
    @IBOutlet weak var btImgPortal: UIButton!
    @IBOutlet weak var contentTitle: UITextField!
    @IBOutlet weak var contentOverview: UITextView!
    @IBOutlet weak var contentLocation: UITextField!
    @IBOutlet weak var btChooseDate: UIButton!
    @IBOutlet weak var btCheckin: UIButton!
    @IBOutlet weak var btCheckout: UIButton!
    @IBOutlet weak var btScore: UIButton!
    @IBOutlet weak var btDone: UIButton!
    @IBOutlet weak var tableViewScore: UITableView!
    var pickerDate: UIDatePicker?
	var presenter: CreateEventPresenterProtocol
    var imagePicker: ImagePicker!
    var scoreEvent = 0
    var refreshListEvent: (()->Void)? = nil
    var config = FMPhotoPickerConfig()
    var flagImageLandscape = false
    var flagImagePortal = false
	init(presenter: CreateEventPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "CreateEventViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
        super.viewDidLoad()

        presenter.view = self
        setupUI()
        setupLanguage()
    }
    
    func setupLanguage(){
        lbCreateEvent.text = AppLanguage.CreateEvent.CreateEvent.localized
        lbTitle.text = AppLanguage.CreateEvent.Title.localized
        lbOverview.text = AppLanguage.CreateEvent.Overview.localized
        lbLocation.text = AppLanguage.CreateEvent.Location.localized
        lbDate.text = AppLanguage.CreateEvent.Date.localized
        lbTime.text = AppLanguage.CreateEvent.Time.localized
        lbScore.text = AppLanguage.CreateEvent.Score.localized
        btDone.setTitle(AppLanguage.CreateEvent.btDone.localized, for: .normal)
        btChooseDate.setTitle(AppLanguage.CreateEvent.ChooseDate.localized, for: .normal)
        btCheckin.setTitle(AppLanguage.CreateEvent.Checkin.localized, for: .normal)
        btCheckout.setTitle(AppLanguage.CreateEvent.Checkout.localized, for: .normal)
    }
    
    func setupUI(){
        tableViewScore.delegate = self
        tableViewScore.dataSource = self
        tableViewScore.register(UINib(nibName: "TableViewScoreCell", bundle: nil), forCellReuseIdentifier: "TableViewScoreCell")
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        lbTitle.textColor = AppColor.YellowFAB32A
        lbOverview.textColor = AppColor.YellowFAB32A
        lbLocation.textColor = AppColor.YellowFAB32A
        lbDate.textColor = AppColor.YellowFAB32A
        lbTime.textColor = AppColor.YellowFAB32A
        lbScore.textColor = AppColor.YellowFAB32A
        btDone.backgroundColor = AppColor.YellowFAB32A
        imgPortal.borderColor = AppColor.YellowFBC459
        btDone.shadowColor = AppColor.YellowShadow
        
    }
    
    func datePickerView()
    {
        
        self.pickerDate = UIDatePicker()
        pickerDate?.datePickerMode = .date
        pickerDate?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        
    }
    @objc func dateChanged(datePicker: UIDatePicker){//format date
        btChooseDate.setTitle(getFormattedDate(date: "\(pickerDate!.date)"), for: .normal)
        // view.endEditing(true)
    }
    

    
    @IBAction func btImgPortal(_ sender: UIButton) {
        sender.animationScale()
        imagePicker.present(from: sender,type: .Portal)
    }
    
    @IBAction func btImgLandscape(_ sender: UIButton) {
        sender.animationScale()
        imagePicker.present(from: sender,type: .Landscape)
    }
    
    @IBAction func btChooseDate(_ sender: UIButton) {
        let datePicker = DatePickerViewViewController(presenter: DatePickerViewPresenter())
        datePicker.dataDatePicker = { [self] in
            btChooseDate.setTitle(datePicker.dataPicker, for: .normal)
        }
        datePicker.dataPicker = (btChooseDate.titleLabel?.text)!
        datePicker.modalPresentationStyle = .overCurrentContext
        present(datePicker, animated: false, completion: nil)
    }
    
    func checkEmptyDate() -> Bool {
        if let date = btChooseDate.titleLabel?.text {
            if date == AppLanguage.CreateEvent.ChooseDate.localized {
                presentAlertWithTitle(title: AppLanguage.HandleError.anError.localized, message: AppLanguage.HandleError.noDate.localized, options: AppLanguage.Ok.localized) { (Int) in}
                return false
            } else {
                return true
            }
        } else { return false}
    }
    
    @IBAction func btCheckin(_ sender: Any) {
        if checkEmptyDate() {
            getTime()
        }
        
    }
    
    @IBAction func btCheckout(_ sender: Any) {
        if checkEmptyDate() {
            getTime()
        }
    }
    
    func getTime() {
        let timePicker = TimePickerViewController(presenter: TimePickerPresenter())
        timePicker.dataTimePicker = { [self] in
            btCheckin.setTitle(timePicker.dateCheckin, for: .normal)
            btCheckout.setTitle(timePicker.dateCheckout, for: .normal)
        }
        timePicker.timePick = (btChooseDate.titleLabel?.text)!
        timePicker.dateCheckin = (btCheckin.titleLabel?.text)!
        timePicker.dateCheckout = (btCheckout.titleLabel?.text)!
        timePicker.modalPresentationStyle = .overCurrentContext
        present(timePicker, animated: false, completion: nil)
    }
    
    @IBAction func btDone(_ sender: Any) {
        if let title = contentTitle.text, let overview = contentOverview.text, let location = contentLocation.text, let date = btChooseDate.titleLabel?.text,let checkin = btCheckin.titleLabel?.text,let checkout = btCheckout.titleLabel?.text {
            
            if checkin != AppLanguage.CreateEvent.Checkin.localized && checkout != AppLanguage.CreateEvent.Checkout.localized && removeWhiteSpaceAndLine(text: overview) != "" && removeWhiteSpaceAndLine(text: title) != "" && removeWhiteSpaceAndLine(text: location) != "" && date != AppLanguage.CreateEvent.ChooseDate.localized {
                SVProgressHUD.show()
                btDone.isEnabled = false
                presenter.createEvent(urlImgLanscape: "", urlImgPortal: "", title: removeWhiteSpaceAndLine(text: title), overview: removeWhiteSpaceAndLine(text: overview), location: removeWhiteSpaceAndLine(text: location), date: date, checkin: checkin.formatDateCreate(), checkout: checkout.formatDateCreate(), score: scoreEvent)
                
            } else {
                showAlert(title: AppLanguage.HandleError.anError.localized, message: AppLanguage.HandleError.fillIn.localized, actionTitles: [AppLanguage.Ok.localized], style: [.default], actions: [.none])
            }
        } else {return}
        
    }
    
    func filterImage(image:UIImage){
        let editor = FMImageEditorViewController(config: config, sourceImage: image)
        editor.delegate = self
        self.present(editor, animated: true)
    }
    
}

extension CreateEventViewController: FMImageEditorViewControllerDelegate {
    func fmImageEditorViewController(_ editor: FMImageEditorViewController, didFinishEdittingPhotoWith photo: UIImage) {
        if flagImageLandscape {
            flagImageLandscape = !flagImageLandscape
            imgLandscape.image = photo
            dismiss(animated: true, completion:  nil)
            return
        }
        if flagImagePortal {
            flagImagePortal = !flagImagePortal
            imgPortal.image = photo
            dismiss(animated: true, completion:  nil)
            return
        }
        
        
    }
    
    
}

extension CreateEventViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?, type: typeImage) {
        switch type {
        case .Landscape:
            imgLandscape.image = image
            flagImageLandscape = true
            filterImage(image: (image ?? AppIcon.defaultImagenil!))
            imgPortal.layer.borderWidth = 1
            imgPortal.layer.borderColor = AppColor.YellowFAB32A.cgColor
        case .Portal:
            imgPortal.image = image
            flagImagePortal = true
            filterImage(image: (image ?? AppIcon.defaultImagenil!))
            
        }
    }

}

extension CreateEventViewController: CreateEventViewProtocol {
    func updateImageEventSuccess() {
        refreshListEvent?()
    }
    
    func updateImageEventFailed() {
        //refreshListEvent?()
    }
    
    func pushNotificationSuccess() {
        presentAlertWithTitle(title: AppLanguage.HandleSuccess.Success.localized, message: AppLanguage.HandleSuccess.pushNotification.localized, options: AppLanguage.Ok.localized) { (Int) in}
    }
    
    func pushNotificationFailed() {
        presentAlertWithTitle(title: AppLanguage.HandleError.anError.localized, message: AppLanguage.HandleError.pushNotification.localized, options: AppLanguage.Ok.localized) { (Int) in}
    }
    
    func createEventSuccess(path: String, title: String,keyEvent:String) {
        SVProgressHUD.dismiss()
        presenter.sendPushNotification(to: "", title: AppLanguage.CreateEvent.newEvent.localized, body: "\(AppLanguage.CreateEvent.havejustAdded.localized) \(title) \(AppLanguage.CreateEvent.letExlore.localized)",keyEvent:keyEvent)
        presentAlertWithTitle(title: AppLanguage.HandleSuccess.Success.localized, message: AppLanguage.HandleSuccess.createEvent.localized, options: AppLanguage.Ok.localized) { [self] (option) in
            btDone.isEnabled = true
            refreshListEvent?()
            self.navigationController?.popViewController(animated: true)
            
        }
        presenter.uploadImage(images: [imgLandscape.image!,imgPortal.image!], path: path)
//        if let imageLanscape = imgLandscape.image {
//            presenter.uploadImage(images: [imageLanscape],path: path)
//        } else {return}
//
//        if let imagePortal = imgPortal.image {
//            presenter.uploadImage(images: [,imagePortal],path: path)
//        } else {return}
        
        
    }
    
    func uploadImageLandscapeSuccess(keyRef: String, pathEvent: String) {
        presenter.updateImageEvent(keyRef: keyRef, path: pathEvent, type: .Landscape)
        SVProgressHUD.dismiss()
    }
    
    func uploadImagePortalSuccess(keyRef: String, pathEvent: String) {
        presenter.updateImageEvent(keyRef: keyRef, path: pathEvent, type: .Portal)
        SVProgressHUD.dismiss()
    }
    
    func uploadImageLandscapeFailed() {
        print("Upload image lanscape failed")
        SVProgressHUD.dismiss()
    }
    
    func uploadImagePortalFailed() {
        print("Upload image portal failed")
        SVProgressHUD.dismiss()
    }

    func createEventFailed() {
        SVProgressHUD.dismiss()
        presentAlertWithTitle(title: AppLanguage.HandleError.anError.localized, message: AppLanguage.HandleError.createEvent.localized, options: AppLanguage.Ok.localized) { [self] (option) in
            btDone.isEnabled = true
        }
       
    }
    
    
}

extension CreateEventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return btScore.frame.height
    }
}

extension CreateEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 21
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewScoreCell", for: indexPath) as? TableViewScoreCell {
            cell.lbScore.text = "\(indexPath.row)"
            print(indexPath.row)
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        scoreEvent = indexPath.row
    }
    
}
