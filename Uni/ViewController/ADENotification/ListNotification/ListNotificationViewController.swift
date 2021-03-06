//
//  ListNotificationViewController.swift
//  Uni
//
//  Created nguyen gia huy on 27/12/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import UIKit
import Charts
import SkeletonView
import SVProgressHUD
class ListNotificationViewController: BaseViewController {
    
    @IBOutlet weak var viewbtDelete: UIView!
    @IBOutlet weak var viewbtCreate: UIView!
    @IBOutlet weak var btCreateNoti: UIButton!
    @IBOutlet weak var btDeteleAll: UIButton!
    @IBOutlet weak var lbNoData: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var pullControl = UIRefreshControl()
    var listNotification = [NotificationAdmin?]()
    var presenter: ListNotificationPresenterProtocol

	init(presenter: ListNotificationPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "ListNotificationViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        presenter.view = self
        presenter.countUser()
        presenter.fetchNotification()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ListNotificationCell", bundle: nil), forCellReuseIdentifier: "ListNotificationCell")
        tableView.register(UINib(nibName: "HeaderTableView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderTableView")
        addBackToNavigation()
        pullRefreshData()
        pullControl.tintColor = AppColor.YellowFAB32A
        viewbtDelete.shadowColor = AppColor.YellowShadow
        viewbtCreate.shadowColor = AppColor.YellowShadow
        btDeteleAll.setImage(AppIcon.icRemoveYellow, for: .normal)
        btCreateNoti.setImage(AppIcon.icPlusYellow, for: .normal)
        skeletonView()
        
    }
    


    func skeletonView(){
        tableView.isSkeletonable = true
        tableView.showAnimatedSkeleton(usingColor: UIColor.clouds, animation: nil, transition:.crossDissolve(0.25))
    }
    
    @objc func pulledRefreshControl(sender:AnyObject) {
        showSpinner()
        listNotification.removeAll()
        refreshListNotification()
        
    }
    
    func refreshListNotification() {
        skeletonView()
        presenter.fetchNotification()
        
    }
    
    private func pullRefreshData() {
        pullControl.addTarget(self, action: #selector(pulledRefreshControl), for: UIControl.Event.valueChanged)
        tableView.addSubview(pullControl)

    }
    
    func remakeData(){
        listNotification = presenter.infoNotification
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        tableView.scrollToRow(at: IndexPath(row: listNotification.count - 1, section: 0), at: .middle, animated: true)
        tableView.performBatchUpdates {
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            hideSkeletonView()
        } completion: { [self] (Bool) in
            SVProgressHUD.dismiss()
            
        }
       
        checkEmptyData()
    }
    
    func hideSkeletonView(){
        pullControl.endRefreshing()
        tableView.hideSkeleton()
    }
    
    func checkEmptyData(){
        if presenter.infoNotification.count != 0 {
            lbNoData.isHidden = true
        } else {
            lbNoData.isHidden = false
        }
    }
    @IBAction func actionDelete(_ sender: Any) {
        presentAlertWithTitle(title: AppLanguage.Confirm.localized, message: AppLanguage.HandleConfirm.DeleteNotification7Days.localized, options: AppLanguage.Cancel.localized,AppLanguage.Ok.localized) { [self](Int) in
            switch Int {
            case 0: break
            default:
                presenter.deleteNotiAfter7day(dateCurrent: is12hClockFormat() == true ? (formatterDateTime12h(time: getCurrentDateTime12h()).toDateTimeFormat(format: "dd-MM-yyyy hh:mma")) : (formatterDateTime24h(time: getCurrentDateTime12h()).toDateTimeFormat(format: "dd-MM-yyyy HH:mm")), isClockFormat12h: is12hClockFormat())
            }

        }

    }
    @IBAction func actionCreate(_ sender: Any) {
        let pushNoti = PushNotificationViewController(presenter: PushNotificationPresenter())
        pushNoti.refreshlistNotification = { [self] in
            showSpinner()
            listNotification.removeAll()
            refreshListNotification()
        }
        navigationController?.pushViewController(pushNoti, animated: true)
    }
}
extension ListNotificationViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "ListNotificationCell"
        
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNotification.count
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
}


extension ListNotificationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if let listNotification = listNotification[indexPath.row] {
            tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
            hideSkeletonView()
            let contentNotification = ContentNotificationViewController(presenter: ContentNotificationPresenter())
            contentNotification.titleNoti = "\(listNotification.title ?? "")"
            contentNotification.contentNoti = "\(listNotification.content ?? "")"
            contentNotification.modalPresentationStyle = .overCurrentContext
            present(contentNotification, animated: false, completion: nil)
            
        } else {return}
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { [self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                presentAlertWithTitle(title: AppLanguage.Confirm.localized, message: AppLanguage.HandleConfirm.DeleteNotification.localized, options: AppLanguage.Cancel.localized,AppLanguage.Ok.localized) { (Int) in
                    switch Int {
                    case 0: break
                    default:
                        if let keyNotification = listNotification[indexPath.row]?.keyNotification {
                            presenter.removeNotification(keyNotification:keyNotification)
                        } else {return}
                    }
                    
                }
                
                     success(true)
                 })
    
            deleteAction.image = AppIcon.icRemoveYellow
            deleteAction.backgroundColor = .lightText
    
                 return UISwipeActionsConfiguration(actions: [deleteAction])
        }
}

extension ListNotificationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return headerTableView(numberOfLine: 2, labelColor: .black, labelFont: AppFont.Raleway_Light_40, titleHeader: AppLanguage.ListNotification.ListNotification.localized, leftAnchor: 10, topAnchor: 35)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ListNotificationCell", for: indexPath) as? ListNotificationCell {
            let calendar = Calendar.current
            let componentsTime = calendar.dateComponents([.day,.month,.year,.hour,.minute,.second], from: is12hClockFormat() == true ? (formatterDateTime12h(time: listNotification[indexPath.row]?.date ?? "").toDateTimeFormat(format: "dd-MM-yyyy hh:mma")) : (formatterDateTime24h(time: listNotification[indexPath.row]?.date ?? "").toDateTimeFormat(format: "dd-MM-yyyy HH:mm")) , to: is12hClockFormat() == true ? (formatterDateTime12h(time: getCurrentDateTime12h()).toDateTimeFormat(format: "dd-MM-yyyy hh:mma")) : (formatterDateTime24h(time: getCurrentDateTime12h()).toDateTimeFormat(format: "dd-MM-yyyy HH:mm")))
            cell.lbTitle.text = "\(listNotification[indexPath.row]?.title ?? "")"
            cell.lbDate.text = " \(is12hClockFormat() == true ? formatterDateTime12h(time: listNotification[indexPath.row]?.date ?? "") : listNotification[indexPath.row]?.date ?? "")"
            
            cell.lbDateTime.text = "\(componentsTime.day == 0 ? (componentsTime.hour == 0 ? (componentsTime.minute == 0 ? AppLanguage.JustNow.localized : "\(componentsTime.minute ?? 0)\(AppLanguage.Minutes.localized)") : "\(componentsTime.hour ?? 0)\(AppLanguage.Hours.localized)") : "\(componentsTime.day ?? 0)\(AppLanguage.Day.localized)")"
            cell.customizeChart(values: (listNotification[indexPath.row]?.statistical)!.map{ Double($0) })
            switch listNotification[indexPath.row]?.stateCell {
            case true:
                cell.btShow.isHidden = true
                cell.stackViewChart.isHidden = false
                cell.stackViewBtHide.isHidden = false
            default:
                cell.btShow.isHidden = false
                cell.stackViewChart.isHidden = true
                cell.stackViewBtHide.isHidden = true
            }
            
            cell.showViewChart = { [self] in
                listNotification[indexPath.row]?.stateCell = true
                UIView.animate(withDuration: 0.1) {
                    cell.btShow.isHidden = true
                    cell.stackViewChart.isHidden = false
                    cell.stackViewBtHide.isHidden = false
                }
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            cell.hideViewChart = { [self] in
                listNotification[indexPath.row]?.stateCell = false
                cell.btShow.isHidden = false
                UIView.animate(withDuration: 0.1) {
                    cell.stackViewChart.isHidden = true
                    cell.stackViewBtHide.isHidden = true
                }
                tableView.beginUpdates()
                tableView.endUpdates()
            }
         
            return cell
        } else {return UITableViewCell()}
    }
    
    
}

extension ListNotificationViewController: ListNotificationViewProtocol {
    func removeNotificationSuccess() {
        presentAlertWithTitle(title: AppLanguage.HandleSuccess.Success.localized, message: AppLanguage.HandleSuccess.deleteNotification.localized, options: AppLanguage.Ok.localized) { [self] (Int) in
            SVProgressHUD.dismiss()
            listNotification.removeAll()
            refreshListNotification()
        }
    }
    
    func removeNotificationFailed() {
        presentAlertWithTitle(title: AppLanguage.HandleError.anError.localized, message: AppLanguage.HandleError.deleteNotification.localized, options: AppLanguage.Ok.localized) { (Int) in}
    }
    
    func fetchNotificationSuccess() {
        remakeData()
    }
    
    func fetchNotificationFailed() {
        checkEmptyData()
        SVProgressHUD.dismiss()
        hideSkeletonView()
        pullControl.endRefreshing()
        
    }
}
