//
//  SearchAppHomeViewController.swift
//  Uni
//
//  Created nguyen gia huy on 06/11/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import UIKit
import SkeletonView
import SVProgressHUD

class SearchAppHomeViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lbNoData: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var pullControl = UIRefreshControl()
    var getkeySearch: (()->Void)? = nil
    var clearSearchTextField: (()->Void)? = nil
    var presenter: SearchAppHomePresenterProtocol
    var listResultsEvent = [Event?]()
    var updateLikeHomeVC: ((_ keyEvent: String,_ stateLike:Bool)->Void)? = nil
    init(presenter: SearchAppHomePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "SearchAppHomeViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self
        setupUI()
        setupLanguage()
    }
    
    func setupLanguage() {
        lbNoData.text = AppLanguage.HandleError.noData.localized
    }
    func setupUI(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellReuseIdentifier: "SearchResultCell")
        tableView.register(UINib(nibName: "SearchEventTextFieldHeader", bundle: nil), forCellReuseIdentifier: "SearchEventTextFieldHeader")
        
        tableView.register(UINib(nibName: "SearchEventTextFieldHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "SearchEventTextFieldHeader")
        pullControl.tintColor = AppColor.YellowFAB32A
        tableView.alwaysBounceVertical = true
        lbNoData.isHidden = true
        // pullRefreshData()
    }
    
    func skeletonView() {
        tableView.isSkeletonable = true
        tableView.showAnimatedSkeleton(usingColor: UIColor.clouds, animation: nil, transition:.crossDissolve(0.25))
    }
    
    @objc func pullRefreshControl(sender:AnyObject) {
        lbNoData.isHidden = true
        listResultsEvent.removeAll()
        getkeySearch?()
        //clearSearchTextField?()
        
    }
    
    private func pullRefreshData() {
        pullControl.addTarget(self, action: #selector(pullRefreshControl), for: UIControl.Event.valueChanged)
        tableView.addSubview(pullControl)
        
    }
    
    
    
    @objc func gotoDetailEvent() {
        let detailEvent = DetailEventViewController(presenter: DetailEventPresenter())
        self.navigationController?.pushViewController(detailEvent, animated: true)
    }
    
    @objc func actionSearch(sender: UIButton) {
        lbNoData.isHidden = true
        SVProgressHUD.show()
        listResultsEvent.removeAll()
        getkeySearch?()
    }
    
    func remakeData(){
        listResultsEvent = presenter.resultsEvent
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        tableView.performBatchUpdates {
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        } completion: { [self] (Bool) in
            SVProgressHUD.dismiss()
            pullControl.endRefreshing()
        }
        tableView.hideSkeleton()
        checkEmptyData()
    }
    
    func checkEmptyData(){
        if listResultsEvent.count != 0 {
            lbNoData.isHidden = true
        } else {
            lbNoData.isHidden = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(actionSearch(sender:)),
            object: textField)
        self.perform(
            #selector(actionSearch(sender:)),
            with: textField,
            afterDelay: 1)
        return true
    }
}

extension SearchAppHomeViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "SearchResultCell"
        
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listResultsEvent.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, identifierForHeaderInSection section: Int) -> ReusableHeaderFooterIdentifier? {
        return "SearchEventTextFieldHeader"
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
}

extension SearchAppHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SearchEventTextFieldHeader") as? SearchEventTextFieldHeader {
            headerView.contentView.backgroundColor = .white
            headerView.lbHeader.text = AppLanguage.SearchEvent.SearchEvent.localized
            headerView.txtSearch.placeholder = AppLanguage.SearchEvent.Search.localized
            headerView.btSearch.backgroundColor = AppColor.YellowFAB32A
            headerView.viewButton.backgroundColor = AppColor.YellowFAB32A
            headerView.txtSearch.delegate = self
            getkeySearch = { [self] in
                skeletonView()
                if let keySearch = headerView.txtSearch.text {
                    presenter.fetchEvent(keySearch: keySearch.lowercased())
                } else {return}
                
            }
            clearSearchTextField = {
                headerView.txtSearch.text = ""
            }
            // headerView.btSearch.addTarget(self, action: #selector(actionSearch(sender:)), for: .touchUpInside)
            return headerView
        } else { return UIView()}
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 230
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

extension SearchAppHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listResultsEvent.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // if indexPath.section != 0 {
            let detailEvent = DetailEventViewController(presenter: DetailEventPresenter())
        if let listResultsEvent = listResultsEvent[indexPath.row] {
            detailEvent.keyDetailEvent = listResultsEvent.key ?? ""
            detailEvent.stateLike = listResultsEvent.stateLike ?? false
            detailEvent.updateStateLike = { [self] state in
                listResultsEvent.stateLike = state
                tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
                tableView.hideSkeleton()
                updateLikeHomeVC?(listResultsEvent.key ?? "",state)
            }
            self.navigationController?.pushViewController(detailEvent, animated: true)
        } else {return}
            
        //}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell, let listResultsEvent = listResultsEvent[indexPath.row] {
            cell.contentView.layer.cornerRadius = 20
            cell.titleEvent.text = listResultsEvent.title ?? ""
            
            cell.dateEvent.text = "\(getFormattedDate(date: listResultsEvent.date ?? "")) \((listResultsEvent.checkin ?? "").toTimeFormat(format: checkFormatTime12h()))-\((listResultsEvent.checkout ?? "").toTimeFormat(format: checkFormatTime12h()))"
            listResultsEvent.stateLike == true ? cell.btLike.setImage(AppIcon.icLove, for: .normal) : cell.btLike.setImage(AppIcon.icUnLove, for: .normal)
            cell.likeEvent = { [self] in
                switch listResultsEvent.stateLike {
                case true:
                    cell.btLike.setImage(AppIcon.icUnLove, for: .normal)
                    listResultsEvent.stateLike = false
                    presenter.isLikeEvent(keyEvent: listResultsEvent.key ?? "", stateLike: false)
                    updateLikeHomeVC?(listResultsEvent.key ?? "",false)
                default:
                    cell.btLike.setImage(AppIcon.icLove, for: .normal)
                    listResultsEvent.stateLike = true
                    presenter.isLikeEvent(keyEvent: listResultsEvent.key ?? "", stateLike: true)
                    updateLikeHomeVC?(listResultsEvent.key ?? "",true)
                }
            }
            if let eventURL = listResultsEvent.urlImage {
                cell.imgEvent.sd_setImage(with: URL(string: eventURL), completed: nil)
            }
            return cell
        } else {
            return UITableViewCell()
            
        }
    }
    
    
    
}

extension SearchAppHomeViewController: SearchAppHomeViewProtocol{
    func likeEventSuccess() {
        
    }
    
    func likeEventFailed() {
        
    }
    
    func fetchEventSuccess() {
        remakeData()
    }
    
    func fetchEventFailed() {
        SVProgressHUD.dismiss()
        tableView.hideSkeleton()
        checkEmptyData()
        pullControl.endRefreshing()
    }
    
    
}
