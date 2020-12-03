//
//  ChangePasswordViewController.swift
//  Uni
//
//  Created nguyen gia huy on 02/12/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import UIKit

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var lbChangePassword: UILabel!
    @IBOutlet weak var lbEnterYour: UILabel!
    @IBOutlet weak var lbNewPassword: UILabel!
    @IBOutlet weak var lbConfirmPassword: UILabel!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfỉrmPassword: UITextField!
    @IBOutlet weak var btSave: UIButton!
    var okActionHandler: ((UIAlertAction) -> Void)? = nil
    var presenter: ChangePasswordPresenterProtocol

	init(presenter: ChangePasswordPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "ChangePasswordViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
        presenter.view = self
        setupLanguage()
        setupUI()
        
    }
    
    func setupLanguage(){
        lbChangePassword.text = AppLanguage.ChangePassword.ChangePassword.localized
        lbEnterYour.text = AppLanguage.ChangePassword.EnterYourNew.localized
        lbNewPassword.text = AppLanguage.ChangePassword.NewPassword.localized
        txtNewPassword.placeholder = AppLanguage.Password.localized
        lbConfirmPassword.text = AppLanguage.ChangePassword.ConfirmPassword.localized
        txtConfỉrmPassword.placeholder = AppLanguage.Password.localized
        btSave.setTitle(AppLanguage.Save.localized, for: .normal)
        addBackToNavigation()
        
    }
    
    func setupUI(){
        btSave.backgroundColor = AppColor.YellowFAB32A
        btSave.shadowColor = AppColor.YellowFBC459
        lbEnterYour.textColor = AppColor.YellowFAB32A
    }
    @IBAction func btSave(_ sender: Any) {
        if let newPassword = txtNewPassword.text, let confirmPassword = txtConfỉrmPassword.text {
            if newPassword == confirmPassword {
                presenter.changePassword(newPassword: confirmPassword)
            } else {
                showAlert(title: AppLanguage.HandleError.anError.localized, message: AppLanguage.HandleError.NewnotsameConfirm.localized, actionTitles: [AppLanguage.Ok.localized], style: [.cancel], actions: [.none])
            }
            
        } else {return}
    }
    
    @objc func gotoSettingVC(){
        navigationController?.popViewController(animated: true)
    }
    
}

extension ChangePasswordViewController: ChangePasswordViewProtocol {
    func changePasswordSuccess() {
        showAlert(title: AppLanguage.HandleSuccess.Success.localized, message: AppLanguage.HandleSuccess.changePassword.localized, actionTitles: [AppLanguage.Ok.localized], style: [.cancel], actions: [okActionHandler])
        perform(#selector(gotoSettingVC), with: self, afterDelay: 1.0)
        
    }
    
    func changePasswordFailed(error: Error) {
        handleError(error)
    }
}