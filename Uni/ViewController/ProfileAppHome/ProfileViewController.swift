//
//  ProfileViewController.swift
//  Uni
//
//  Created nguyen gia huy on 19/11/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import UIKit
import Foundation

class ProfileViewController: BaseViewController  {
    @IBOutlet weak var imgBaner: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var btUpdateImage: UIButton!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    var profileUser = Profile()
    
	var presenter: ProfilePresenterProtocol
    var dataTitle = ["Email","Gender","Class","Course","Faculty"]
    var imagePicker: ImagePicker!
    var fromAppHome = false
    var fromAttendance = false
    var keyUser = ""
	init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "ProfileViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        setupUI()
        flowView()
        //transprentNav()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.themeNavigationBar(mode: .clear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.themeNavigationBar(mode: .normal)
    }
    
    func flowView() {
        if fromAppHome == true {
            presenter.fetchProfile()
        } else if fromAttendance == true{
            btUpdateImage.isHidden = true
            presenter.fetchProfileAttendance(keyUser: keyUser)
        }
    }
    func setupUI(){
        tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        imgProfile.borderColor = AppColor.YellowFAB32A
        btUpdateImage.setImage(AppIcon.icEditImageRed, for: .normal)
        
    }
    @IBAction func updateImage(_ sender: UIButton) {
        sender.animationScale()
        imagePicker.present(from: sender, type: .Landscape)

    }
    
}
extension ProfileViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?, type: typeImage) {
        showSpinner()
        presenter.updateImage(image: image ?? AppIcon.icDefaultImageCircle!)
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.tableView.layoutIfNeeded()
        self.heightTableView.constant = self.tableView.contentSize.height
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell{
            
            switch indexPath.row {
            case 0:
                cell.lbTitle.text = dataTitle[indexPath.row]
                cell.lbContent.text = profileUser.email
            case 1:
                cell.lbTitle.text = dataTitle[indexPath.row]
                cell.lbContent.text = profileUser.gender
            case 2:
                cell.lbTitle.text = dataTitle[indexPath.row]
                cell.lbContent.text = profileUser.classs
            case 3:
                cell.lbTitle.text = dataTitle[indexPath.row]
                cell.lbContent.text = profileUser.course
            case 4:
                cell.lbTitle.text = dataTitle[indexPath.row]
                cell.lbContent.text = profileUser.faculty
            default:
                break
            }
            return cell
            
        } else {return UITableViewCell()}
    }

}

extension ProfileViewController: ProfileViewProtocol {
    func fetchProfileAttendanceSuccess() {
        profileUser = presenter.profileUser!
        lbName.text = profileUser.name
        if let profileURL = profileUser.urlImage {
            imgBaner.loadImage(urlString: profileURL)
            imgProfile.loadImage(urlString: profileURL)
        }
        tableView.reloadData()
    }
    
    func fetchProfileAttendanceFailed() {
        print("fetch profile attendance failed")
    }
    
    func updateImageSuccess() {
        removeSpinner()
        print("update image success")
    }
    
    func updateImageFailed() {
        removeSpinner()
        print("update image failed")
    }
    
    func fetchProfileSuccess() {
        profileUser = presenter.profileUser!
        lbName.text = profileUser.name
        if let profileURL = profileUser.urlImage {
            imgBaner.loadImage(urlString: profileURL)
            imgProfile.loadImage(urlString: profileURL)
        }
        tableView.reloadData()
    }
    
    func fetchProfileFailed() {
        print("fetch profile failed")
    }
    
    
}
