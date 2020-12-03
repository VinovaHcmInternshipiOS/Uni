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

class SemesterScoreViewController: BaseViewController {

    @IBOutlet weak var viewScore: UIView!
    @IBOutlet weak var totalScore: UILabel!
    @IBOutlet weak var totalEvent: UILabel!
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbYear: UILabel!
    @IBOutlet weak var lbSemester: UILabel!
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
        for i in 0..<dataSemester.count {
           presenter.fetchHistoryEvent(keyEvent: (dataSemester[i]?.Key)!)
        }
        

    }
    func loadLabel() {
        lbYear.text = dataLabelYear
        lbSemester.text = dataLabelSemester
    }
    
    func setupLanguage(){
        totalEvent.text = AppLanguage.Semester.TotalEvent.localized
        totalScore.text = AppLanguage.Semester.TotalScore.localized
    }

    func setupUI(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SemesterCell", bundle: nil), forCellReuseIdentifier: "SemesterCell")
        viewUser.roundCorners([.topLeft,.topRight], radius: 20)
        viewScore.backgroundColor = AppColor.YellowFAB32A
    }
}

extension SemesterScoreViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SemesterCell", for: indexPath) as? SemesterCell {
            cell.lbTitle.text = detailHistory[indexPath.row]?.title ?? ""
            cell.lbDate.text = getFormattedDate(date: detailHistory[indexPath.row]?.date ?? "")
            cell.lbTime.text = formatterTime(time: detailHistory[indexPath.row]?.checkin ?? "")
            cell.lbScore.text = "+\(detailHistory[indexPath.row]?.score ?? 0)"
            if let eventURL = detailHistory[indexPath.row]?.urlImage {
                cell.imgView.loadImage(urlString: eventURL)
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
        tableView.reloadData()
    }
    
    func fetchHistoryEventFailed() {
        print("fetch history failed")
    }
    
    
}
