//
//  SettingViewController.swift
//  Uni
//
//  Created nguyen gia huy on 30/11/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import UIKit

class SettingViewController: BaseViewController, SettingViewProtocol {
    
    @IBOutlet weak var viewLanguage: UIView!
    @IBOutlet weak var chooseLanguage: UILabel!
    @IBOutlet weak var lbLanguage: UILabel!
    @IBOutlet weak var lbSetting: UILabel!
    @IBOutlet weak var lbChangePassword: UILabel!
    var presenter: SettingPresenterProtocol
    let notificationName = Notification.Name("Did selected language")
    var language = [String]()
	init(presenter: SettingPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "SettingViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self
        presenter.viewDidLoad()
        setupUI()
        setupLanguage()
        addNav()
        let changeLanguage = UITapGestureRecognizer(target: self, action: #selector(SettingViewController.changeLanguage(_:)))
        chooseLanguage.isUserInteractionEnabled = true
        chooseLanguage.addGestureRecognizer(changeLanguage)
        chooseLanguage.text = "\(UserDefaults.standard.value(forKey: "AppleLanguage") ?? "en")"
        
        
        let changePassword = UITapGestureRecognizer(target: self, action: #selector(SettingViewController.changePassword(_:)))
        lbChangePassword.isUserInteractionEnabled = true
        lbChangePassword.addGestureRecognizer(changePassword)
        
        
    }
    
    func setupLanguage(){
        lbSetting.text = AppLanguage.Setting.Setting.localized
        lbLanguage.text = AppLanguage.Setting.Language.localized
        lbChangePassword.text = AppLanguage.Setting.ChangePassword.localized
    }
    
    func setupUI(){
        chooseLanguage.textColor = AppColor.YellowFAB32A
    }
    
    func addNav() {
        addMenuButton()
        addButtonImageToNavigation(image: AppIcon.icBellYellow!, style: .right, action: #selector(notification))
        self.navigationController?.hideShadowLine()
    }
    
    @objc func notification(){

    }
    
    @objc func changeLanguage(_ recognizer: UIGestureRecognizer) {
        let alert = UIAlertController(title: AppLanguage.Setting.Language.localized, message: nil, preferredStyle: .actionSheet)
            
        alert.addAction(UIAlertAction(title: "Vietnamese", style: .default , handler:{ [self] (UIAlertAction)in
                UserDefaults.standard.set("vi", forKey: "AppleLanguage")
            chooseLanguage.text = "\(UserDefaults.standard.value(forKey: "AppleLanguage") ?? "vi")"
   
            }))
            
        alert.addAction(UIAlertAction(title: "English", style: .default , handler:{ [self] (UIAlertAction)in
                UserDefaults.standard.set("en", forKey: "AppleLanguage")
            chooseLanguage.text = "\(UserDefaults.standard.value(forKey: "AppleLanguage") ?? "en")"
            }))
            
        alert.addAction(UIAlertAction(title: AppLanguage.Cancel.localized, style: .destructive , handler:{ (UIAlertAction)in
            }))
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
    }
    
    @objc func changePassword(_ recognizer: UIGestureRecognizer) {
        let confirmPassword = ConfirmPasswordViewController(presenter: ConfirmPasswordPresenter())
        confirmPassword.presenter.view = self
        confirmPassword.modalPresentationStyle = .overCurrentContext
        present(confirmPassword, animated: false, completion: nil)
    }
}

extension SettingViewController: ConfirmPasswordViewProtocol {
    func confirmPasswordSuccess() {
        removeSpinner()
        dismiss(animated: false, completion: nil)
        let changePassword = ChangePasswordViewController(presenter: ChangePasswordPresenter())
        navigationController?.pushViewController(changePassword, animated: true)

    }
    
    func confirmPasswordFailed(error: Error) {
        removeSpinner()
        dismiss(animated: false, completion: nil)
        handleError(error)
        //txtPassword.text?.removeAll()
    }
}
