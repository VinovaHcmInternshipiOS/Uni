//
//  LoginViewController.swift
//  Uni
//
//  Created nguyen gia huy on 02/11/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import UIKit

class LoginViewController: UIViewController {


    @IBOutlet weak var lbSignUp: UILabel!
    @IBOutlet weak var lbDontAccount: UILabel!
    @IBOutlet weak var lbLogin: UILabel!
    @IBOutlet weak var lbPassword: UILabel!
    @IBOutlet weak var lbSignInContinue: UILabel!
    @IBOutlet weak var lbWelcomeBack: UILabel!
    @IBOutlet weak var btForgotPassword: UILabel!
    @IBOutlet weak var btSignup: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var presenter: LoginPresenterProtocol
    var tapGesture = UITapGestureRecognizer()

	init(presenter: LoginPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "LoginViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        setupUI()
        customNav()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLanguage()
    }
    
    func setupLanguage(){
        lbWelcomeBack.text = AppLanguage.Login.lbWelcomeBack.localized
        lbSignInContinue.text = AppLanguage.Login.lbSignInContinue.localized
        lbPassword.text = AppLanguage.Password.localized
        lbLogin.text = AppLanguage.Login.lbLogin.localized
        btForgotPassword.text = AppLanguage.Login.btForgotPassword.localized
        lbDontAccount.text =  AppLanguage.Login.lbDontAccount.localized
        btSignup.text = AppLanguage.Login.btSignup.localized
        
    }
    
    func customNav() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.white
          self.navigationController?.hideShadowLine()
    }
    
    func setupUI(){
        // Go to ForgotPaswordVC
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.gotoForgotPasswordVC(_:)))
        btForgotPassword.isUserInteractionEnabled = true
        btForgotPassword.addGestureRecognizer(rightTap)
    }
    
    @objc func gotoForgotPasswordVC(_ recognizer: UIGestureRecognizer) {
        let ForgotPasswordVC = ForgotPasswordViewController(presenter: ForgotPasswordPresenter())
        self.navigationController?.pushViewController(ForgotPasswordVC, animated: true)
    }
    
    @IBAction func gotoAppHomeVC(_ sender: Any) {
        self.showSpinner()
        presenter.siginIn(email: txtEmail.text!, password: txtPassword.text!)
        
    }
    let okActionHandler: ((UIAlertAction) -> Void) = {(action) in
        print("OK")
    }

    let cancelActionHandler: ((UIAlertAction) -> Void) = {(action) in
        print("Error")
    }
    
}

extension LoginViewController: LoginViewProtocol {
    
    func checkAuthSuccess(role: String) {
        print(role,"Change")
        AppColor.YellowFAB32A = role == "Admin" ? AppColor.RedFF7C75 : AppColor.DefaultYellowFAB32A
        AppColor.YellowFBC459 = role == "Admin" ? AppColor.RedFF6961 : AppColor.DefaultYellowFBC459
        AppColor.YellowShadow = role == "Admin" ? AppColor.RedShadow : AppColor.DefaultYellowShadow
        AppIcon.icPlusYellow = role == "Admin" ? AppIcon.icPlusRed : AppIcon.DefaulticPlusYellow
        AppIcon.icBarcodeYellow = role == "Admin" ? AppIcon.icBarcodeRed : AppIcon.DefaulticBarcodeYellow
        AppIcon.icEditImageYellow = role == "Admin" ? AppIcon.icEditImageRed : AppIcon.DefaulticEditImageYellow
        AppIcon.icBellYellow = role == "Admin" ? AppIcon.icBellRed : AppIcon.DefaulticBellYellow
        AppIcon.icArrowLeftYellow = role == "Admin" ? AppIcon.icArrowLeftRed : AppIcon.DefaulticArrowLeftYellow
        AppIcon.icExportYellow = role == "Admin" ? AppIcon.icExportRed : AppIcon.DefaulticExportYellow 
        
        UserDefaults.standard.set(false, forKey: "status")
        Switcher.updateRootVC()
        let AppHomeVC = AppHomeViewController(presenter: AppHomePresenter())
        UserDefaults.standard.setValue(0, forKey: "caseMenu")
        navigationController?.pushViewController(AppHomeVC, animated: true)
        
    }
    
    func checkAuthFailed() {
        print("Check Auth Failed")
    }
    
    
    func loginSuccess() {
        removeSpinner()
        presenter.checkAuth { (role) in
            
        }
    }
    
    func loginFailed(error: Error) {
        removeSpinner()
        handleError(error)
    }
}
