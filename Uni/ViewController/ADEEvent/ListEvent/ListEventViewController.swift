//
//  ListEventViewController.swift
//  Uni
//
//  Created nguyen gia huy on 23/11/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import UIKit
import SkeletonView
import SVProgressHUD
class ListEventViewController: BaseViewController {

    

    @IBOutlet weak var lbNoData: UILabel!
    @IBOutlet weak var btCreate: UIButton!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var presenter: ListEventPresenterProtocol
    var ListEvent = [Event?]()
    var clearSearchText: (()->Void)? = nil
    var getkeySearch: (()->Void)? = nil
    var deleteActionHandler: ((UIAlertAction) -> Void)? = nil
    var cancelActionHandler: ((UIAlertAction) -> Void)? = nil
    private var pullControl = UIRefreshControl()
	init(presenter: ListEventPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "ListEventViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
        super.viewDidLoad()

        presenter.view = self
        setupUI()
        setupLanguage()
        SVProgressHUD.show()
        presenter.fetchEvent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func setupLanguage(){
        lbNoData.text = AppLanguage.HandleError.noData.localized
    }
    
    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ListEventCell", bundle: nil), forCellWithReuseIdentifier: "ListEventCell")
        collectionView.register(UINib(nibName: "HeaderAttendance", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderAttendance")
        
        collectionView.register(UINib(nibName: "HeaderAttendance", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HeaderAttendance")
        viewButton.shadowColor = AppColor.YellowShadow
        btCreate.setImage(AppIcon.icPlusYellow, for: .normal)
        pullControl.tintColor = AppColor.YellowFAB32A
        collectionView.alwaysBounceVertical = true
        skeletonView()
        pullRefreshData()
        
    }
    
    func skeletonView(){
        collectionView.isSkeletonable = true
        collectionView.showAnimatedSkeleton(usingColor: UIColor.clouds, animation: nil, transition:.crossDissolve(0.25))
    }
    
    func refreshListEvent() {
        skeletonView()
       // presenter.infoEvent.removeAll()
        presenter.fetchEvent()
    }
    
    @objc func pulledRefreshControl(sender:AnyObject) {
        clearSearchText?()
        refreshListEvent()
        
    }
    
    private func pullRefreshData() {
        pullControl.addTarget(self, action: #selector(pulledRefreshControl), for: UIControl.Event.valueChanged)
        
        collectionView.addSubview(pullControl)

    }
    
    @IBAction func createEvent(_ sender: UIButton) {
        let createEvent = CreateEventViewController(presenter: CreateEventPresenter())
        navigationController?.pushViewController(createEvent, animated: true)
        createEvent.refreshListEvent = { [self] in
            refreshListEvent()
        }
    }

    @objc func actionSearch(sender: UIButton) {
        
        lbNoData.isHidden = true
        getkeySearch?()
    }
    
    
    func remakeData(){
        ListEvent = presenter.infoEvent
        collectionView.hideSkeleton()
        collectionView.insertItems(at: [IndexPath(row: presenter.infoEvent.count - 1, section: 0)])
        collectionView.performBatchUpdates({
            collectionView.reloadItems(at: [IndexPath(row: presenter.infoEvent.count - 1, section: 0)])
        }){_ in
            // optional closure
            print("finished updating cell")
        }
        
        checkEmptyData()
    }
    
    func checkEmptyData(){
        if presenter.infoEvent.count != 0 {
            lbNoData.isHidden = true
        } else {
            ListEvent.removeAll()
            lbNoData.isHidden = false
        }
    }
    
    func checkTime24h() -> [String] {
        return [is12hClockFormat() == true ? formatterTime12h(time: presenter.checkinEvent ?? "") : presenter.checkinEvent ?? "",is12hClockFormat() == true ? formatterTime12h(time: presenter.checkoutEvent ?? "") : presenter.checkoutEvent ?? ""]
    }

}

extension ListEventViewController: SkeletonCollectionViewDataSource {
  func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
    return "ListEventCell"
  }
  func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return ListEvent.count
  }
  func collectionSkeletonView(_ skeletonView: UICollectionView, supplementaryViewIdentifierOfKind: String, at indexPath: IndexPath) -> ReusableCellIdentifier? {
    return "HeaderAttendance"
  }
  func numSections(in collectionSkeletonView: UICollectionView) -> Int {
    return 1
  }
    
}

extension ListEventViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 1, height: 340 )
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        
        case UICollectionView.elementKindSectionHeader:
            
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderAttendance", for: indexPath) as? HeaderAttendance {
                headerView.txtSearch.placeholder = AppLanguage.SearchEvent.Search.localized
                headerView.backgroundColor = .none
                headerView.lbTotal.isHidden = true
                headerView.lbHeader.text = AppLanguage.ListEvent.ListEvent.localized
                getkeySearch = { [self] in
                    if let keySearch = headerView.txtSearch.text {
                        if removeWhiteSpaceAndLine(text: keySearch) == "" {
                            presenter.fetchEvent()
                        }
                        else {
                            skeletonView()
                            SVProgressHUD.show()
                            presenter.fetchEventResult(keySearch: keySearch.lowercased())
                        }
                        
                    } else {return}
                    
                }
                clearSearchText = {
                    headerView.txtSearch.text = ""
                }
                headerView.btSearch.addTarget(self, action: #selector(actionSearch(sender:)), for: .touchUpInside)
                
                
                return headerView
            } else {
                return UICollectionReusableView()
            }
            
        case UICollectionView.elementKindSectionFooter:
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderAttendance", for: indexPath) as? HeaderAttendance {
                    return headerView
            } else {return UICollectionReusableView()}
            
        default:
            
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0000001
      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0000001
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 230 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
}

extension ListEventViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ListEvent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let AttendanceEvent = AttendanceEventViewController(presenter: AttendanceEventPresenter())
        AttendanceEvent.keyDetailEvent = (ListEvent[indexPath.row]?.key)!
        navigationController?.pushViewController(AttendanceEvent, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListEventCell", for: indexPath) as? ListEventCell, let ListEvent = ListEvent[indexPath.row] {
            cell.dateEvent.text = "\(getFormattedDate(date: ListEvent.date ?? ""))\n\((ListEvent.checkin ?? "").toTimeFormat(format: checkFormatTime12h()))-\((ListEvent.checkout ?? "").toTimeFormat(format: checkFormatTime12h()))"

            cell.titleEvent.text = ListEvent.title
            if let imageEvent = ListEvent.urlImage {
                cell.imgEvent.sd_setImage(with: URL(string: imageEvent), completed: nil)
                //cell.imgEvent.loadImage(urlString: profileURL)
            }
            cell.delete = { [self] in
                presentAlertWithTitle(title: AppLanguage.Confirm.localized, message: AppLanguage.DeleteEvent.localized, options: AppLanguage.Cancel.localized,AppLanguage.Ok.localized) { (Int) in
                    switch Int {
                    case 0: break
                    default:
                        presenter.removeEvent(keyEvent: (ListEvent.key)!)
                    }
                    
                }
            }
            cell.update = { [self] in
                _ = UpdateEventViewController(presenter: UpdateEventPresenter(keyEvent: (ListEvent.key)!))
                presenter.getDateTimeEvent(keyEvent: (ListEvent.key)!)

            }
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
    
}

extension ListEventViewController: ListEventViewProtocol{
    func getDateTimeEventSuccess(keyEvent: String) {
        let formatDate = checkFormatDateTime12h()
        if let dateCurrent = transformStringDate(getCurrentDateTime12h(), fromDateFormat: formatDate, toDateFormat: formatDate), let dateCheckinEvent = transformStringDate("\(presenter.dateEvent ?? "") \(checkTime24h()[0])", fromDateFormat: formatDate, toDateFormat: formatDate),let dateCheckoutEvent = transformStringDate("\(presenter.dateEvent ?? "") \(checkTime24h()[1])", fromDateFormat: formatDate, toDateFormat: formatDate) {
            
            if Int(dateCurrent.toDateTimeFormat(format: formatDate).timeIntervalSince1970) >= Int(dateCheckinEvent.toDateTimeFormat(format: formatDate).timeIntervalSince1970)  && Int(dateCurrent.toDateTimeFormat(format: formatDate).timeIntervalSince1970) <= Int(dateCheckoutEvent.toDateTimeFormat(format: formatDate).timeIntervalSince1970){
                presentAlertWithTitle(title: AppLanguage.HandleError.anError.localized, message: AppLanguage.HandleError.updateOngoingEvent.localized, options: AppLanguage.Ok.localized) { (Int) in}
            } else if Int(dateCurrent.toDateTimeFormat(format: formatDate).timeIntervalSince1970) > Int(dateCheckoutEvent.toDateTimeFormat(format: formatDate).timeIntervalSince1970) {
                presentAlertWithTitle(title: AppLanguage.HandleError.anError.localized, message: AppLanguage.HandleError.updateEndedEvent.localized, options: AppLanguage.Ok.localized) { (Int) in}
           
            } else {
                let updateEvent = UpdateEventViewController(presenter: UpdateEventPresenter(keyEvent:keyEvent))
                updateEvent.updateListEvent = { [self] in
                    refreshListEvent()
                }
                navigationController?.pushViewController(updateEvent, animated: true)
            }
        } else {return}
    }
    
    func getDateTimeEventFailed() {
        
    }
    
    func checkJoinerSuccess() {
        SVProgressHUD.dismiss()
        checkEmptyData()
        print("Cannot remove event")
    }

    func checkJoinerFailed(keyEvent:String) {
        SVProgressHUD.dismiss()
        checkEmptyData()
    }
    
    func removeEventSuccess() {
        refreshListEvent()
        SVProgressHUD.dismiss()
        checkEmptyData()
        print("remove event success")
    }
    
    func removeEventFailed() {
        SVProgressHUD.dismiss()
        print("remove event failed")
    }
    
    func fetchEventSearchSuccess() {
        remakeData()
    }
    
    func fetchEventSearchFailed() {
        //remakeData()
        SVProgressHUD.dismiss()
        collectionView.hideSkeleton()
        checkEmptyData()
        collectionView.reloadData()

    }
    
    func fetchEventSuccess() {
        remakeData()
        pullControl.endRefreshing()
        SVProgressHUD.dismiss()
    }
    
    func fetchEventFailed() {
        checkEmptyData()
        print("fetch list event failed")
        pullControl.endRefreshing()
        collectionView.hideSkeleton()
        //collectionView.reloadData()
    }
    
    func eventExistUser() {
        presentAlertWithTitle(title: AppLanguage.HandleError.anError.localized, message: AppLanguage.HandleError.eventExistUser.localized, options: AppLanguage.Ok.localized) { (Int) in}
    }
    
}
    
