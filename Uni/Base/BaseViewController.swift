//
//  BaseViewController.swift
//  Uni
//
//  Created by nguyen gia huy on 13/11/2020.
//

import Foundation
import UIKit
import SkeletonView

enum StyleNavigation {
    case left
    case right
}

class BaseViewController: UIViewController,UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate{
    let transition = SlideInTransition()
    var reloadHomeVC: (()->Void)? = nil
    var backTapped : (() -> Void)? = nil
    var isUseMenuButton: Bool = false {
        didSet {
            if isUseMenuButton {
                addMenuButton()
            }
        }
    }
    
    func addMenuButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: AppIcon.icThreeLine, style: .plain, target: self, action: #selector(presentLeftMenu))
        navigationController?.navigationBar.tintColor = AppColor.YellowFAB32A
    }
    
    var lbTitleVC: UILabel = {
        let lb = UILabel()
        lb.font = AppFont.Raleway_Bold_18
        lb.textColor = .black
        return lb
    }()
    let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        overrideUserInterfaceStyle = .light
        addBackToNavigation()
        //navigationController?.interactivePopGestureRecognizer?.delegate = self
        //navigationItem.titleView = lbTitleVC
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    
    func addBackToNavigation(icon: UIImage = AppIcon.icArrowLeftYellow!) {
        addButtonImageToNavigation(image: icon, style: .left, action: #selector(btnBackTapped))
    }
    
    func addButtonImageToNavigation(image: UIImage, style: StyleNavigation, action: Selector?) {
        showNavigation(bottomLine: false)
        let btn = UIButton()
        btn.setImage(image, for: .normal)
        if let _action = action {
            btn.addTarget(self, action: _action, for: .touchUpInside)
        }
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        btn.imageView?.contentMode = .scaleAspectFit
        let button = UIBarButtonItem(customView: btn)
        if style == .left {
            btn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 20)
            btn.contentHorizontalAlignment = .left
            self.navigationItem.leftBarButtonItem = button
        } else {
            btn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 0)
            self.navigationItem.rightBarButtonItem = button
            btn.contentHorizontalAlignment = .right
        }
    }
    
    func addButtonToNavigation(title: String, style: StyleNavigation, action: Selector?, backgroundColor: UIColor = UIColor.white, textColor: UIColor = AppColor.Gray5B5B5B, font: UIFont = AppFont.Raleway_Regular_16, cornerRadius: CGFloat = 0, size: CGSize = CGSize(width: 20, height: 10), borderWidth: Double = 0, borderColor: UIColor = .clear){
        let btnRight = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
        if let _action = action {
            btnRight.addTarget(self, action: _action, for: .touchUpInside)
        }
        btnRight.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        btnRight.layer.cornerRadius = cornerRadius
        btnRight.backgroundColor = backgroundColor
        btnRight.borderWidth = CGFloat(borderWidth)
        btnRight.borderColor = borderColor
        btnRight.contentHorizontalAlignment = .center
        //  btnRight.setAttributed(title: title, color: textColor, font: font)
        btnRight.setTitleColor(textColor, for: .normal)
        btnRight.setTitle(title, for: .normal)
        btnRight.titleLabel?.font = font
        let button = UIBarButtonItem(customView: btnRight)
        if style == .left {
            self.navigationItem.leftBarButtonItem = button
        } else {
            self.navigationItem.rightBarButtonItem = button
        }
    }
    
    func showNavigation(bottomLine: Bool = true) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        if bottomLine {
            self.navigationController?.showShadowLine(color: AppColor.YellowFAB32A)
        } else {
            self.navigationController?.hideShadowLine()
        }
    }
    @objc func btnBackTapped() {
        if let complete = self.backTapped {
            complete()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func setNavigationTitle(title: String) {
        self.title = title
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: AppColor.BlackShadow,
             NSAttributedString.Key.font: AppFont.Raleway_Bold_18]
    }
    
    
    func setupNav(titleNav: String){
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = titleNav
        
        navigationController?.navigationBar.barTintColor = .white //Background
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white] //Text Color
        navigationController?.navigationBar.titleTextAttributes = attributes
        
        let createBtn = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: nil)
        createBtn.tintColor = AppColor.YellowFAB32A
        navigationItem.rightBarButtonItem = createBtn
        let sortBtn = UIBarButtonItem(image: AppIcon.icThreeLine, style: .plain, target: self, action: nil)
        sortBtn.tintColor = AppColor.YellowFAB32A
        navigationItem.leftBarButtonItem = sortBtn
        sortBtn.target = self
        sortBtn.action = #selector(presentLeftMenu)
        
    }
    @objc func presentLeftMenu(){
        let menu = SlideMenuViewController(presenter: SlideMenuPresenter())
        menu.presenter.view = self // Auth Delegate
        menu.didTapMenuType = { MenuType in
            print(1,MenuType.rawValue)
            self.transitionToNewContent(MenuType)
        }
        let SlideMenu = SlideInTransition()
        SlideMenu.closeSlideMenu = {
            self.dismiss(animated: true, completion: nil)
        }
        menu.modalPresentationStyle = .overCurrentContext
        menu.transitioningDelegate = self
        self.present(menu,animated: true, completion: nil)
        
    }
    
    func transitionToNewContent(_ menuType: MenuType) {
        let title = String(describing: menuType).capitalized
        print(2,title,menuType.rawValue)
        switch menuType {
        case .Home:
            let Home = AppHomeViewController(presenter: AppHomePresenter())
            navigationController?.pushViewController(Home, animated: true)
        case .About:
            let About = AboutViewController(presenter: AboutPresenter())
            navigationController?.pushViewController(About, animated: true)
        case .Setting:
            let Setting = SettingViewController(presenter: SettingPresenter())
            navigationController?.pushViewController(Setting, animated: true)
        case .FavoriteEvent:
            let Favorite = FavoriteEventViewController(presenter: FavoriteEventPresenter())
            navigationController?.pushViewController(Favorite, animated: true)
        case .PrivacyPolicy:
            let Privacy = PrivacyPolicyViewController(presenter: PrivacyPolicyPresenter())
            navigationController?.pushViewController(Privacy, animated: true)
        case .Calendar:
            let Calendar = CalendarEventViewController(presenter: CalendarEventPresenter())
            navigationController?.pushViewController(Calendar, animated: true)
        case .Manage:
            let Setting = ManageViewController(presenter: ManagePresenter())
            navigationController?.pushViewController(Setting, animated: true)
        }
        
        
    }
    
    func transprentNav(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
    
    func showShadowLine(color:UIColor)
    {
        navigationController?.navigationBar.setValue(false, forKey: "hidesShadow")
        navigationController?.navigationBar.shadowImage = AppIcon.isCrown2
    }
    func hideShadowLine() {
        navigationController?.navigationBar.setValue(false, forKey: "hidesShadow")
    }
}

extension BaseViewController: SlideMenuViewProtocol {
    func checkAuthSuccess(role: String) {
        print(role,"Change")
        //        AppColor.YellowFAB32A = role == "Admin" ? #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.9803921569, green: 0.7019607843, blue: 0.1647058824, alpha: 1)
    }
    
    func checkAuthFailed() {
        print("Check Auth Failed")
    }
    
    func signOutSuccess() {
        print("OK")
        UserDefaults.standard.set(true, forKey: "status")
        Switcher.updateRootVC()
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    func signOutFailed() {
        print("OK") 
    }
}
extension UINavigationController
{
    func showShadowLine(color:UIColor)
    {
        navigationBar.setValue(false, forKey: "hidesShadow")
        navigationBar.shadowImage = AppIcon.isCrown2 //color.as1ptImage()
    }
    func hideShadowLine() {
        navigationBar.setValue(true, forKey: "hidesShadow")
    }
}
