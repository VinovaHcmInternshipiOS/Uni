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

class SearchAppHomeViewController: BaseViewController {
    
    @IBOutlet weak var lbNoData: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var pullControl = UIRefreshControl()
    var getkeySearch: (()->Void)? = nil
    var clearSearchTextField: (()->Void)? = nil
    var presenter: SearchAppHomePresenterProtocol
    var listResultsEvent = [Event?]()
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
        pullRefreshData()
    }
    
    func skeletonView() {
        tableView.isSkeletonable = true
        tableView.showAnimatedSkeleton(usingColor: UIColor.clouds, animation: nil, transition:.crossDissolve(0.25))
    }
    
    @objc func pullRefreshControl(sender:AnyObject) {
        lbNoData.isHidden = true
        listResultsEvent.removeAll()
        getkeySearch?()
        clearSearchTextField?()
        
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
        showSpinner()
        listResultsEvent.removeAll()
        getkeySearch?()
    }
    
    func remakeData(){
        listResultsEvent = presenter.resultsEvent
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        tableView.performBatchUpdates {
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        } completion: { [self] (Bool) in
            removeSpinner()
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
            getkeySearch = { [self] in
                skeletonView()
                presenter.fetchEvent(keyEvent: headerView.txtSearch.text!)
            }
            clearSearchTextField = {
                headerView.txtSearch.text = ""
            }
            headerView.btSearch.addTarget(self, action: #selector(actionSearch(sender:)), for: .touchUpInside)
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
        if indexPath.section != 0 {
            let detailEvent = DetailEventViewController(presenter: DetailEventPresenter())
            detailEvent.keyDetailEvent = (listResultsEvent[indexPath.row]?.key)!
            self.navigationController?.pushViewController(detailEvent, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell {
            cell.contentView.layer.cornerRadius = 20
            
            cell.titleEvent.text = listResultsEvent[indexPath.row]?.title ?? ""
            cell.dateEvent.text = "\(getFormattedDate(date: listResultsEvent[indexPath.row]?.date ?? "")) \(formatterTime(time: listResultsEvent[indexPath.row]?.checkin ?? ""))-\(formatterTime(time: listResultsEvent[indexPath.row]?.checkout ?? ""))"
            if let eventURL = listResultsEvent[indexPath.row]?.urlImage {
                cell.imgEvent.loadImage(urlString: eventURL)
            }
            return cell
        } else {
            return UITableViewCell()
            
        }
    }
    
    
    
}

extension SearchAppHomeViewController: SearchAppHomeViewProtocol{
    func fetchEventSuccess() {
        remakeData()
    }
    
    func fetchEventFailed() {
        //listResultsEvent.removeAll()
        removeSpinner()
        tableView.hideSkeleton()
        checkEmptyData()
        pullControl.endRefreshing()
    }
    
    
}
