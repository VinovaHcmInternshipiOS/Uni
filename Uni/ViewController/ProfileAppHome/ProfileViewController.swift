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
import SkeletonView
import SVProgressHUD
import FMPhotoPicker

class ProfileViewController: BaseViewController  {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgBaner: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var btUpdateImage: UIButton!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    private var pullControl = UIRefreshControl()
    var profileUser = Profile()
    var config = FMPhotoPickerConfig()
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
        btUpdateImage.setImage(AppIcon.icEditImageYellow, for: .normal)
        pullControl.tintColor = AppColor.YellowFAB32A
        skeletonView()
        pullRefreshData()
        scrollView.alwaysBounceVertical = true
        
    }
    
    func skeletonView() {
        lbName.isSkeletonable = true
        lbName.showAnimatedSkeleton(usingColor: UIColor.clouds, animation: nil, transition:.crossDissolve(0.25))
        
        tableView.isSkeletonable = true
        tableView.showAnimatedSkeleton(usingColor: UIColor.clouds, animation: nil, transition:.crossDissolve(0.25))
        skeletonImage()
        
    }
    func skeletonImage() {
        imgProfile.isSkeletonable = true
        imgProfile.showAnimatedSkeleton(usingColor: UIColor.clouds, animation: nil, transition:.crossDissolve(0.25))
        
        imgBaner.isSkeletonable = true
        imgBaner.showAnimatedSkeleton(usingColor: UIColor.clouds, animation: nil, transition:.crossDissolve(0.25))
    }
    
    func hideSkeletonView() {
        imgBaner.hideSkeleton()
        imgProfile.hideSkeleton()
        lbName.hideSkeleton()
    }
    
    @objc func pulledRefreshControl(sender:AnyObject) {
        skeletonView()
        flowView()
        
    }
    
    private func pullRefreshData() {
        pullControl.addTarget(self, action: #selector(pulledRefreshControl), for: UIControl.Event.valueChanged)
        scrollView.addSubview(pullControl)

    }
    
    @IBAction func updateImage(_ sender: UIButton) {
        sender.animationScale()
        imagePicker.present(from: sender, type: .Landscape)

    }
    

}
extension ProfileViewController: FMImageEditorViewControllerDelegate {
    func fmImageEditorViewController(_ editor: FMImageEditorViewController, didFinishEdittingPhotoWith photo: UIImage) {
        SVProgressHUD.show()
        skeletonImage()
        presenter.updateImage(image: photo)
        dismiss(animated: true, completion: nil)
    }
    
}

extension ProfileViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
    return "ProfileTableViewCell"
  }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  func collectionSkeletonView(_ skeletonView: UICollectionView, supplementaryViewIdentifierOfKind: String, at indexPath: IndexPath) -> ReusableCellIdentifier? {
    return "HeaderSearch"
  }
  func numSections(in collectionSkeletonView: UITableView) -> Int {
    return 1
  }
}

extension ProfileViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?, type: typeImage) {
        let editor = FMImageEditorViewController(config: config, sourceImage: image ?? AppIcon.icDefaultImageSquare!)
        editor.delegate = self
        self.present(editor, animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.tableView.layoutIfNeeded()
        self.heightTableView.constant = self.tableView.contentSize.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
                cell.lbTitle.text = dataTitle[indexPath.row].localized
                cell.lbContent.text = profileUser.email
            case 1:
                cell.lbTitle.text = dataTitle[indexPath.row].localized
                cell.lbContent.text = profileUser.gender?.localized
            case 2:
                cell.lbTitle.text = dataTitle[indexPath.row].localized
                cell.lbContent.text = profileUser.classs
            case 3:
                cell.lbTitle.text = dataTitle[indexPath.row].localized
                cell.lbContent.text = profileUser.course
            case 4:
                cell.lbTitle.text = dataTitle[indexPath.row].localized
                cell.lbContent.text = profileUser.faculty?.localized
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
        pullControl.endRefreshing()
        tableView.hideSkeleton()
        hideSkeletonView()
        tableView.reloadData()
    }
    
    func fetchProfileAttendanceFailed() {
        pullControl.endRefreshing()
        tableView.hideSkeleton()
        hideSkeletonView()
        print("fetch profile attendance failed")
    }
    
    func updateImageSuccess() {
        SVProgressHUD.dismiss()
        imgBaner.hideSkeleton()
        imgProfile.hideSkeleton()
        presentAlertWithTitle(title: AppLanguage.HandleSuccess.Success.localized, message: AppLanguage.HandleSuccess.updateAvatar.localized, options: AppLanguage.Ok.localized) { (Int) in}
        print("update image success")
    }
    
    func updateImageFailed() {
        SVProgressHUD.dismiss()
        imgBaner.hideSkeleton()
        imgProfile.hideSkeleton()
        presentAlertWithTitle(title: AppLanguage.HandleError.anError.localized, message: AppLanguage.HandleError.updateAvatar.localized, options: AppLanguage.Ok.localized) { (Int) in}
        print("update image failed")
    }
    
    func fetchProfileSuccess() {
        profileUser = presenter.profileUser!
        lbName.text = profileUser.name
        if let profileURL = profileUser.urlImage {
            imgBaner.sd_setImage(with: URL(string: profileURL), completed: nil)
            imgProfile.sd_setImage(with: URL(string: profileURL), completed: nil)
        }
        pullControl.endRefreshing()
        tableView.hideSkeleton()
        hideSkeletonView()
        tableView.reloadData()
    }
    
    func fetchProfileFailed() {
        pullControl.endRefreshing()
        tableView.hideSkeleton()
        hideSkeletonView()
        print("fetch profile failed")
    }
    
    
}
