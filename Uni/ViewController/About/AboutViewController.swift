//
//  AboutViewController.swift
//  Uni
//
//  Created nguyen gia huy on 30/11/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import UIKit

class AboutViewController: BaseViewController, AboutViewProtocol {

    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var lbPleaseSend: UILabel!
    @IBOutlet weak var lbFeedBack: UILabel!
    @IBOutlet weak var lbContactUs: UILabel!
    @IBOutlet weak var lbOurTeam: UILabel!
    @IBOutlet weak var lbUpdateOn: UILabel!
    @IBOutlet weak var titleVersion: UILabel!
    @IBOutlet weak var lbVersion: UILabel!
    @IBOutlet weak var lbAboutUs: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    var presenter: AboutPresenterProtocol

	init(presenter: AboutPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "AboutViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.viewDidLoad()
        setupLanguage()
        setupUI()
        addNav()
        
    }
    
    func setupLanguage(){
        lbAboutUs.text = AppLanguage.About.About.localized
        titleVersion.text = AppLanguage.About.Versison.localized
        lbVersion.text = AppLanguage.About.Versison.localized + " 1.0.0"
        lbUpdateOn.text = AppLanguage.About.UpdateOn.localized + " Aug 21th"
        lbOurTeam.text = AppLanguage.About.OurTeam.localized
        lbContactUs.text = AppLanguage.About.ContactUs.localized
        lbFeedBack.text = AppLanguage.About.Feedback.localized
        lbPleaseSend.text = AppLanguage.About.PleaseSend.localized + " theUni@uni.com.vn"
        lbLocation.text = AppLanguage.About.Location.localized + " 207 Dinh Tien Hoang Street,1 Distric, HCM City"
        lbPhone.text = AppLanguage.About.Phone.localized + " (+84) 123456789"
    }
    
    func setupUI(){

        titleVersion.textColor = AppColor.YellowFAB32A
        lbOurTeam.textColor = AppColor.YellowFAB32A
        lbContactUs.textColor = AppColor.YellowFAB32A
        lbFeedBack.textColor = AppColor.YellowFAB32A
        
    }
    
    func addNav() {
        addMenuButton()
        addButtonImageToNavigation(image: AppIcon.icBellYellow!, style: .right, action: #selector(notification))
        self.navigationController?.hideShadowLine()
    }
    
    @objc func notification(){

    }

}
