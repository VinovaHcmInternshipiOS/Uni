//
//  DetailEventViewController.swift
//  Uni
//
//  Created nguyen gia huy on 03/11/2020.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Edward
//

import UIKit

class DetailEventViewController: BaseViewController {

	var presenter: DetailEventPresenterProtocol
    @IBOutlet weak var lbDetail: UILabel!
    @IBOutlet weak var lbOverview: UILabel!
    @IBOutlet weak var iconPerson: UIButton!
    @IBOutlet weak var viewTimeLocation: UIView!
    @IBOutlet weak var joinEvent: UILabel!
    @IBOutlet weak var contentEvent: UILabel!
    @IBOutlet weak var titleEvent: UILabel!
    @IBOutlet weak var scoreEvent: UILabel!
    @IBOutlet weak var dateEvent: UILabel!
    @IBOutlet weak var addressEvent: UILabel!
    var keyDetailEvent = ""
	init(presenter: DetailEventPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "DetailEventViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLanguage()
        presenter.view = self
        presenter.getDetailEvent(keyEvent: keyDetailEvent)
        presenter.getJoinerEvent(keyEvent: keyDetailEvent)
        
    }
    
    func setupUI(){
        titleEvent.textColor = AppColor.YellowFAB32A
        joinEvent.textColor = AppColor.YellowFAB32A
        viewTimeLocation.backgroundColor = AppColor.YellowFAB32A
        iconPerson.tintColor = AppColor.YellowFAB32A
        scoreEvent.textColor = AppColor.YellowFAB32A
        
        
    }
    
    func setupLanguage(){
        lbDetail.text = AppLanguage.DetailEvent.Detail.localized
        lbOverview.text = AppLanguage.DetailEvent.Overview.localized
    }
    
}

extension DetailEventViewController: DetailEventViewProtocol {
    func fetchJoinerEventSuccess() {
        let joiner = presenter.joinerEvent
        if let joiner = joiner {
            joinEvent.text = "\(joiner)"
           
        } else { return }
    }
    
    func fetchJoinerEventFailed() {
        print("Fetch Joiner Event Failed")
    }
    
    func fetchDetailSuccess() {
        let detail = presenter.detailEvent
        if let detail = detail {
            titleEvent.text = detail.title
            contentEvent.text = detail.content
            scoreEvent.text = "\(detail.score ?? 0)"
            dateEvent.text = "\(getFormattedDate(date: detail.date ?? ""))\n\(formatterTime(time: detail.checkin ?? ""))-\(formatterTime(time: detail.checkout ?? ""))"
            addressEvent.text = detail.address
            //joinEvent.text = detail.joinEvent
           
        } else { return }
    }
    
    func fetchDetailFailed() {
        print("Fetch Detail Event Failed")
    }
    
    
    
}
class VerticalTopAlignLabel: UILabel {

    override func drawText(in rect:CGRect) {
        guard let labelText = text else {  return super.drawText(in: rect) }

        let attributedText = NSAttributedString(string: labelText, attributes: [NSAttributedString.Key.font: font!])
        var newRect = rect
        newRect.size.height = attributedText.boundingRect(with: rect.size, options: .usesLineFragmentOrigin, context: nil).size.height

        if numberOfLines != 0 {
            newRect.size.height = min(newRect.size.height, CGFloat(numberOfLines) * font.lineHeight)
        }

        super.drawText(in: newRect)
    }

}
