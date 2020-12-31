//
//  DetailAccountViewController.swift
//  Uni
//
//  Created nguyen gia huy on 03/12/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import UIKit

class DetailAccountViewController: BaseViewController {
    @IBOutlet weak var detailAccount: UILabel!
    @IBOutlet weak var lbCreated: UILabel!
    @IBOutlet weak var lbSignedIn: UILabel!
    @IBOutlet weak var lbState: UILabel!
    @IBOutlet weak var lbUID: UILabel!
    @IBOutlet weak var lbID: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbRole: UILabel!
    @IBOutlet weak var created: UILabel!
    @IBOutlet weak var signedin: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var uid: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var role: UILabel!
    @IBOutlet weak var btUpdate: UIButton!
    @IBOutlet weak var btState: UIButton!
    @IBOutlet weak var Spinner: UIActivityIndicatorView!
    
    var presenter: DetailAccountPresenterProtocol
    var refreshListUser: (() -> Void)? = nil
    var stateActionHandler: ((UIAlertAction) -> Void)? = nil
    var cancelActionHandler: ((UIAlertAction) -> Void)? = nil
    var keyUID = ""
    init(presenter: DetailAccountPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "DetailAccountViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.fetchDetailAccount(uid: keyUID)
        setupLanguage()
        setupUI()
        
    }
    
    func setupLanguage() {
        detailAccount.text = AppLanguage.DetailAccount.DetailAccount.localized
        lbCreated.text = AppLanguage.DetailAccount.Created.localized
        lbSignedIn.text = AppLanguage.DetailAccount.SignedIn.localized
        lbState.text = AppLanguage.DetailAccount.State.localized
        lbRole.text = AppLanguage.DetailAccount.Role.localized
        btUpdate.setTitle(AppLanguage.Update.localized, for: .normal)
    }
    
    func setupUI(){
        btUpdate.setTitleColor(AppColor.YellowFAB32A, for: .normal)
        Spinner.startAnimating()
    }
    @IBAction func btUpdate(_ sender: UIButton) {
        sender.animationScale()
    }
    @IBAction func btState(_ sender: UIButton) {
        sender.animationScale()
        if let valueState = btState.titleLabel?.text {
            if valueState == AppLanguage.Enable.localized {
                showAlert(title: AppLanguage.Confirm.localized, message: AppLanguage.HandleConfirm.Enable.localized, actionTitles: [AppLanguage.Cancel.localized,AppLanguage.Enable.localized], style: [.destructive,.default], actions: [cancelActionHandler,stateActionHandler])
            } else {
                showAlert(title: AppLanguage.Confirm.localized, message: AppLanguage.HandleConfirm.Disable.localized, actionTitles: [AppLanguage.Cancel.localized,AppLanguage.Disable.localized], style: [.destructive,.default], actions: [cancelActionHandler,stateActionHandler])
            }
        }else {return }
        
        stateActionHandler = { [self](action) in
            if let valueState = btState.titleLabel?.text {
                if valueState == AppLanguage.Enable.localized {
                    presenter.changeStateUser(state: true, keyUser: keyUID)
                } else {
                    presenter.changeStateUser(state: false, keyUser: keyUID)
                }
            }else {return }
            refreshListUser?()
        }
        
        cancelActionHandler = { [](action) in
            
        }
        
    }
    
}

extension DetailAccountViewController: DetailAccountViewProtocol {
    func changeStateUserSuccess() {
        showAlert(title: AppLanguage.HandleSuccess.Success.localized, message: AppLanguage.HandleSuccess.changeStateAccount.localized, actionTitles: [AppLanguage.Ok.localized], style: [.cancel], actions: [.none])
    }
    
    func changeStateUserFailed() {
        showAlert(title: AppLanguage.HandleError.anError.localized, message: AppLanguage.HandleError.changeStateAccount.localized, actionTitles: [AppLanguage.Ok.localized], style: [.cancel], actions: [.none])
    }
    
    func fetchDetailAccountSuccess() {
        Spinner.stopAnimating()
        Spinner.isHidden = true
        btState.isHidden = false
        let detail = presenter.detailAccount
        if let detail = detail {
            created.text = is12hClockFormat() == true ? formatterDateTime12h(time: detail.created ?? "") : formatterDateTime24h(time: detail.created ?? "")
            signedin.text = is12hClockFormat() == true ? formatterDateTime12h(time: detail.signedin ?? "") : formatterDateTime24h(time: detail.signedin ?? "")
            uid.text = detail.uid
            id.text = detail.id
            email.text = detail.email
            role.text = detail.role
            if role.text == "Admin" {
                role.text = AppLanguage.Admin.localized
            } else {
                role.text = AppLanguage.User.localized
            }
            if detail.state! {
                state.text = AppLanguage.True.localized
                state.textColor = UIColor.systemGreen
                btState.setTitle(AppLanguage.Disable.localized, for: .normal)
                btState.setTitleColor(.systemRed, for: .normal)
            } else {
                state.text = AppLanguage.False.localized
                state.textColor = UIColor.systemRed
                btState.setTitle(AppLanguage.Enable.localized, for: .normal)
                btState.setTitleColor(.systemGreen, for: .normal)
            }
            
        } else { return }
    }
    
    func fetchDetailAccountFailed() {
        print("fetch detail account failed")
    }
    
    
    
}
