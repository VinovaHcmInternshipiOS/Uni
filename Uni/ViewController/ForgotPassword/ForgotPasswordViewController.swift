//
//  ForgotPasswordViewController.swift
//  Uni
//
//  Created nguyen gia huy on 02/11/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import Foundation
import UIKit

class ForgotPasswordViewController: BaseViewController{

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var lbSend: UILabel!
    @IBOutlet weak var lbForgotPassword: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var btSend: UIButton!
    var presenter: ForgotPasswordPresenterProtocol

	init(presenter: ForgotPasswordPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "ForgotPasswordViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
        super.viewDidLoad()

        presenter.view = self
        addBackToNavigation()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLanguage()
       
    }
    
    func setupLanguage(){
        lbForgotPassword.text = AppLanguage.ForgotPassword.lbForgotPassword.localized
        lbSend.text = AppLanguage.ForgotPassword.lbSent.localized
        txtEmail.placeholder = AppLanguage.ResetPassword.EnterYourEmail.localized
    }
    
    func setupUI(){
        spinner.isHidden = true
    }
    
    @IBAction func btSend(_ sender: Any) {
        spinner.startAnimating()
        spinner.isHidden = false
        btSend.isEnabled = false
        presenter.sendEmailResetPassword(email: txtEmail.text!)
    }
}

extension ForgotPasswordViewController: ForgotPasswordViewProtocol {
    func sendSuccess() {
        spinner.stopAnimating()
        spinner.isHidden = true
        btSend.isEnabled = true
        presentAlertWithTitle(title: AppLanguage.HandleSuccess.Success.localized, message: AppLanguage.HandleSuccess.sendMailPassword.localized, options: AppLanguage.Ok.localized) { (Int) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    func sendFailed(error: Error!) {
        handleError(error)
        spinner.stopAnimating()
        spinner.isHidden = true
        btSend.isEnabled = true
    }
    
    
}
