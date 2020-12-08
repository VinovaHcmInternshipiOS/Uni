//
//  UpdateEventViewController.swift
//  Uni
//
//  Created nguyen gia huy on 24/11/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import UIKit

class UpdateEventViewController: UIViewController {
    @IBOutlet weak var lbUpdateEvent: UILabel!
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
	var presenter: UpdateEventPresenterProtocol
    var imagePicker: ImagePicker!
    var scoreEvent = 0
    var keyDetailEvent = ""
    var imageLandscapeIsChanged = false
    var imagePortalIsChanged = false
    var urlImageLandscape = ""
    var urlImagePortal = ""

    var updateListEvent: (()->Void)? = nil
	init(presenter: UpdateEventPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "UpdateEventViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
        super.viewDidLoad()

        presenter.view = self
        presenter.getDetailEvent(keyEvent: keyDetailEvent)
        setupUI()
        setupLanguage()
    }
    
    func setupLanguage(){
        lbUpdateEvent.text = AppLanguage.UpdateEvent.UpdateEvent.localized
        lbTitle.text = AppLanguage.UpdateEvent.Title.localized
        lbOverview.text = AppLanguage.UpdateEvent.Overview.localized
        lbLocation.text = AppLanguage.UpdateEvent.Location.localized
        lbDate.text = AppLanguage.UpdateEvent.Date.localized
        lbTime.text = AppLanguage.UpdateEvent.Time.localized
        lbScore.text = AppLanguage.UpdateEvent.Score.localized
        btDone.setTitle(AppLanguage.UpdateEvent.btDone.localized, for: .normal)
        btChooseDate.setTitle(AppLanguage.UpdateEvent.ChooseDate.localized, for: .normal)
        btCheckin.setTitle(AppLanguage.UpdateEvent.Checkin.localized, for: .normal)
        btCheckout.setTitle(AppLanguage.UpdateEvent.Checkout.localized, for: .normal)
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
    
    @IBAction func btCheckin(_ sender: Any) {
        getTime()
    }
    
    @IBAction func btCheckout(_ sender: Any) {
        getTime()
    }
    
    func getTime() {
        let timePicker = TimePickerViewController(presenter: TimePickerPresenter())
        timePicker.dataTimePicker = { [self] in
            btCheckin.setTitle(timePicker.dateCheckin, for: .normal)
            btCheckout.setTitle(timePicker.dateCheckout, for: .normal)
        }
        timePicker.dateCheckin = (btCheckin.titleLabel?.text)!
        timePicker.dateCheckout = (btCheckout.titleLabel?.text)!
        timePicker.modalPresentationStyle = .overCurrentContext
        
        present(timePicker, animated: false, completion: nil)
    }
    
    @IBAction func btDone(_ sender: Any) {
        if (btCheckin.titleLabel?.text)! != AppLanguage.UpdateEvent.Checkin.localized && (btCheckout.titleLabel?.text)! != AppLanguage.UpdateEvent.Checkout.localized && contentTitle.text?.isEmpty == false && contentOverview.text?.isEmpty == false && contentLocation.text?.isEmpty == false {
            if let title = contentTitle.text, let overview = contentOverview.text, let location = contentLocation.text, let date = btChooseDate.titleLabel?.text,let checkin = btCheckin.titleLabel?.text,let checkout = btCheckout.titleLabel?.text {
                showSpinner()
                presenter.updateEvent(urlImgLanscape: urlImageLandscape, urlImgPortal: urlImagePortal, title: title, overview: overview, location: location, date: date, checkin: checkin.formatDateCreate(), checkout: checkout.formatDateCreate(), score: scoreEvent,keyEvent: keyDetailEvent)

            } else {return}

        } else {
            showAlert(title: AppLanguage.HandleError.anError.localized, message: AppLanguage.HandleError.fillIn.localized, actionTitles: [AppLanguage.Ok.localized], style: [.default], actions: [.none])
        }
    }
    
}
extension UpdateEventViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?, type: typeImage) {
        switch type {
        case .Landscape:
            imgLandscape.image = image
            imgPortal.layer.borderWidth = 1
            imgPortal.layer.borderColor = AppColor.YellowFAB32A.cgColor
            imageLandscapeIsChanged = true
        case .Portal:
            imagePortalIsChanged = true
            imgPortal.image = image
            
        }
    }

}

extension UpdateEventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return btScore.frame.height
    }
}

extension UpdateEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 21
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewScoreCell", for: indexPath) as? TableViewScoreCell {
            cell.lbScore.text = "\(indexPath.row)"
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        scoreEvent = indexPath.row
    }
    
}

extension UpdateEventViewController: UpdateEventViewProtocol {
    func updateImageEventSuccess() {
        updateListEvent?()
    }
    
    func updateImageEventFailed() {
        print("Update list event failed")
    }
    
    func uploadImageLandscapeSuccess(keyRef: String) {
        presenter.updateImageEvent(keyRef: keyRef, path: keyDetailEvent, type: .Landscape)
    }
    
    func uploadImagePortalSuccess(keyRef: String) {
        presenter.updateImageEvent(keyRef: keyRef, path: keyDetailEvent, type: .Portal)
    }
    
    func uploadImageLandscapeFailed() {
        print("Upload ref image landscape failed")
    }
    
    func uploadImagePortalFailed() {
        print("Upload ref image portal failed")
    }
    
    func fetchDetailSuccess() {
        let detail = presenter.detailEvent
        if let detail = detail {
            contentTitle.text = detail.title
            contentOverview.text = detail.content
            contentLocation.text = detail.address
            scoreEvent = detail.score ?? 0
            btChooseDate.setTitle(detail.date, for: .normal)
            btCheckin.setTitle(formatterTime(time: detail.checkin ?? ""), for: .normal)
            btCheckout.setTitle(formatterTime(time: detail.checkout ?? ""), for: .normal)
            imgLandscape.loadImage(urlString: detail.urlImageLandscape ?? "")
            imgPortal.loadImage(urlString: detail.urlImagePortal ?? "")
            urlImagePortal = detail.urlImagePortal ?? ""
            urlImageLandscape = detail.urlImageLandscape ?? ""
            tableViewScore.scrollToRow(at: IndexPath(row: detail.score ?? 0, section: 0), at: .middle, animated: true)
            //tableViewScore.reloadData()
        } else { return }
    }
    
    func fetchDetailFailed() {
        print("Fetch detail event failed")
    }
    
    func updateEventSuccess() {
        presentAlertWithTitle(title: AppLanguage.HandleSuccess.Success.localized, message: AppLanguage.HandleSuccess.updateEvent.localized, options: AppLanguage.Ok.localized) { [self] (option) in
            if imagePortalIsChanged == false {
                updateListEvent?()
            }
            self.navigationController?.popViewController(animated: true)
    }
        removeSpinner()
            if imageLandscapeIsChanged == true {
                if let imageLanscape = imgLandscape.image {
                    presenter.uploadImage(image: imageLanscape, type: .Landscape, path: keyDetailEvent)
                   
                } else { return }
                
            } else if imagePortalIsChanged == true {
                if let imagePortal = imgPortal.image {
                    presenter.uploadImage(image: imagePortal, type: .Portal, path: keyDetailEvent)
                } else { return }
               
            }
    }
    
    func updateEventFailed() {
        removeSpinner()
        presentAlertWithTitle(title: AppLanguage.HandleError.anError.localized, message: AppLanguage.HandleError.updateEvent.localized, options: AppLanguage.Ok.localized) { [] (option) in
        }
    }
    

    
    
}

