//
//  SemesterScoreViewController.swift
//  Uni
//
//  Created nguyen gia huy on 09/11/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import UIKit
import SkeletonView
import SVProgressHUD
class SemesterScoreViewController: BaseViewController {

    @IBOutlet weak var lbNoData: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewScore: UIView!
    @IBOutlet weak var totalScore: UILabel!
    @IBOutlet weak var totalEvent: UILabel!
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbYear: UILabel!
    @IBOutlet weak var lbSemester: UILabel!
    private var pullControl = UIRefreshControl()
    var presenter: SemesterScorePresenterProtocol
    var dataSemester = [History?]()
    var detailHistory = [DetailHistory?]()
    var dataLabelYear = "--"
    var dataLabelSemester = "Semester"
	init(presenter: SemesterScorePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "SemesterScoreViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        setupUI()
        setupLanguage()
        loadLabel()
        SVProgressHUD.show()
        fetchSemester()
        
        

    }
    func fetchSemester () {
        if dataSemester.count != 0 {
            lbNoData.isHidden = true
            for i in 0..<dataSemester.count {
               presenter.fetchHistoryEvent(keyEvent: (dataSemester[i]?.Key)!)
            }
        } else {
            lbNoData.isHidden = false
            hideSkeletonView()
        }
    }
    func loadLabel() {
        lbYear.text = dataLabelYear
        lbSemester.text = dataLabelSemester
    }
    
    func setupLanguage(){
        totalEvent.text = AppLanguage.Semester.TotalEvent.localized
        totalScore.text = AppLanguage.Semester.TotalScore.localized
        lbNoData.text = AppLanguage.HandleError.noData.localized
    }

    func setupUI(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SemesterCell", bundle: nil), forCellReuseIdentifier: "SemesterCell")
        viewUser.roundCorners([.topLeft,.topRight], radius: 20)
        viewScore.backgroundColor = AppColor.YellowFAB32A
        pullControl.tintColor = AppColor.YellowFAB32A
        skeletonView()
        pullRefreshData()
    }
    
    func skeletonView(){
        
        totalScore.isSkeletonable = true
        totalScore.showAnimatedSkeleton(usingColor: UIColor.clouds, animation: nil, transition:.crossDissolve(0.25))
        
        totalEvent.isSkeletonable = true
        totalEvent.showAnimatedSkeleton(usingColor: UIColor.clouds, animation: nil, transition:.crossDissolve(0.25))
        
        tableView.isSkeletonable = true
        tableView.showAnimatedSkeleton(usingColor: UIColor.clouds, animation: nil, transition:.crossDissolve(0.25))
    }
    
    func refreshListSemester() {
        skeletonView()
        
        for i in 0..<dataSemester.count {
           presenter.fetchHistoryEvent(keyEvent: (dataSemester[i]?.Key)!)
        }
    }
    
    @objc func pulledRefreshControl(sender:AnyObject) {
        SVProgressHUD.show()
        detailHistory.removeAll()
        refreshListSemester()
        
    }
    
    private func pullRefreshData() {
        pullControl.addTarget(self, action: #selector(pulledRefreshControl), for: UIControl.Event.valueChanged)
        scrollView.alwaysBounceVertical = true
        scrollView.addSubview(pullControl)

    }
    
    func hideSkeletonView(){
        pullControl.endRefreshing()
        SVProgressHUD.dismiss()
        tableView.hideSkeleton()
        totalScore.hideSkeleton()
        totalEvent.hideSkeleton()

        
    }
}

extension SemesterScoreViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "SemesterCell"
        
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailHistory.count
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
}

extension SemesterScoreViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.tableView.layoutIfNeeded()
        self.heightTableView.constant = self.tableView.contentSize.height
    }
    
}

extension SemesterScoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailHistory.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailEvent = DetailEventViewController(presenter: DetailEventPresenter())
        detailEvent.keyDetailEvent = (detailHistory[indexPath.row]?.key)!
        self.navigationController?.pushViewController(detailEvent, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SemesterCell", for: indexPath) as? SemesterCell,let detailHistory = detailHistory[indexPath.row] {
                cell.lbTitle.text = detailHistory.title ?? ""
                cell.lbDate.text = getFormattedDate(date: detailHistory.date ?? "")
                cell.lbTime.text = (detailHistory.checkin ?? "").toTimeFormat(format: checkFormatTime12h())
                cell.lbScore.text = "+\(detailHistory.score ?? 0)"
                if let eventURL = detailHistory.urlImage {
                    cell.imgView.sd_setImage(with: URL(string: eventURL), completed: nil)
                    
                }
                return cell
        } else { return UITableViewCell()}
    }
    
    
    
}

extension SemesterScoreViewController: SemesterScoreViewProtocol {
    func fetchHistoryEventSuccess() {
        var score = 0
        detailHistory = presenter.detailHistory
        totalEvent.text = AppLanguage.Semester.TotalEvent.localized + " \(detailHistory.count)"
        for i in 0..<dataSemester.count {
            score += (dataSemester[i]?.Score)!
            totalScore.text = AppLanguage.Semester.TotalScore.localized + " \(score)"
        }
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        tableView.performBatchUpdates {
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        } completion: { [self] (Bool) in
            hideSkeletonView()
            SVProgressHUD.dismiss()
        }

//        tableView.beginUpdates()
//        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
//        tableView.endUpdates()
       
    }
    
    func fetchHistoryEventFailed() {
        hideSkeletonView()
    }
    
    
}
