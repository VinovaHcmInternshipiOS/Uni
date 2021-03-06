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
import UserNotifications
import Firebase
import SVProgressHUD
class LoginViewController: UIViewController {


    @IBOutlet weak var btLogin: UIButton!
    @IBOutlet weak var imgSignIn: UIImageView!
    @IBOutlet weak var spinnerLoading: UIActivityIndicatorView!
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
        defaultLoginHomeVC()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
        spinnerLoading.isHidden = true
    }
    
    @objc func gotoForgotPasswordVC(_ recognizer: UIGestureRecognizer) {
        let ForgotPasswordVC = ForgotPasswordViewController(presenter: ForgotPasswordPresenter())
        self.navigationController?.pushViewController(ForgotPasswordVC, animated: true)
    }
    
    @IBAction func gotoAppHomeVC(_ sender: Any) {
        SVProgressHUD.show()
        btLogin.isEnabled = false
        btSignup.isEnabled = false
        imgSignIn.isHidden = true
        spinnerLoading.isHidden = false
        spinnerLoading.startAnimating()
        if let email = txtEmail.text, let password = txtPassword.text {
            UserDefaults.standard.setValue(email, forKey: "email")
            UserDefaults.standard.setValue(password, forKey: "password")
            presenter.siginIn(email: email, password: password)
        } else {return}
    }
    
    func defaultLoginHomeVC(){
        if UserDefaults.standard.bool(forKey: "isLogin") == true {
            SVProgressHUD.show()
            btForgotPassword.isEnabled = false
            btLogin.isEnabled = false
            imgSignIn.isHidden = true
            spinnerLoading.isHidden = false
            txtEmail.isEnabled = false
            txtPassword.isEnabled = false
            spinnerLoading.startAnimating()
            let email = UserDefaults.standard.string(forKey: "email")
            let password = UserDefaults.standard.string(forKey: "password")
            if let email = email, let password = password {
                txtEmail.text = email
                txtPassword.text = password
                presenter.siginIn(email: email, password: password)
            } else { return }
           
        }
    }
    
    func isLogging(){
        imgSignIn.isHidden = false
        btLogin.isEnabled = true
        spinnerLoading.isHidden = true
        spinnerLoading.stopAnimating()
        btForgotPassword.isEnabled = true
        txtEmail.isEnabled = true
        txtPassword.isEnabled = true
    }
    
}

extension LoginViewController: LoginViewProtocol {

    func checkAuthSuccess(role: String,code:String) {
        print(role,"Change")
        print(code,"Code")
        UserDefaults.standard.setValue(code, forKey: "CodeUser")
        if UserDefaults.standard.string(forKey: "CodeUser") != nil {
            Messaging.messaging().subscribe(toTopic: UserDefaults.standard.string(forKey: "CodeUser")!)
        }
        
        if role != "Admin" {
            Messaging.messaging().subscribe(toTopic: "notify")
        } else {
            Messaging.messaging().unsubscribe(fromTopic: "notify")
        }

        AppColor.YellowFAB32A = role == "Admin" ? AppColor.RedFF7C75 : AppColor.DefaultYellowFAB32A
        
        AppColor.YellowFBC459 = role == "Admin" ? AppColor.RedFF6961 : AppColor.DefaultYellowFBC459
        
        AppColor.YellowShadow = role == "Admin" ? AppColor.RedShadow : AppColor.DefaultYellowShadow
        
        AppIcon.icPlusYellow = role == "Admin" ? AppIcon.icPlusRed : AppIcon.DefaulticPlusYellow
        
        AppIcon.icBarcodeYellow = role == "Admin" ? AppIcon.icBarcodeRed : AppIcon.DefaulticBarcodeYellow
        
        AppIcon.icEditImageYellow = role == "Admin" ? AppIcon.icEditImageRed : AppIcon.DefaulticEditImageYellow
        
        AppIcon.icBellYellow = role == "Admin" ? AppIcon.icBellRed : AppIcon.DefaulticBellYellow
        AppIcon.icArrowLeftYellow = role == "Admin" ? AppIcon.icArrowLeftRed : AppIcon.DefaulticArrowLeftYellow
        
        AppIcon.icExportYellow = role == "Admin" ? AppIcon.icExportRed : AppIcon.DefaulticExportYellow
        
        AppIcon.icWreathYellow = role == "Admin" ? AppIcon.icWreathRed : AppIcon.DefaulticWreathYellow
        
        AppIcon.icBookmartYellow = role == "Admin" ? AppIcon.icBookmartRed : AppIcon.DefaulticBookmartYellow
        
        AppIcon.icRemoveYellow = role == "Admin" ? AppIcon.icRemoveRed : AppIcon.DefaulticRemoveYellow
        
        UserDefaults.standard.set(false, forKey: "status")
        let AppHomeVC = AppHomeViewController(presenter: AppHomePresenter())
        AppHomeVC.isUpdateBadge?("2")
        UserDefaults.standard.setValue(0, forKey: "caseMenu")
        navigationController?.pushViewController(AppHomeVC, animated: true)
        AppHomeVC.code = code
        Switcher.updateRootVC()
        isLogging()
        SVProgressHUD.dismiss()
        UserDefaults.standard.setValue(true, forKey: "isLogin")
        UserDefaults.standard.setValue(code, forKey: "codeUser")
    }
    
    func checkAuthFailed() {
        presentAlertWithTitle(title: AppLanguage.HandleError.anError.localized, message: AppLanguage.HandleError.anotherError.localized, options: AppLanguage.Ok.localized) { (Int) in}
    }
    
    func checkStateUser() {
        presentAlertWithTitle(title: AppLanguage.HandleError.anError.localized, message: AppLanguage.HandleError.userDisabled.localized, options: AppLanguage.Ok.localized) { (Int) in}
    }
    
    func loginSuccess(uid: String) {
        presenter.checkSigned(uid: uid, timeSignedIn: getCurrentDateTime24h())
        presenter.checkAuth(uid: uid) { (role) in}
    }
    
    func loginFailed(error: Error) {
        isLogging()
        SVProgressHUD.dismiss()
        handleError(error)
    }
}
