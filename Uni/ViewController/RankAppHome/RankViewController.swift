//
//  RankViewController.swift
//  Uni
//
//  Created nguyen gia huy on 05/11/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import UIKit

class RankViewController: UIViewController {

    @IBOutlet weak var lbScoreRank3: UILabel!
    @IBOutlet weak var lbNameRank3: UILabel!
    @IBOutlet weak var imgRank3: UIImageView!
    @IBOutlet weak var lbScoreRank1: UILabel!
    @IBOutlet weak var lbNameRank1: UILabel!
    @IBOutlet weak var imgRank1: UIImageView!
    @IBOutlet weak var lbScoreRank2: UILabel!
    @IBOutlet weak var lbNameRank2: UILabel!
    @IBOutlet weak var imgRank2: UIImageView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var viewScore: UIView!
    @IBOutlet weak var tableView: UITableView!
    var presenter: RankPresenterProtocol
    var rankEvent = [RankEvent?]()
	init(presenter: RankPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "RankViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
        super.viewDidLoad()

        presenter.view = self
        presenter.fetchRank()
        setupXIB()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewScore.roundCorners([.topLeft,.topRight], radius: 20)
    }
    
    func setupXIB(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RankTableViewCell", bundle: nil), forCellReuseIdentifier: "RankTableViewCell")
        
        
    }
    

}

extension RankViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankEvent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RankTableViewCell", for: indexPath) as? RankTableViewCell else { return UITableViewCell()}
            cell.lbRank.text = "\(indexPath.row)"
            cell.lbName.text = rankEvent[indexPath.row]?.name
            cell.lbScore.text = "\(rankEvent[indexPath.row]?.score ?? 0)"
        return cell
    }
    
    
}

extension RankViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.tableView.layoutIfNeeded()
        self.heightTableView.constant = self.tableView.contentSize.height
    }
}

extension RankViewController: RankViewProtocol {
    func fetchRankSuccess() {
        rankEvent = presenter.rankEvent
        for i in 0..<rankEvent.count {
            if i == 0 {
                lbNameRank1.text = rankEvent[i]?.name ?? ""
                lbScoreRank1.text = "\(rankEvent[i]?.score ?? 0)"
                if let eventURL = rankEvent[i]?.imgURL {
                    imgRank1.loadImage(urlString: eventURL)
                }
            } else if i == 1 {
                lbNameRank2.text = rankEvent[i]?.name ?? ""
                lbScoreRank2.text = "\(rankEvent[i]?.score ?? 0)"
                if let eventURL = rankEvent[i]?.imgURL {
                    imgRank2.loadImage(urlString: eventURL)
                }
            } else if i == 2 {
                lbNameRank3.text = rankEvent[i]?.name ?? ""
                lbScoreRank3.text = "\(rankEvent[i]?.score ?? 0)"
                if let eventURL = rankEvent[i]?.imgURL {
                    imgRank3.loadImage(urlString: eventURL)
                }
            }
        }
        tableView.reloadData()
    }
    
    func fetchRanhFailed() {
        print("fetch rank failed")
    }
    
    
}
